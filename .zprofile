export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/kishanarava/documents/coding/mongodb/bin
export PATH="$HOME/.fastlane/bin:$PATH"

# added by Anaconda3 5.2.0 installer
# export PATH="/Users/kishanarava/anaconda3/bin:$PATH"

# # setup colours
# LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:c$'
# export LS_COLORS

# PS1='\[\e[37;1m\]\u@\[\e[35m\]\W\[\e[0m\]$ '

#########################
# added to enable quick start of AWS instances and ssh
#########################

# start gpu
alias aws_start='aws ec2 start-instances --instance-ids i-0cf7a55fe8610db4d'
alias aws_stop='aws ec2 stop-instances --instance-ids i-0cf7a55fe8610db4d'
## below is not workign with zsh
#alias aws_getip='aws ec2 describe-instances --instance-ids i-0cf7a55fe8610db4d --query 'Reservations[*].Instances[*].PublicIpAddress' --output text'

# ssh into gpu with tunnelling port 8888 so can view jupyter notebook
# on local browser. Note run nohup jupyter notebook to run continuously
alias awsgpu='ssh -i /Users/kishanarava/.ssh/kish-macbook-aws.pem ubuntu@34.211.33.238 -L8888:localhost:8888'

# use awsgputerminal if I don't want to tunnel the port for jupyter notebook
alias awsgputerminal='ssh -i /Users/kishanarava/.ssh/kish-macbook-aws.pem ubuntu@34.211.33.238'

# ssh into Counta instances
alias counta_aws_old='ssh -i ~/.ssh/kish-macbook-pro-AWS-guidant-c5-large.pem ec2-user@52.15.140.192'
alias counta_aws_new='ssh -i ~/.ssh/kish-macbook-pro-AWS-guidant-c5-large.pem ubuntu@18.216.226.75'
alias counta_aws_gpu='ssh -i ~/.ssh/AustraliaGPUCounta.pem ubuntu@3.105.202.152'
alias counta_aws_gpu_start='aws configure set default.region ap-southeast-2; aws ec2 start-instances --instance-ids i-08180168e0c318733; aws configure set default.region us-east-2'
alias counta_aws_gpu_stop='aws configure set default.region ap-southeast-2; aws ec2 stop-instances --instance-ids i-08180168e0c318733; aws configure set default.region us-east-2'

# check counter production users
alias counta_prod_no_users='aws cognito-idp list-users --user-pool-id us-east-2_6xkvP1y2w --attributes-to-get given_name --filter "cognito:user_status = \"CONFIRMED\"" | grep given_name | wc'
alias counta_prod_usernames='aws cognito-idp list-users --user-pool-id us-east-2_6xkvP1y2w --attributes-to-get given_name | grep given_name'

# alias into atyx digital ocean droplet
alias atyxdroplet='ssh root@209.97.162.196'
alias atyxdroplet-new='ssh root@178.128.51.138'
alias kishdroplet='ssh root@kish.ai'
alias kishdroplet-old='ssh root@139.59.228.125'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


. /Users/kishanarava/anaconda3/etc/profile.d/conda.sh
. /Users/kishanarava/anaconda3/etc/profile.d/conda.sh
. /Users/kishanarava/anaconda3/etc/profile.d/conda.sh
. /Users/kishanarava/anaconda3/etc/profile.d/conda.sh
conda activate


# aliases for easy access to common folders
alias wstafolder='cd "/Users/kishanarava/Library/Mobile Documents/com~apple~CloudDocs/Uni/COMP90042 - WSTA"'
alias counta_ios='cd "/Users/kishanarava/code/guidant/counta/guidant-ios-application/"'
alias counta-backend-folder='cd "/Users/kishanarava/code/guidant/counta/counta_backend/"'

# alias to ssh in wstaproject aws instance
alias wsta_instance='ssh -i ~/.ssh/kish_aws_wsta_project_instance1.1.pem ubuntu@3.105.99.226'

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

## open email inboxes
alias personalEmail='open -a safari "https://mail.google.com/mail/u/?authuser=kishan.arava@gmail.com"'
alias personalEmailNew='open -a safari "https://mail.google.com/mail/u/0/#search/newer_than%3A1h"'
alias atyEmail='open -a safari "https://mail.google.com/mail/u/?authuser=kishan.arava@atyadvisory.com.au"'
alias composeEmail='open -a safari "https://mail.google.com/mail/u/kishan.arava@gmail.com/#inbox?compose=new"'

##############################
## More productive aliases
##############################
alias django-runserver="python manage.py runserver"
handson-ml() {
    cd ~/code/myGitHub/handson-ml2
    conda activate tf2
    jupyter notebook > jupyter_log.txt 2>&1 &
}

##############################
## Custom GIT aliases
##############################
alias gl1='git log --oneline'

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

alias daily-affirmation="jrnl daily_affirmations < /Users/kishanarava/Library/Mobile\ Documents/com~apple~CloudDocs/jrnl/templates/daily_affirmations.txt; jrnl daily_affirmations -1 --edit"
alias daily-affirmation-review="jrnl daily_affirmations -1 --edit"
alias timesheet="jrnl timesheet < /Users/kishanarava/Library/Mobile\ Documents/com~apple~CloudDocs/jrnl/templates/timesheet.txt; jrnl timesheet -1 --edit"
alias timesheet-edit="jrnl timesheet -1 --edit"
alias thought-diary="jrnl thought_diary < /Users/kishanarava/Library/Mobile\ Documents/com~apple~CloudDocs/jrnl/templates/thought_diary.txt; jrnl thought_diary -1 --edit"
alias gym-sessions="jrnl @gym @shoulders @legs @chest @back @strength_class @full_body"

# Updates to allowe updating of fastlane
export GEM_HOME=~/.gems
export PATH=$PATH:~/.gems/bin
