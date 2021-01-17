;; ENDLESS-LIST contract is adapted from 
;; https://github.com/npdeep/clarity-provenance/blob/master/contracts/endless-list.clar


;; Changes: Instead of integers, we store principals. 
;; We have removed the authentication step where only an allowed-user 
;; can add items to the list. 


;; Create a map which will use a page number and contain ten items per page
(define-map items-map 
    ((page int))
    (
        (items (list 10 principal))   ;; the list of items
        (next int)              ;; the index of the next list for list traversal in case it isn't just +1
    )
)

;; Track the current page so we can easily add new items
(define-data-var current-list-page int -1)  ;; set to -1 at start so first move-to-next sets it to 0


;; Report the current page so consumers can plan for how long a list to expect
(define-read-only (get-current-page)
    (ok (var-get current-list-page))
)

;; Report the current list so consumers can confirm recent additions
(define-read-only (get-current-list)
    (ok (unwrap-panic (get items (get-items-map (var-get current-list-page)))))
)

;; Allow users to browse the pages at random
(define-read-only (get-items-map-at-page (page int))
    (ok (unwrap-panic (get-items-map page)))
)

;; Add a new item to the list by calling this function
;; Only the principal in allowed-user can change the list
(define-public (add-item (item principal))
    (if
        (current-list-has-room)
        (ok (add-to-current-list item))
        (ok (move-to-next-list-and-add item))
    )
)

;; Add the item to the current list
(define-private (add-to-current-list (item principal))
    (map-set items-map
        ((page (var-get current-list-page)))
        (
            (items (current-list-plus item))
            (next (+ (var-get current-list-page) 1))
        )
    )
)

;; get the items map without the OK wrapper
(define-private (get-items-map (page-id int))
    (map-get? items-map ((page page-id)))
)

;; return the current list with the item appended to maintain the max-length value
(define-private (current-list-plus (item principal))
    (unwrap-panic (as-max-len? (add-to-current-items item) u10))
)

;; add the item to the current items list
;; concat will increase the max-length of the list
(define-private (add-to-current-items (item principal))
    (concat (get items (unwrap-panic (get-items-map (var-get current-list-page)))) (list item))
)

;; check the current list exists and has less than 10 items in it
(define-private (current-list-has-room)
    (and
        (map-exists-at (var-get current-list-page))
        (less-than-ten-items-in-list-at (var-get current-list-page))
    )
)

;; confirm the map exists, this may not be the case for the first item or if a random page is looked up
(define-private (map-exists-at (page int))
    (is-some (get items (get-items-map page)))
)

;; private functions let us wrap complex checks in simple to read functions
(define-private (less-than-ten-items-in-list-at (page int))
    (> u10 (len (unwrap-panic (get items (get-items-map page)))))
)

;; advance the current list page and add a new map there, starting with given item
(define-private (move-to-next-list-and-add (item principal))
    (begin
        (var-set current-list-page (+ (var-get current-list-page) 1))
        (map-set items-map 
            (
                (page (var-get current-list-page))
            )
            (
                (items (unwrap-panic (as-max-len? (list item) u10)))
                (next (+ (var-get current-list-page) 1))
            )
        )
    )
)