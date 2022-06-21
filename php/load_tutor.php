<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$results_per_page = 5;
$pageno = (int)$_POST['pageno'];
$search = $_POST['search'];

$page_first_result = ($pageno - 1) * $results_per_page;

$sqlloadtutor = "SELECT tt.tutor_id, tt.tutor_email,tt.tutor_phone, tt.tutor_name, tt.tutor_password, tt.tutor_description, tt.tutor_datereg, GROUP_CONCAT(s.subject_name ORDER BY s.subject_id ASC) FROM tbl_tutors tt, tbl_subjects s WHERE tt.tutor_id=s.tutor_id AND tutor_name LIKE '%$search%' GROUP BY tt.tutor_id ASC";

$result = $conn->query($sqlloadtutor);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadtutor = $sqlloadtutor . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadtutor);
if ($result->num_rows > 0) {
    //do something
    $tutor["tutor"] = array();
    while ($row = $result->fetch_assoc()) {
        $ttlist = array();
        $ttlist['id'] = $row['tutor_id'];
        $ttlist['email'] = $row['tutor_email'];
        $ttlist['phone'] = $row['tutor_phone'];
        $ttlist['name'] = $row['tutor_name'];
        $ttlist['password'] = $row['tutor_password'];
        $ttlist['description'] = $row['tutor_description'];
        $ttlist['datereg'] = $row['tutor_datereg'];
        $ttlist['subjectname'] = $row['GROUP_CONCAT(s.subject_name ORDER BY s.subject_id ASC)'];
        array_push($tutor["tutor"],$ttlist);
    }
    $response = array('status' => 'success', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page", 'data' => $tutor);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page",'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>