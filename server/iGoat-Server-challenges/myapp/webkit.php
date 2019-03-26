<?php
 require_once("SimpleRest.php");
 
 class cryptoKey extends SimpleRest{
 
 public function getKey(){
 
   $statusCode = 200;
   $keyValue = array("key"=>"66435@J0hn");
   
    $requestContentType = $_SERVER['HTTP_ACCEPT'];
    $this->setHttpHeaders($requestContentType, $statusCode);
    
    if(strpos($requestContentType,'application/json') !== false){
	    $response = $this->encodeJson($keyValue);
	    echo $response;
	 }
     else if(strpos($requestContentType,'text/html') !== false){
	    $response = $this->encodeHtml($keyValue);
		echo $response;
     }
  
   }
   
  public function encodeJson($responseData) {
		$jsonResponse = json_encode($responseData);
		return $jsonResponse;		
   }
  
  public function encodeHtml($responseData){
       $htmlResponse = "<table border='1'>";
	 foreach($responseData as $key=>$value){
	   $htmlResponse .= "<tr><td>".$key."</td><td>".$value."</td></tr>";   
	 }
	 $htmlResponse .= "</table>";
	 return $htmlResponse;
   }
 
 }

 if($_SERVER['REQUEST_METHOD'] === 'GET')
  {
    echo "Invalid attempt";
  }
  
  if($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST["token"]))
  {
    $token = $_POST["token"];
//    echo $_POST["token"];
  }
  
  switch($token){
 
  case "key": 
              $cryptokey = new cryptoKey();
              $cryptokey->getKey();
 
  }
  

?>
