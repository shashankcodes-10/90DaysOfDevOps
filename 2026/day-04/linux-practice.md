I ran:

ps aux

Observation:
I could see around 180 running processes.

--------------------------------

systemctl status ssh

Observation:
SSH service was active.

--------------------------------

journalctl -u ssh

Observation:
The service started successfully.

--------------------------------

Mini Troubleshooting

Goal:
Verify SSH service health.

Steps:
1. Checked process.
2. Checked service status.
3. Checked logs.

Result:
Everything was running normally.
