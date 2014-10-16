

import UIKit


//this is global
var taskMgr:TaskManager = TaskManager()

struct task {
    var name = "un-named"
    var desc = "un-description"
}

class TaskManager: NSObject {
    var tasks = [task]()

    func addTask(name:String, desc:String)  {
        tasks.append(task(name: name, desc: desc))
    }
    
}






