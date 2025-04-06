import os
import json
import csv


folder_path = 'Data'

csv_output_file = 'C:\CODING\Python\Advanced\Projects\Data\CSV_combined'

csv_headers = ['bathrooms', 'bedrooms', 'city', 'country', 'currency', 'daysOnZillow',
               'homeStatus', 'homeType', 'imgSrc', 'latitude', 'longitude', 'livingArea',
               'lotAreaUnit', 'lotAreaValue', 'price', 'priceForHDP', 'rentZestimate',
               'state', 'streetAddress', 'taxAssessedValue', 'timeOnZillow', 'zestimate',
               'zipcode', 'zpid', 'listing_sub_type', 'isZillowOwned', 'isShowcaseListing',
               'homeStatusForHDP', 'isFeatured', 'isNonOwnerOccupied', 'isPreforeclosureAuction',
               'isUnmappable', 'shouldHighlight', 'isPremierBuilder', 'priceReduction', 'priceChange', 'datePriceChanged',
               'videoCount','open_house_info', 'openHouse','isRentalWithBasePrice','newConstructionType', 'unit', 'providerListingID',
               'comingSoonOnMarketDate']


def json_to_csv_merge(folder_path):
    with open(csv_output_file, mode='w', newline='', encoding='utf-8') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=csv_headers)
        writer.writeheader()

        for filename in os.listdir(folder_path):
            if filename.endswith('.json'):
                file_path = os.path.join(folder_path, filename)

                with open(file_path, 'r', encoding='utf-8') as json_file:
                    try:
                        data = json.load(json_file)
                        if "results" in data:
                            for entry in data["results"]:
                                filtered_entry = {key: entry.get(key, "") for key in csv_headers}
                                writer.writerow(filtered_entry)
                    except json.JSONDecodeError as e:
                        print(f"JSON error in {filename}: {e}")
                    except Exception as e:
                        print(f"Error in {filename}: {e}")


json_to_csv_merge(folder_path)
