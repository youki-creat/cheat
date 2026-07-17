extends CharacterBody2D

var input_vector = Vector2.ZERO
var last_input_vector = Vector2.ZERO
#onready会在长街准备就绪后开始访问animationtree 下面是ctrl拖动animationtree自动生成的
@onready var animation_tree: AnimationTree = $AnimationTree
#在这里访问动画树状态机中的palyback属性
@onready var playback =animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback

var SPEED = 120.0
var rollspeed = 150.0
#是关于物理方面的内置函数
#delta 帧数
func _physics_process(delta: float) -> void:
	#我声明了一个变量方便查看状态器回的状态值，方便解决移动击不同状态的问题
	var state = playback.get_current_node()
	if state == "movemachine":
		move_state(delta)
	elif state == "attackstate":
		pass
	elif state == "rollstate":
		roll_state(delta)
		
		
		
		
		
#创建的一个放置移动状态的函数
func move_state(delat:float)-> void:
	##声明input_vector,使用get_vector()获取上下左右的输入不过默认值为1，速度很慢
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	

		#在获取玩家的移动提供方向的速度不为零的时候
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector
			#添加这一步的原因是因为godot中y轴与实际为相反，因此需要读取反方向的y
		var direction_vector = Vector2(input_vector.x,-input_vector.y)
		update_blend_positions(direction_vector)
		##检测按下攻击见，将状态器的属性转换到攻击
	if Input.is_action_just_pressed("attack"):
		playback.travel("attackstate")
	if Input.is_action_just_pressed("roll"):
		playback.travel("rollstate")	
	##用定义后的速度和获取的值相乘定义velocity控制移动的速率和方向
	velocity = input_vector * SPEED
	#表示角色在当前速度遇到障碍物并不会直接停下或者传过去，而是按照物理逻辑进行滑行
	move_and_slide()
#创建的一个放置滚状态的函数
func roll_state(delat:float)-> void:
	velocity = last_input_vector * rollspeed
	move_and_slide()	
#创建的一个函数专门放置在animationtree中置的动作的函数	
func update_blend_positions(direction_vector:Vector2):
		animation_tree.set("parameters/StateMachine/movemachine/runstate/blend_position",direction_vector)
		animation_tree.set("parameters/StateMachine/movemachine/standstate/blend_position",direction_vector)
		animation_tree.set("parameters/StateMachine/attackstate/blend_position",direction_vector)
		animation_tree.set("parameters/StateMachine/rollstate/blend_position",direction_vector)

		
		
		
