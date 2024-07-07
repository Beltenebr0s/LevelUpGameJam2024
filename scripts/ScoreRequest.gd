extends Node

signal received_scores(scores)
signal ranking_error

func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)

func _on_request_completed(result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if result != HTTPRequest.RESULT_SUCCESS:
		ranking_error.emit()
	else: 
		if json != null:
			received_scores.emit(json)
		else:
			ranking_error.emit()

func save_score_on_server(puntos : int):
	return $HTTPRequest.request("https://53ac69f5-73d7-4508-bbed-b3477fd114a2-00-12nlkqiwb5cah.riker.replit.dev/save_score?puntos="+str(puntos))
