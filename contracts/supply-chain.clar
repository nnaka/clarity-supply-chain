;; Clarity contract

(define-constant app-name "SupplyChain")

;; The overall idea is each product i.e. Jacket is made up of different components
;; E.g. down the fills the jacket, the zippers, the fabric
;; Each one of these again has a manufacturer and a supplier (i.e. source chain)
;; Each supply chain is can also be represented as a principal: https://docs.blockstack.org/write-smart-contracts/principals#smart-contracts-as-principals
;; Therefore, by creating a tree-like structure of Principals


;; parent product (this is a smart-contract but also a Principal)
(define-data-var parent-product principal 'SP3GWX3NE58KXHESRYE4DYQ1S31PQJTCRXB3PE9SB)

;; get parent product Principal
(define-read-only (get-parent-product)
    (var-get parent-product))

;; check if a child product is the product itself
(define-private (dependency-is-allowed)
    (is-eq tx-sender (get-parent-product))
)

;; get the last page in endless-list
(define-private (get-source-page)
    (unwrap-panic (contract-call?
        .endless-list
        get-current-page))
)

;; get the supplier / product based on page index in endless-list
(define-private (get-child (page int))
    (unwrap-panic (contract-call?
        .endless-list
        get-items-map-at-page page))
)

;; get source
(define-read-only (get-source)
    (get-child (get-source-page))
)

;; search chain for a given supplier / child product
(define-read-only (contains-child (child principal))
    (filter or
        (map is-eq 
            (unwrap-panic (contract-call?
                    .endless-list
                    get-current-list))) child))

;; add an product to the list of child products
(define-private (add-to-parent (child principal))
    (unwrap-panic (contract-call?
        .endless-list
        add-item
        child))
)

;; add new sub product (i.e. child product) to endless-list
(define-public (add-child-product (child principal))
    (if
        (or (dependency-is-allowed) (not (contains-child (child))))
        (begin
            (add-to-parent child)
        )
        (err "The child-product cannot be added to this product.")))

;; what happens if your child product itself is a list that should be concatnated
(define-public (extend-parent (child principal))
    (if
        (dependency-is-allowed)
        (begin
            (concat (get-parent-product)
                    (unwrap-panic (contract-call?
                    .endless-list
                    get-current-list)))
        )
        (err "The child-product / supplier cannot be added to this product.")
    )

(define-read-only (get-latest-provenance)
    (append (unwrap-panic (contract-call?
                            .endless-list
                            get-current-list))
            (var-get current-owner))
)