sinfo -o "%P %D %t %G"
ls
pwd
sinfo -o "%P %D %t %G" > asd.txt
vim asd.txt
exit
cd /scratch/js10454
mkdir -p /scratch/js10454/pytorych_examples/pytorch_single_gpu[D
cd pytorych_examples/pytorch_single_gpu\[D/
cd ..
ls
mv pytorch_single_gpu\[D/ pytorch_single_gpu
cd pytorch_single_gpu/
cd
pwd
vim .bashrc
echo $TERM
infocmp "$TERM"
nvim
vim .bashrc
cd -
exit
EXIT
exit
cd /scratch/js10454
ls
cd pytorych_examples/
ls
cd pytorch_single_gpu/
ls /share/apps/overlay-fs-ext3
cd ..
cp -rp /share/apps/overlay-fs-ext3/overlay-15GB-500K.ext3.gz .
gunzip overlay-15GB-500K.ext3.gz
gunzip overlay-15GB-500K.ext3.gz 
singularity exec --fakeroot --overlay overlay-15GB-500K.ext3:rw /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif /bin/bash
srun --pty -c 2 --mem=5GB /bin/bash
srun --pty -c 2 --mem=5GB /bin/bash --account=js10454
sacctmgr show assoc user=js10454 format=account,user,partition
srun --cpus-per-task=2 --mem=10GB --time=04:00:00 --pty /bin/bash
exit
srun --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash
srun --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash --account torch_pr_1008_general 
srun --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash --account=torch_pr_1008_general 
exit
ls
vim asd.txt 
exit
wget --no-check-certificate https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p /ext3/miniforge3
vim /ext3/env.sh
source /etc3/env.sh
touch /ext3/env.sh
vim /etx3/env.sh
vim /ext3/env.sh
source /ext3/env.sh
conda config --remove channels defaults
conda update -n base conda -y
conda clean --all --yes
exit
cd /scratch/js10454/pytorych_examples/pytorch_single_gpu/
ls
cp -rp /share/apps/overlay-fs-ext3/overlay-15GB-500K.ext3.gz .
gunzip overlay-15GB-500K.ext3.gz
singularity exec --fakeroot --overlay overlay-15GB-500K.ext3:rw /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif /bin/bash
exit
srun --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash --account=torch_pr_1008_general --comment="preemption=yes;preemption_partitions_only=yes;requeue=true"
my_slurm_accounts
srun --account=torch_pr_1008_general --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash --comment="preemption=yes;preemption_partitions_only=yes;requeue=true"
srun --account=torch_pr_1008_general --cpus-per-task=2 --mem=1GB --time=00:01:00 --pty /bin/bash
clear
ls
vim .bashrc
source .bashrc
srun --pty -c 2 --mem=5GB /bin/bash
exit
source /ext3/env.sh
pip install line_profiler
exit
ls
singularity exec 	            --overlay /scratch/js10454/pytorch-example/pytorch_single_gpu/overlay-15GB-500K.ext3:rw 	            /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif 	            /bin/bash
pwd
ls
singularity exec 	            --overlay /scratch/js10454/pytorch_examples/pytorch_single_gpu/overlay-15GB-500K.ext3:rw 	            /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif 	            /bin/bash
singularity exec 	            --overlay /scratch/js10454/pytorych_examples/pytorch_single_gpu/overlay-15GB-500K.ext3:rw 	            /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif 	            /bin/bash
singularity exec --fakeroot 	            --overlay /scratch/js10454/pytorych_examples/pytorch_single_gpu/overlay-15GB-500K.ext3:rw 	            /share/apps/images/cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif 	            /bin/bash 
exit
source /ext3/env.sh
pip install torchvision
exit
source /ext3/env.sh
pip install torch
pip install socket 
exit
cd /scratch/js10454/pytorych_examples/pytorch_single_gpu/
ls
srun --pty -c 2 --mem=5GB /bin/bash
ls
vim download_data.py
 srun --pty -c 2 --mem=5GB /bin/bash
ls
vim multi_gpu.slurm 
sacct -j 10144783 --format=JobID,JobName,State,ExitCode,Elapsed,Timelimit,NodeList,ReqTRES,AllocTRES
sacct -j 10144783 --format=JobID%-20,JobName%-12,Partition%-15,State%-12,ExitCode,Elapsed,Timelimit,NNodes,NTasks,ReqTRES%80,AllocTRES%80,NodeList%40
clear
sacct -j 10144783 --format=JobID%-20,JobName%-12,Partition%-15,State%-12,ExitCode,Elapsed,Timelimit,NNodes,NTasks,ReqTRES%80,AllocTRES%80,NodeList%40
scontrol show job 10144783
sqq
sqqs
sqq
ls
source .bashrc
sqq
sqqs
ls
cd 
source .bashrc
sqq
sacct -j 10145097 --format=JobID%-20,JobName%-12,Partition%-15,State%-12,Elapsed,Timelimit,NNodes,NTasks,ReqTRES%80,AllocTRES%80,NodeList%40
squeue -A torch_pr_1008_general
squeue -p l40s_publ
scontrol show job 10145097 | grep -E "Partition|Reason|QOS|Account|TRES|NumNodes|NumCPUs|NodeList|Submit|Eligible"
sacctmgr show assoc user=js10454 account=torch_pr_1008_general format=User,Account,Partition,QOS,DefaultQOS,GrpTRES,MaxTRES,MaxJobs,MaxSubmitJobs,GrpJobs,GrpSubmitJobs
sacctmgr -n -P show qos gpu48 format=Name,Priority,MaxWall,MaxTRES,MaxTRESPU,GrpTRES,GrpTRESMins,MaxJobsPU,MaxSubmitJobsPU,MaxJobs,MaxSubmitJobs,Preempt,PreemptMode
sacctmgr -n -P show qos format=Name,Priority,MaxWall,MaxTRES,MaxTRESPU,GrpTRES,MaxJobsPU,MaxSubmitJobsPU
scancel 10145097
sqq
clear
ls
sqq
ls
cd /scratch/js10454/pytorych_examples/pytorch_single_gpu/
ls
vim multi_gpu.slurm 
tmux
exit
ls
tmux ls
cd /scratch/js10454
ls
df -H
df -h .
cd
vim .bashrc
nvim .bashrc
srun --pty -c 2 --mem=5GB /bin/bash
srun --pty -c 2 --mem=5GB /bin/bash
sqq
ls
vim slurm-10154543.out 
sacct -u js10454 --starttime today   --format=JobID%-18,JobName%-15,Partition%-18,State%-12,Submit,Start,End,Elapsed,Timelimit,NNodes,NTasks,ReqTRES%60
Then for the specific job:
vim slurm-10154543.out 
sacct -j 10154543   --format=JobID%-20,JobName%-15,State%-12,Submit,Eligible,Start,End,Elapsed,Timelimit,NNodes,NTasks,ReqTRES%80,AllocTRES%80
mkdir logs
clear
ls
rm nvim-linux-x86_64.tar.gz 
vim multi_gpu.slurm 
sinfo -o "%P %G %D %t %N" | grep -Ei "a100|h100|h200"
vim probe_job.slurm
mkdir -p logs probe_results
vim submit_gpu_probs.sh
chmod +x submit_gpu_probs.sh 
vim submit_gpu_probs.sh
chmod +x submit_gpu_probes.sh
ls
chmod +x submit_gpu_probs.sh
mv submit_gpu_probs.sh submit_gpu_probes.sh
./submit_gpu_probes.sh
sqq
ls
vim submit_gpu_probes.sh 
bash -n submit_gpu_probes.sh
grep -n "submit_probe\|gpu_type\|gpus" submit_gpu_probes.sh
./submit_gpu_probes.sh
scontrol show partition a100 | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
clear
scontrol show partition a100 | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
scontrol show partition h100 | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
scontrol show partition h200 | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
scontrol show partition h200_public | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
scontrol show partition l40s_public | grep -E "PartitionName|AllowAccounts|AllowGroups|AllowQos|DenyAccounts|DenyQos|State|Nodes"
sbatch --partition=a100 --gres=gpu:a100:1 probe_job.slurm
sbatch --partition=h100 --gres=gpu:h100:1 probe_job.slurm
srun --pty -c 2 --mem=5GB /bin/bash
srun --pty -c 2  -t 0-10:00 --mem=5GB /bin/bash
