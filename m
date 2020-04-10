From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] Monitor: improve check_one_sharer() for checking duplicated process
Date: Fri, 10 Apr 2020 18:55:08 -0400
Message-ID: <24208.63820.173116.444680@quad.stoffel.home>
References: <20200410162446.6292-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200410162446.6292-1-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org, Shinkichi Yamazaki <shinkichi.yamazaki@suse.com>
List-Id: linux-raid.ids

>>>>> "Coly" == Coly Li <colyli@suse.de> writes:

Coly> When running mdadm monitor with scan mode, only one autorebuild process
Coly> is allowed. check_one_sharer() checks duplicated process by following
Coly> steps,
Coly> 1) Read autorebuild.pid file,
Coly>    - if file does not exist, no duplicated process, go to 3).
Coly>    - if file exists, continue to next step.
Coly> 2) Read pid number from autorebuild.pid file, then check procfs pid
Coly>    directory /proc/<PID>,
Coly>    - if the directory does not exist, no duplicated process, go to 3)
Coly>    - if the directory exists, print error message for duplicated process
Coly>      and exit this mdadm.
Coly> 3) Write current pid into autorebuild.pid file, continue to monitor in
Coly>    scan mode.

Shouldn't the pid file be in /var/run or something like that, which is
going to be wiped on reboot no matter what?  I'm not really against
the code, since it is good belt and suspenders programming, but it
just strikes me as a really really hard to hit corner case that should
be handled by the OS already.


Coly> The problem for the above step 2) is, if after system reboots and
Coly> another different process happens to have exact same pid number which
Coly> autorebuild.pid file records, check_one_sharer() will treat it as a
Coly> duplicated mdadm process and returns error with message "Only one
Coly> autorebuild process allowed in scan mode, aborting".

Coly> This patch tries to fix the above same-pid-but-different-process issue
Coly> by one more step to check the process command name,
Coly> 1) Read autorebuild.pid file
Coly>    - if file does not exist, no duplicated process, go to 4).
Coly>    - if file exists, continue to next step.
Coly> 2) Read pid number from autorebuild.pid file, then check procfs file
Coly>    comm with the specific pid directory /proc/<PID>/comm
Coly>    - if the file does not exit, it means the directory /proc/<PID> does
Coly>      not exist, go to 4)
Coly>    - if the file exits, continue next step
Coly> 3) Read process command name from /proc/<PIC>/comm, compare the command
Coly>    name with "mdadm" process name,
Coly>    - if not equal, no duplicated process, goto 4)
Coly>    - if strings are equal, print error message for duplicated process
Coly>      and exit this mdadm.
Coly> 4) Write current pid into autorebuild.pid file, continue to monitor in
Coly>    scan mode.

Coly> Now check_one_sharer() returns error for duplicated process only when
Coly> the recorded pid from autorebuild.pid exists, and the process has exact
Coly> same command name as "mdadm".

Coly> Reported-by: Shinkichi Yamazaki <shinkichi.yamazaki@suse.com>
Coly> Signed-off-by: Coly Li <colyli@suse.de>
Coly> ---
Coly>  Monitor.c | 32 ++++++++++++++++++++------------
Coly>  1 file changed, 20 insertions(+), 12 deletions(-)

Coly> diff --git a/Monitor.c b/Monitor.c
Coly> index b527165..2d6b3b9 100644
Coly> --- a/Monitor.c
Coly> +++ b/Monitor.c
Coly> @@ -301,26 +301,34 @@ static int make_daemon(char *pidfile)
 
Coly>  static int check_one_sharer(int scan)
Coly>  {
Coly> -	int pid, rv;
Coly> +	int pid;
Coly> +	FILE *comm_fp;
Coly>  	FILE *fp;
Coly> -	char dir[20];
Coly> +	char comm_path[100];
Coly>  	char path[100];
Coly> -	struct stat buf;
Coly> +	char comm[20];
Coly> +
Coly>  	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
Coly>  	fp = fopen(path, "r");
Coly>  	if (fp) {
Coly>  		if (fscanf(fp, "%d", &pid) != 1)
Coly>  			pid = -1;
Coly> -		sprintf(dir, "/proc/%d", pid);
Coly> -		rv = stat(dir, &buf);
Coly> -		if (rv != -1) {
Coly> -			if (scan) {
Coly> -				pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
Coly> -				fclose(fp);
Coly> -				return 1;
Coly> -			} else {
Coly> -				pr_err("Warning: One autorebuild process already running.\n");
Coly> +		snprintf(comm_path, sizeof(comm_path),
Coly> +			 "/proc/%d/comm", pid);
Coly> +		comm_fp = fopen(comm_path, "r");
Coly> +		if (comm_fp) {
Coly> +			if (fscanf(comm_fp, "%s", comm) &&
Coly> +			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
Coly> +				if (scan) {
Coly> +					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
Coly> +					fclose(comm_fp);
Coly> +					fclose(fp);
Coly> +					return 1;
Coly> +				} else {
Coly> +					pr_err("Warning: One autorebuild process already running.\n");
Coly> +				}
Coly>  			}
Coly> +			fclose(comm_fp);
Coly>  		}
Coly>  		fclose(fp);
Coly>  	}
Coly> -- 
Coly> 2.25.0
