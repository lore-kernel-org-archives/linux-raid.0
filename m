From: Zhong Lidong <lidong.zhong@suse.com>
Subject: Re: [PATCH] Monitor: improve check_one_sharer() for checking
 duplicated process
Date: Mon, 13 Apr 2020 09:47:57 +0800
Message-ID: <f62b9338-10d4-c9d5-3d8f-a0ac432b11e2@suse.com>
References: <20200410162446.6292-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200410162446.6292-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, jes@trained-monkey.org, linux-raid@vger.kernel.org
Cc: Shinkichi Yamazaki <shinkichi.yamazaki@suse.com>
List-Id: linux-raid.ids

On 4/11/20 12:24 AM, Coly Li wrote:
> When running mdadm monitor with scan mode, only one autorebuild process
> is allowed. check_one_sharer() checks duplicated process by following
> steps,
> 1) Read autorebuild.pid file,
>    - if file does not exist, no duplicated process, go to 3).
>    - if file exists, continue to next step.
> 2) Read pid number from autorebuild.pid file, then check procfs pid
>    directory /proc/<PID>,
>    - if the directory does not exist, no duplicated process, go to 3)
>    - if the directory exists, print error message for duplicated process
>      and exit this mdadm.
> 3) Write current pid into autorebuild.pid file, continue to monitor in
>    scan mode.
> 
> The problem for the above step 2) is, if after system reboots and
> another different process happens to have exact same pid number which
> autorebuild.pid file records, check_one_sharer() will treat it as a
> duplicated mdadm process and returns error with message "Only one
> autorebuild process allowed in scan mode, aborting".
> 
> This patch tries to fix the above same-pid-but-different-process issue
> by one more step to check the process command name,
> 1) Read autorebuild.pid file
>    - if file does not exist, no duplicated process, go to 4).
>    - if file exists, continue to next step.
> 2) Read pid number from autorebuild.pid file, then check procfs file
>    comm with the specific pid directory /proc/<PID>/comm
>    - if the file does not exit, it means the directory /proc/<PID> does
>      not exist, go to 4)
>    - if the file exits, continue next step
> 3) Read process command name from /proc/<PIC>/comm, compare the command
>    name with "mdadm" process name,
>    - if not equal, no duplicated process, goto 4)
>    - if strings are equal, print error message for duplicated process
>      and exit this mdadm.
> 4) Write current pid into autorebuild.pid file, continue to monitor in
>    scan mode.
> 
> Now check_one_sharer() returns error for duplicated process only when
> the recorded pid from autorebuild.pid exists, and the process has exact
> same command name as "mdadm".
> 

Consider another corner case: what if the recorded pid from
autorebuild.pid is actually used by other mdadm command, such as "mdadm
--wait"? It shouldn't report error now.

Thanks,
Lidong

> Reported-by: Shinkichi Yamazaki <shinkichi.yamazaki@suse.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  Monitor.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index b527165..2d6b3b9 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -301,26 +301,34 @@ static int make_daemon(char *pidfile)
>  
>  static int check_one_sharer(int scan)
>  {
> -	int pid, rv;
> +	int pid;
> +	FILE *comm_fp;
>  	FILE *fp;
> -	char dir[20];
> +	char comm_path[100];
>  	char path[100];
> -	struct stat buf;
> +	char comm[20];
> +
>  	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
>  	fp = fopen(path, "r");
>  	if (fp) {
>  		if (fscanf(fp, "%d", &pid) != 1)
>  			pid = -1;
> -		sprintf(dir, "/proc/%d", pid);
> -		rv = stat(dir, &buf);
> -		if (rv != -1) {
> -			if (scan) {
> -				pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
> -				fclose(fp);
> -				return 1;
> -			} else {
> -				pr_err("Warning: One autorebuild process already running.\n");
> +		snprintf(comm_path, sizeof(comm_path),
> +			 "/proc/%d/comm", pid);
> +		comm_fp = fopen(comm_path, "r");
> +		if (comm_fp) {
> +			if (fscanf(comm_fp, "%s", comm) &&
> +			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
> +				if (scan) {
> +					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
> +					fclose(comm_fp);
> +					fclose(fp);
> +					return 1;
> +				} else {
> +					pr_err("Warning: One autorebuild process already running.\n");
> +				}
>  			}
> +			fclose(comm_fp);
>  		}
>  		fclose(fp);
>  	}
> 
