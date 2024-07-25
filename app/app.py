from app_config import *


def get_all_breeds():
    url = f"{endpoint}v1/breeds"
    headers = {'x-api-key': f'{api_key}'}
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to fetch breeds: {response.status_code}")

def get_random_breeds(breeds, count=10):
    if len(breeds) < count:
        raise ValueError("Not enough breeds to select from")
    return random.sample(breeds, count)

def main():
    while True:
        try:
            breeds = get_all_breeds() # if data flow is slow -> this function should be before while loop.
            random_breeds = get_random_breeds(breeds)
            
            print("Random Dog Breeds:")
            for breed in random_breeds:
                print(breed['name'])
            
            print("\nWaiting for 60 seconds...\n")
            time.sleep(60)  # wait for 60 seconds before the next request
        except Exception as e:
            print(f"Error: {e}")
            break  # exit the loop if an error occurs

if __name__ == "__main__":
    main()
