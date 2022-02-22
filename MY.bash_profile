# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

alias Scratch='cd /exports/eddie/scratch/zwu33'
alias work="cd /exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu"
alias Stage="cd /exports/cmvm/datastore/eb/groups/Simone_Meddle_Group/Zhou_LALO"
alias Install="cd /exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install"
alias Lalo="cd /exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/RNA_LALO/mhindle"
alias quast='/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/quast-5.0.2/quast.py'
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/RepeatMasker"
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/RepeatModuler/RepeatModeler-2.0.3/"
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/gffread"
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/sickle-1.33/"
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/MUMmer3.23/"
export PATH=$PATH:$HOME/edirect
