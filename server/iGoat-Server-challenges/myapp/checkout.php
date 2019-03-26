<?php   

echo "<h1> Checkout </h1>";

$checksum = $_POST['checksum'];
$secret = "H@cKIm_2@15*nu11(0N";

$newmsg = urldecode($_POST['msg']);


if($checksum === hash("sha256", $secret . $newmsg))
{
	$a = explode("|" , $newmsg);
        $price = end($a);
        echo $msg;
      
        if(is_numeric($price))
        {
            if($price == 0)
            {
                echo "Congratualtion You bought iPhone in ZERO dollar!";
                echo "Flag is BuG@2@i7}";
	
            }
            else
            {
                echo "You must buy iPhone in ZERO rupee";            
            }
                
        }
        else 
        {
     
            echo "Checksum Matched but Something went wrong";
            
            echo "price". $price;
        }
        
}
else
{
	echo "Fail! You must buy iPhone in ZERO rupee.\n";
        
}
?>  
