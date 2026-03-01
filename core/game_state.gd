extends Node

# ── Dados persistentes ──
var coins: int = 0
var upgrade_damage_level: int = 0
var upgrade_health_level: int = 0
var revive_owned: bool = false

# ── Constantes de upgrade ──
const MAX_UPGRADE_LEVEL: int = 10

const DAMAGE_BASE_COST: int = 20
const DAMAGE_COST_INCREMENT: int = 10
const DAMAGE_PER_LEVEL: int = 1

const HEALTH_BASE_COST: int = 30
const HEALTH_COST_INCREMENT: int = 15
const HEALTH_BONUS_PER_LEVEL: float = 0.1

const REVIVE_COST: int = 500

# ── Caminho do save ──
const SAVE_PATH: String = "user://save_data.tres"


func _ready() -> void:
	load_game()


# ── Custos ──

func get_damage_cost() -> int:
	return DAMAGE_BASE_COST + DAMAGE_COST_INCREMENT * upgrade_damage_level


func get_health_cost() -> int:
	return HEALTH_BASE_COST + HEALTH_COST_INCREMENT * upgrade_health_level


func get_revive_cost() -> int:
	return REVIVE_COST


# ── Verificação de compra ──

func can_buy_damage() -> bool:
	return upgrade_damage_level < MAX_UPGRADE_LEVEL and coins >= get_damage_cost()


func can_buy_health() -> bool:
	return upgrade_health_level < MAX_UPGRADE_LEVEL and coins >= get_health_cost()


func can_buy_revive() -> bool:
	return not revive_owned and coins >= get_revive_cost()


# ── Compra ──

func buy_damage() -> bool:
	if not can_buy_damage():
		return false
	coins -= get_damage_cost()
	upgrade_damage_level += 1
	save_game()
	return true


func buy_health() -> bool:
	if not can_buy_health():
		return false
	coins -= get_health_cost()
	upgrade_health_level += 1
	save_game()
	return true


func buy_revive() -> bool:
	if not can_buy_revive():
		return false
	coins -= get_revive_cost()
	revive_owned = true
	save_game()
	return true


# ── Cálculos de gameplay ──

func get_bonus_damage() -> int:
	return DAMAGE_PER_LEVEL * upgrade_damage_level


func get_max_health(base_health: float) -> float:
	return base_health * (1.0 + HEALTH_BONUS_PER_LEVEL * upgrade_health_level)


# ── Save / Load ──

func save_game() -> void:
	var data := SaveData.new()
	data.coins = coins
	data.upgrade_damage_level = upgrade_damage_level
	data.upgrade_health_level = upgrade_health_level
	data.revive_owned = revive_owned
	ResourceSaver.save(data, SAVE_PATH)


func load_game() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		return
	var data: SaveData = ResourceLoader.load(SAVE_PATH)
	if not data:
		return
	coins = data.coins
	upgrade_damage_level = data.upgrade_damage_level
	upgrade_health_level = data.upgrade_health_level
	revive_owned = data.revive_owned


# ── Adicionar moedas ──

func add_coins(amount: int) -> void:
	coins += amount
	save_game()
