extends Control

@onready var ip_label: Label = get_node("VBoxContainer/local_ip_label")
@onready var ip_edit: TextEdit = get_node("VBoxContainer/TextEdit")
@onready var status_label: Label = get_node("VBoxContainer/connect_status_label")
# Called when the node enters the scene tree for the first time.
func _ready():
	ip_label.text = get_host_ip_adress()
	
	multiplayer.connect("connected_to_server", _on_connected)
	multiplayer.connect("connection_failed", _on_failed_connection)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_host_ip_adress():
	var ip_adress: String

	if OS.has_feature("windows"):
		#if OS.has_enviroment("COMPUTERNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("x11"):
		#if OS.has_enviroment("HOSTNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("OSX"):
		#if OS.has_enviroment("HOSTNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	else:
		ip_adress = "; ".join(IP.get_local_addresses())
	
	return ip_adress
	
func get_remote_ip_adress():
	return ip_edit.text
	
func _on_connected():
	status_label.text = "Successfully connected to host!"
	status_label.set("theme_override_colors/font_color",Color(0, 1, 0))

func _on_failed_connection():
	status_label.text = "Failed to connect to host!"
	status_label.set("theme_override_colors/font_color",Color(1, 0, 0))

func _on_hosting_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(get_host_ip_adress(), 7000)
	multiplayer.multiplayer_peer = peer

func _on_join_hosted_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(get_remote_ip_adress(), 7000)
	multiplayer.multiplayer_peer = peer
