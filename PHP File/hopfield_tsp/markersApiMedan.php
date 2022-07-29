<?php
$mysqli = new mysqli("localhost","root","","db_fat");
$limit;
if(isset($_GET['limit']))
{
     $limit = $_GET['limit'];
}else{
    $limit = "30";
}
// $result = $mysqli->query("SELECT odp_name,latitude,longitude FROM t_odp_compliance WHERE witel='medan'");
$stmt = $mysqli->prepare("SELECT * FROM `fat_data_tables` limit ?");
$stmt->bind_param("s",$limit);
$stmt->execute();
$result = $stmt->get_result();
// print_r($result->fetch_all(MYSQLI_ASSOC));
$collectData = $result->fetch_all(MYSQLI_ASSOC);
echo json_encode($collectData);
$stmt->close();
$mysqli->close();

?>