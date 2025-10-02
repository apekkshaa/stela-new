class User:
    def __init__(self, username, email):
        self.username = username
        self.email = email

    def get_dashboard(self):
        raise NotImplementedError("Override this in child class")


class Student(User):
    def get_dashboard(self):
        return {
            "role": "Student",
            "features": ["View Tutorials", "Attempt Assessments", "Track Progress"]
        }


class Faculty(User):
    def get_dashboard(self):
        return {
            "role": "Faculty",
            "features": ["Upload Content", "Generate Reports", "View Student Submissions"]
        }


class Admin(User):
    def get_dashboard(self):
        return {
            "role": "Admin",
            "features": ["Manage Users", "Edit Content", "Analyze Usage Stats"]
        }
