extends Node2D 

@onready var cinematic2: Cinematic = $Cinematic2
# Exportamos una variable para que puedas elegir el siguiente nivel desde el Inspector
@export_file("*.tscn") var siguiente_escena: String

func finalNivel1() -> void:
	# Reiniciamos el seguro global para que nos deje mostrar otro diálogo
	GameState.intro_dialogue_shown = false
	
	# Ahora sí, arrancamos la cinemática
	cinematic2.start()
	# ya mostramos el dialogo ahora nos vamos a la otra escena
	# Magia de Godot 4: Esperamos pacientemente a que la cinemática termine
	await cinematic2.cinematic_finished
	
	# Ya mostramos el diálogo, ahora nos vamos a la otra escena
	if siguiente_escena != "":
		SceneSwitcher.change_to_file_with_transition(
			siguiente_escena, ^"", Transition.Effect.FADE, Transition.Effect.FADE
		)
