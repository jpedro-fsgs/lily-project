extends Node

const DATA = [
  { "name": "Guerreiro Novato", "type": "creature", "attack": 2, "defense": 3, "cost": 1, "effect": "Nenhum" },
  { "name": "Arqueiro Ágil", "type": "creature", "attack": 3, "defense": 2, "cost": 2, "effect": "Ataque à distância" },
  { "name": "Mago Aprendiz", "type": "creature", "attack": 1, "defense": 4, "cost": 2, "effect": "Ganha +1 de ataque ao lançar um feitiço" },
  { "name": "Dragão Ancião", "type": "creature", "attack": 7, "defense": 7, "cost": 6, "effect": "Voar" },
  { "name": "Goblin Travesso", "type": "creature", "attack": 2, "defense": 1, "cost": 1, "effect": "Ao entrar em jogo, causa 1 de dano ao oponente" },

  { "name": "Feitiço de Fogo", "type": "spell", "damage": 3, "cost": 2, "effect": "Causa 3 de dano ao inimigo" },
  { "name": "Cura Divina", "type": "spell", "heal": 4, "cost": 2, "effect": "Cura 4 pontos de vida de um aliado" },
  { "name": "Raio Concentrado", "type": "spell", "damage": 5, "cost": 4, "effect": "Causa 5 de dano a uma única criatura" },
  { "name": "Explosão Arcana", "type": "spell", "damage": 2, "cost": 3, "effect": "Causa 2 de dano a todas as criaturas inimigas" },
  { "name": "Invocação Sombria", "type": "spell", "cost": 5, "effect": "Cria uma criatura 4/4 Demônio no campo" },

  { "name": "Torre de Defesa", "type": "structure", "defense": 6, "cost": 3, "effect": "Impede ataque direto ao jogador enquanto estiver ativa" },
  { "name": "Obelisco Arcano", "type": "structure", "defense": 4, "cost": 2, "effect": "Gera 1 de mana extra por turno" },
  { "name": "Altar do Sacrifício", "type": "structure", "defense": 3, "cost": 4, "effect": "Pode ser destruído para ganhar +3 mana" },
  { "name": "Fonte da Vida", "type": "structure", "defense": 5, "cost": 3, "effect": "Cura 2 pontos de vida por turno" },
  { "name": "Muralha de Pedra", "type": "structure", "defense": 8, "cost": 4, "effect": "Não pode atacar, apenas defender" },

  { "name": "Assassino Sombrio", "type": "creature", "attack": 4, "defense": 2, "cost": 3, "effect": "Destrói uma criatura ao atacar" },
  { "name": "Elemental da Água", "type": "creature", "attack": 3, "defense": 4, "cost": 3, "effect": "Reduz dano recebido em 1" },
  { "name": "Paladino Sagrado", "type": "creature", "attack": 3, "defense": 5, "cost": 4, "effect": "Cura 2 pontos de vida ao atacar" },
  { "name": "Fênix Imortal", "type": "creature", "attack": 5, "defense": 4, "cost": 5, "effect": "Renasce com 2 de vida ao morrer" },
  { "name": "Orc Selvagem", "type": "creature", "attack": 6, "defense": 3, "cost": 4, "effect": "Ganha +1 ataque ao atacar" }
]

#func _ready() -> void:
	#var file = FileAccess.open("res://data/cards_database.json", FileAccess.READ)
	#var content = file.get_as_text()
	#cards = JSON.parse_string(content)
	
func get_cards():
	return DATA.duplicate()
