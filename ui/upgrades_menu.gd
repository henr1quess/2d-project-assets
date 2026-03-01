extends Control


func _ready() -> void:
	_update_ui()


func _update_ui() -> void:
	# Moedas
	%CoinsLabel.text = "Moedas: " + str(GameState.coins)

	# Dano
	if GameState.upgrade_damage_level >= GameState.MAX_UPGRADE_LEVEL:
		%DamageLabel.text = "Dano: Nível " + str(GameState.upgrade_damage_level) + " (MAX)"
		%DamageButton.text = "MAX"
		%DamageButton.disabled = true
	else:
		%DamageLabel.text = "Dano: Nível " + str(GameState.upgrade_damage_level)
		%DamageButton.text = "Comprar (" + str(GameState.get_damage_cost()) + " moedas)"
		%DamageButton.disabled = not GameState.can_buy_damage()

	# Vida
	if GameState.upgrade_health_level >= GameState.MAX_UPGRADE_LEVEL:
		%HealthLabel.text = "Vida: Nível " + str(GameState.upgrade_health_level) + " (MAX)"
		%HealthButton.text = "MAX"
		%HealthButton.disabled = true
	else:
		%HealthLabel.text = "Vida: Nível " + str(GameState.upgrade_health_level)
		%HealthButton.text = "Comprar (" + str(GameState.get_health_cost()) + " moedas)"
		%HealthButton.disabled = not GameState.can_buy_health()

	# Revive
	if GameState.revive_owned:
		%ReviveLabel.text = "Revive: COMPRADO"
		%ReviveButton.text = "Já possui"
		%ReviveButton.disabled = true
	else:
		%ReviveLabel.text = "Revive: Não possui"
		%ReviveButton.text = "Comprar (" + str(GameState.get_revive_cost()) + " moedas)"
		%ReviveButton.disabled = not GameState.can_buy_revive()


func _on_damage_button_pressed() -> void:
	GameState.buy_damage()
	_update_ui()


func _on_health_button_pressed() -> void:
	GameState.buy_health()
	_update_ui()


func _on_revive_button_pressed() -> void:
	GameState.buy_revive()
	_update_ui()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menu.tscn")
