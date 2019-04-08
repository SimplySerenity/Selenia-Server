# Selenia-Server
handles state for Selenia workers


## API
| Method  | Route | Params (as JSON) | Function | Response |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| POST | /pools/:pool_name | links:[]string | create the specified pool with the the given links as its initial content if it doesn't exist already | 201 if created otherwise 200 | 
| POST  | /pools/:pool_name/links  | links:[]string | pushes the array of links to the specified pool's queue | 200 |
| GET | /pools/:pool_name/links | N/A | returns the next link from the specified pool's queue | { link: "https://example.com" } |
