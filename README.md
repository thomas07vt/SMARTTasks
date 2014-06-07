#S.M.A.R.T Tasks

## Overview

SMART tasks is a simple todo list app. Create multiple Todo lits, with multiple Todo Items. When an item is marked as complete, it will be removed from the list automatically, keeping you focued on the items to get done. Also, after 7 days, if you have not completed your Todo item, it will be automatically deleted from your list. 

S.M.A.R.T. Goals
Set your goals the SMART way.

Specific
Target a specific area for improvement.

Measurable
Quantify or at least suggest an indicator of progress.

Achievable
Set goals that you can accomplish.

Realistic
state what results can realistically be achieved, given available resources.

Time-bound
Specify when the result(s) can be achieved.


## API Docs

### Users

#### Index
* URL: /api/v1/users
* Method: GET
* Authentication: None
* Parameters: None
* Example:

    **Command:**
      > curl localhost:3000/api/v1/users

    **Response:** 
      >{
      >   "users":[
      >     {"id":1,"username":"thomas07"},
      >     {"id":2,"username":"testUser"},
      >     {"id":3,"username":"testUser2"},
      >     {"id":4,"username":"testUser3"}
      >   ]
      > }



#### Create
* URL: /api/v1/users/create
* Method: POST
* Authentication: Required
* Parameters: username, email, pass,
* Example:
    **Command:**
      curl localhost:3000/api/v1/users/create -d "username=testUser4&email=testUser4@test.com&password=password" -u 'thomas07@email.com:password'
    **Authenticated Response:** User was created successfully.
    **Unauthenticated Response:** HTTP Basic: Access denied.
    **Request Failure Resonse:** User creation failed.


### Lists

#### Index
* URL: /api/v1/lists
* Method: GET
* Authentication: None
* Parameters: user_id
* Example:

    **Command:**
   
      > curl localhost:3000/api/v1/lists?user_id=1
   
    **Authenticated Response:**
      >[
        {"id":13,"title":"New listname 9","user_id":1,"created_at":"2014-06-03T22:03:59.862Z","updated_at":"2014-06-05T23:42:28.995Z","permission":"open"},
        {"id":14,"title":"Testing newRoute","user_id":1,"created_at":"2014-06-04T17:28:04.398Z","updated_at":"2014-06-05T23:42:29.015Z","permission":"open"},
        {"id":15,"title":"Testing new route 2","user_id":1,"created_at":"2014-06-04T17:29:17.153Z","updated_at":"2014-06-05T23:42:29.022Z","permission":"open"},
        {"id":16,"title":"Testing new permissions","user_id":1,"created_at":"2014-06-04T19:01:52.153Z","updated_at":"2014-06-05T23:42:29.033Z","permission":"open"}
      ]


    **Unauthenticated Response:** 
      > HTTP Basic: Access denied.
      
    **Request Failure Resonse:** 
      > You are not authroized.

#### Show
* URL: /api/v1/lists/:id
* Method: GET
* Authentication: Required
* Parameters: id
* Example:
    **Command:**
      > curl localhost:3000/api/v1/lists/15 -u 'testUser@test.com:password'
    **Authenticated Response:**
      >
      {"list":
        {"id":15,"title":"Testing new route 2","user_id":1,"created_at":"2014-06-04T17:29:17.153Z","updated_at":"2014-06-05T23:42:29.022Z","permission":"open"},
        "todos":[
          {"id":23,"body":"Here is a todo item","list_id":15,"completed":false,"created_at":"2014-06-04T17:57:32.367Z","updated_at":"2014-06-04T17:57:32.367Z","position":null},{"id":22,"body":"created todo route","list_id":15,"completed":false,"created_at":"2014-06-05T2304T17:49:49.642Z","updated_at":"2014-06-04T17:49:49.642Z","position":null}
        ]
      }

    **Unauthenticated Response:** 
      > HTTP Basic: Access denied.
    **Request Failure Resonse:** 
      > You are not authroized.

#### Create
* URL: /api/v1/lists/create
* Method: POST
* Authentication: Required
* Parameters: user_id, list_title, permission (optional)
* Example:
    **Command:**
      > curl localhost:3000/api/v1/lists/create -d "user_id=1&list_title='my list title'&permission=open" -u 'testUser@test.com:password'
    **Authenticated Response:** 
      > List was created successfully.
    **Unauthenticated Response:**  
      > HTTP Basic: Access denied.
    **Request Failure Resonse:** 
      > List creation failed.

#### Update
* URL: /api/v1/lists/:id
* Method: PATCH/PUT
* Authentication: Required
* Parameters: id, list_title (optional), permission (optional)
* Example:
    **Command:**
      > curl --request PATCH localhost:3000/api/v1/lists/15 -d "list_title='my NEW list title'&permission=open" -u 'testUser@test.com:password'
    **Authenticated Response:** 
      > List was updated successfully.
    **Unauthenticated Response:** 
      > HTTP Basic: Access denied.
    **Request Failure Resonse:** 
      > You are not authroized.

#### Destroy
/api/v1/lists/:id
* URL: /api/v1/lists/:id
* Method: DELETE
* Authentication: Required
* Parameters: id
* Example:
    **Command:**
      > curl --request DELETE localhost:3000/api/v1/lists/15 -u 'testUser@test.com:password'
    **Authenticated Response:** 
      > List was deleted successfully.
    **Unauthenticated Response:** 
      > HTTP Basic: Access denied.
    **Request Failure Resonse:** 
      > List deletion failed.
    or
      > You are not authroized or this list does not exist.
