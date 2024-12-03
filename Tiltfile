# Watch for changes in source files
watch_file('src')

# Function to create a resource for each day
def create_day_resource(day):
    local_resource(
        'day-' + str(day),
        cmd='just run ' + str(day),
        deps=['src/day_' + str(day) + '/main.zig'],
        auto_init=False
    )

# Create resources for existing day folders
# for day in range(1, 2):
#     create_day_resource(day)

# # Add a resource for running all tests
# local_resource(
#     'test-all',
#     cmd='just test-all',
#     deps=['src'],
#     auto_init=False
# )
#
# # Add a resource for formatting
# local_resource(
#     'fmt',
#     cmd='just fmt',
#     deps=['src'],
#     auto_init=False
# )

create_day_resource(1)
