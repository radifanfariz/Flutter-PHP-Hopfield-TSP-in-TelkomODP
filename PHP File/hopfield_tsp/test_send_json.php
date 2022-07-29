<?php
$jsonFile = file_get_contents("latlng_location_example.json");

// Setup cURL
$ch = curl_init('http://192.168.100.21/hopfield_tsp/hopfieldtspApi.php');
curl_setopt_array($ch, array(
    CURLOPT_POST => TRUE,
    CURLOPT_RETURNTRANSFER => TRUE,
    CURLOPT_HTTPHEADER => array(
        'Content-Type: application/json'
    ),
    CURLOPT_POSTFIELDS => $jsonFile
));

// Send the request
$response = curl_exec($ch);

// Check for errors
if($response === FALSE){
    die(curl_error($ch));
}

// Close the cURL handler
curl_close($ch);

// Print the date from the response
echo $response;

?>