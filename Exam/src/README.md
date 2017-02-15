API description

**Host**
	
	http://tw.chinacloudapp.cn:8000	


1. registration  

    **request**
	
	*POST* 	```/one_auth/api/user```
	
	*content_type=```'application/json'```*
	
       	{"email": "xxxx"}
	
	**response**
	201
	    
	    {
  	    	"email": "zhaogqxxxxxx@163.com",
  	    	"status": "deactived"
	    }
	
		
2. validation  

    **request**
	
	*PUT* 	```/one_auth/api/validation_code```
	
	*content_type=```'application/json'```*
	
        {"email": "xxxx", "validation_code": "xxxxxx"}
	
	**response**
	200
	
	    {
  	    	"message": "Valid code",
	    }
	
	422
	
	    {
  	    	"message": "Invalid code",
	    }


3. Update password  

    **request**
	
	*PUT* 	```/one_auth/api/user```
	
	*content_type=```'application/json'```*
	
       	{
			"email": "zhaogqxxxxxx@163.com",
			"validation_code": "xxxx",
			"password": "xxxxxx"
		}
	
	**response**
	200
	    
	    {
	        "email": "xxxx", 
	        "status": "active"
	    }
	    
	422
	
	    { "message": "User not exist" }

4. Get access token  

    **request**
	
	*GET* 	```/one_auth/api/access_tokens```
	
	*header*=```{'Authorization': 'Basic c29tZV9lbWFpbEBmZWVkYmFjay5jb206dGVzdF90b2tlbg=='}```
	
	
	**response**
	200
	    
	    {
            'access_token': "eyJhbGciOiJIUzI1NiJ9.InNvbWVfZW1haWxAZmVlZGJhY2suY29tIg.FilmY5Dz7_FgXkjJHekZa4-F3OaXVfShOOiVDfXNS7c"
        }
	    
	401
	
	    { "message": "Email or password is not correct" }
	   

5. Upload image

    **request**
    	
    *POST* 	```/one_auth/api/images```
    	
    *header*=```{'Authorization': 'Basic c29tZV9lbWFpbEBmZWVkYmFjay5jb206dGVzdF90b2tlbg=='}```
    	
    	
    **response**
    201
    
        {
            "url": "http://image_server/uri"
        }
    

6. Update user profile

     **request**
        	
    *PUT* 	```/one_auth/api/user/profile```
        	
    *header*=```{'Authorization': 'Basic c29tZV9lbWFpbEBmZWVkYmFjay5jb206dGVzdF90b2tlbg=='}```
    
        {
            "first_name": "Jennifer",
            "last_name": "Lee",
            "country": "China",
            "department": "BSC",
            "avatar": "http://testurl/image.png"
        }
        	
    **response**
    200
    
        {
            "first_name": "Jennifer",
            "last_name": "Lee",
            "country": "China",
            "department": "BSC",
            "avatar": "http://testurl/image.png",
            "access_token": "xxxxxxxx",
            "email": "some_user@feedback.com"
        }

7. Log out

    **request**

    *DELETE* 	```/one_auth/api/access_tokens```

    *header*=```{'Authorization': 'Basic c29tZV9lbWFpbEBmZWVkYmFjay5jb206dGVzdF90b2tlbg=='}```

    **response**
    200

    401

        { "message": "Email or token is not correct" }