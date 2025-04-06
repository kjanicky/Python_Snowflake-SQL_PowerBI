import requests
import json
from dotenv import load_dotenv
import os

load_dotenv()
# Get environment variables
api_key = os.getenv("API_KEY")
api_host = os.getenv("API_HOST")
api_url = os.getenv("API_URL")
# Define search parameters for Zillow API
querystring = {"url":"https://www.zillow.com/ny/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22mapBounds%22%3A%7B%22north%22%3A46.07405224036752%2C%22south%22%3A39.31821662945082%2C%22east%22%3A-69.56825827343751%2C%22west%22%3A-81.97182272656251%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22mf%22%3A%7B%22value%22%3Afalse%7D%2C%22con%22%3A%7B%22value%22%3Afalse%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22manu%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A7%7D"
,"page":"1","output":"json","listing_type":"by_agent"}

headers = {
		"x-rapidapi-key": api_key,
		"x-rapidapi-host": api_host
	}

response = requests.get(api_url, headers=headers, params=querystring)
if response.status_code == 200:
    data = response.json()


    with open("House_data_page_state_1.json", "w") as file:
        json.dump(data, file, indent=4)
