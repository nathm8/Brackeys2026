extends "res://source/main.gd"

const Employee = preload("res://source/employee.gd")

func _ready():
    unlocked_rules = ["ComputerWork", "BlueScience", "BlueInsert", "RedInsert", "DamagedShred", "NoCoffee"]
    unlocked_abilities = ["RechargeBatteries"]
    total_incorrect_task_number = 10
    total_correct_task_number = 15
    super()

    # ensure we have at least one blueshirt
    var blueshirt_exists = false
    for employee in find_children("Employee*"):
        if employee.uniform == Employee.Uniform.Science:
            blueshirt_exists = true
            break
    if not blueshirt_exists:
        find_children("Employee*")[0].set_uniform(Employee.Uniform.Science)
    
func get_task(employee):
    if to_do.size() == 0:
        if randi() % 3 == 0:
            return Task.BlueScience.new(self, employee)
        # if randi() % 3 == 0:
        #     return Task.DrinkCoffee.new(self, employee)
    return super(employee)
    