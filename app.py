import platform
from datetime import datetime

print("=" * 40)
print("🚀 GitHub Actions Demo")
print("=" * 40)

print(f"Current Date & Time : {datetime.now()}")
print(f"Operating System    : {platform.system()}")
print(f"OS Version          : {platform.release()}")
print(f"Python Version      : {platform.python_version()}")

print("\nPipeline executed successfully!")

# Write the output to a file
with open("output.txt", "w") as file:
    file.write("GitHub Actions executed successfully!\n")
    file.write(f"Execution Time: {datetime.now()}\n")

print("\nOutput file 'output.txt' created successfully.")