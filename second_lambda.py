import os

ENV = os.environ.get('environment')


def lambda_handler(event, context):
    print('------------------------------------------------')
    print(event)
    file_value = event.get('first_value')
    second_value = event.get('second_value')
    print(f"{file_value}....{second_value}")
    return f"{file_value}....{second_value}"
