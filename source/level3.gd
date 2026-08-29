extends "res://source/main.gd"

const Employee = preload("res://source/employee.gd")

func _ready():
    unlocked_rules = ["ComputerWork", "BlueScience", "BlueInsert", "RedInsert", "DamagedShred", "NoCoffee"]
    unlocked_abilities = ["RechargeBatteries"]
    super()

    # ensure we have at least one blueshirt
    var blueshirt_exists = false
    for employee in find_children("Employee?"):
        if employee.uniform == Employee.Uniform.Science:
            blueshirt_exists = true
            break
    if not blueshirt_exists:
        find_children("Employee*")[0].set_uniform(Employee.Uniform.Science)
    
func get_task(employee):
    var out = super(employee)
    if out is Task.ComputerWork:
        out.monitor_node.in_use = false
        if randi() % 10 == 0 and not employee.previous_task is Task.DrinkCoffee:
            return Task.DrinkCoffee.new(self, employee)
        if randi() % 2 == 0 and not employee.previous_task is Task.BlueChip:
            return Task.BlueChip.new(self, employee)
        else:
            return Task.RedChip.new(self, employee)
    return out
    
