<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phoneno = $_POST['phoneno'];
$pass = $_POST['pass'];
$pass = sha1($_POST['pass']);
$homeaddress = $_POST['homeaddress'];
$base64image = $_POST['image'];
$sqlinsert = "INSERT INTO `tbl_registration`( `user_name`, `user_email`, `user_phoneno`, `user_pass`, `user_homeaddress`) 
VALUES ('$name','$email','$phoneno','$pass','$homeaddress')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/user/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>