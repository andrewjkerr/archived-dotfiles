# Launch tmux session if exists; launch tmux if not :)
(tmux ls | grep -vq attached && tmux at) || tmux
