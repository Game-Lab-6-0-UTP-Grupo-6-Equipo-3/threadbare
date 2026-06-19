# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
extends Node2D

@export var lifes: int = 5:
	set(life):
		lifes = life
@export var nRayos: int = 10:
	set(rayo):
		nRayos = rayo

@onready var player: Player = $Underground/Player
@onready var lifesText: Label = $CanvasLayer/HBoxContainer/TextureRect/lifesText
@onready var tileFloor: TileMapLayer = $Tiles/floor
@onready var fillGameLocig: FillGameLogic = $FillGameLogic
@onready var playerAnimation: AnimationPlayer = $Underground/Player/PlayerHarm/GotHitAnimation
@export var squareHurt:PackedScene = preload("uid://cu7r1r0afhvgj")
@onready var timer: Timer = $Timer
@onready var cinematicFinal: Cinematic = $CinematicFinal
@onready var timerDanger:Timer = $TimerDanger
@onready var textDanger: Label = $TextDanger
@onready var enemy :ThrowingEnemy = $Underground/ThrowingEnemy
var finalBarrel: bool = false

func _ready() -> void:
	lifesText.text = "x" + str(lifes)
	
#Funcion que genera lasers aleatorios de acuerdo al tilemap puesto
func generateLaser() -> void:
	if finalBarrel == false:
		var rayo: Node = squareHurt.instantiate()
		var celdas: Array[Vector2i] = tileFloor.get_used_cells()
		var celda: Variant = celdas.pick_random()
		rayo.global_position = tileFloor.to_global(tileFloor.map_to_local(celda))
		add_child(rayo)
		rayo.daño.connect(logicLife)
	pass

func generateLasers(cantidad:int) -> void:
	for i in cantidad:
		generateLaser()

# Por cada escudo roto genera un aluvion de rayos
func moreLaser() -> void:
	CameraShake.shake()
	%soundWarning.play()
	textDanger.visible = true
	parpadear()
	timerDanger.start()
func parpadear() -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(textDanger, "modulate:a", 0.0, 0.5)
	tween.tween_property(textDanger, "modulate:a", 1.0, 0.5)

#Funcion de vidas simple TODO: Mejorar
func logicLife() -> void:
	lifes -=1
	playerAnimation.play(&"got_hit")
	CameraShake.shake()
	if lifes == 0:
		GameState.intro_dialogue_shown = false
		player.defeat()
	lifesText.text = "x" + str(lifes)

#Inicia secuancia al destruir todo los escudos
func final() -> void:
	finalBarrel = true
	timer.stop()
	GameState.intro_dialogue_shown = false
	cinematicFinal.start()
	
#Cinematica inicial room oscuro
func cinematic() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(%CanvasModulate, "color", Color("d3d3d3ff"), 2.5)


#Cada tanto seg genera un rayo
func _on_timer_timeout() -> void :
	if finalBarrel == false:
		generateLasers(nRayos)
	pass

#Genera 10 rayos mas por cada escudo roto
func _on_timer_danger_timeout() -> void:
	if finalBarrel == false:
		textDanger.visible = false
		generateLasers(100)
		nRayos +=10
		%soundWarning.stop()
	pass
	
