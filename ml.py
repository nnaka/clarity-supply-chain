import argparse
import tensorflow as tf
import numpy as np
#import urllib.request as ur
import pandas as pd
from sodapy import Socrata

#contents = ur.urlopen("https://data.opendatanetwork.com/resource/kgmb-gqyt.json").read()
#print(contents)

def get_data(data_name):
    client = Socrata("data.opendatanetwork.com", None)
    results = client.get(data_name, limit=10000)
    results_df = pd.DataFrame.from_records(results)
    return results_df

def main():
    '''
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
    parser.add_argument('--sum', dest='accumulate', action='store_const',
                    const=sum, default=max,
                    help='sum the integers (default: find the max)')
    args = parser.parse_args()
    print(args.accumulate(args.integers))
    '''
    print(get_data("kgmb-gqyt"))
    #print(get_data("kiis-5uss"))


if __name__ == "__main__":
    main()