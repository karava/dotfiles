export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/kishanarava/documents/coding/mongodb/bin
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH=$PATH:~/.local/bin

# added by Anaconda3 5.2.0 installer
# export PATH="/Users/kishanarava/anaconda3/bin:$PATH"

# # setup colours
# LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:c$'
# export LS_COLORS

# PS1='\[\e[37;1m\]\u@\[\e[35m\]\W\[\e[0m\]$ '

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [[ "$(hostname)" == "MacBook-Pro-156" ]]; then
    . /Users/kishanarava/anaconda3/etc/profile.d/conda.sh
    conda activate
fi

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

##############################
## More productive aliases
##############################
alias django-runserver="python manage.py runserver"
handson-ml() {
    cd ~/code/myGitHub/handson-ml2
    conda activate tf2
    jupyter notebook > jupyter_log.txt 2>&1 &
}

############################
## Extending jrnl functionality
############################
function log_question()
{
	echo $1
	read
	jrnl today: ${1}. $REPLY
}

function jrnl_questions() {
	log_question 'What did I achieve today?'
	log_question 'What did I make progress with?'
}

# Updates to allow updating of fastlane
export GEM_HOME=~/.gems
export PATH=$PATH:~/.gems/bin

# Test if ~/.aliases exists and source it
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Environment setup
if [ -f ~/.env ]; then
    source ~/.env
fi

# enable fasd
[ -f ~/bin/fasd ] && eval "$(fasd --init auto)"

# On linux fzf auto adds this line
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Initialise fasd, this creates the handy aliases for z and fasd_cd
eval "$(fasd --init auto)"