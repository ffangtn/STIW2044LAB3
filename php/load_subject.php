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
$subrating = $_POST['subrating'];

$page_first_result = ($pageno - 1) * $results_per_page;

if ( $subrating=="All"){
$sqlloadsubject = "SELECT * FROM tbl_subjects as s LEFT JOIN tbl_tutors AS tt ON s.tutor_id =tt.tutor_id WHERE subject_name LIKE '%$search%'";
}else {
$sqlloadsubject = "SELECT * FROM tbl_subjects as s LEFT JOIN tbl_tutors AS tt ON s.tutor_id =tt.tutor_id WHERE subject_name LIKE '%$search%' AND s.subject_rating >= '$subrating' ORDER BY s.subject_rating DESC";
}
$result = $conn->query($sqlloadsubject);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadsubject = $sqlloadsubject . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadsubject);
if ($result->num_rows >= 0) {
    //do something
    $subjects["subjects"] = array();
    while ($row = $result->fetch_assoc()) {
        $sblist = array();
        $sblist['id'] = $row['subject_id'];
        $sblist['name'] = $row['subject_name'];
        $sblist['description'] = $row['subject_description'];
        $sblist['price'] = $row['subject_price'];
        $sblist['tutorid'] = $row['tutor_id'];
        $sblist['sessions'] = $row['subject_sessions'];
        $sblist['rating'] = $row['subject_rating'];
        $sblist['tutorname'] = $row['tutor_name'];
        array_push($subjects["subjects"],$sblist);
    }
    $response = array('status' => 'success', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page", 'data' => $subjects);
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