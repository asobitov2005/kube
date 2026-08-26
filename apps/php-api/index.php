<?php
header('Content-Type: application/json');
$status = $_SERVER['REQUEST_URI'] === '/readyz' ? 'ready' : 'ok';
echo json_encode([
    'message' => 'PHP servisidan salom!',
    'service' => 'php-api',
    'pod' => gethostname(),
    'status' => $status
]);
