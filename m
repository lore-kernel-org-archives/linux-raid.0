From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 5/9] mdmon: mdmon_pid should return pid from
 either dir
Date: Wed, 3 Mar 2010 12:50:31 +1100
Message-ID: <20100303125031.4ae998cb@notabene.brown>
References: <cover.1267282753.git.bluca@comedia.it>
	<20100228144123.GA24781@maude.comedia.it>
	<20100228144340.GD24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100228144340.GD24781@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 28 Feb 2010 15:43:40 +0100
Luca Berra <bluca@comedia.it> wrote:

> mdmon_pid is called by mdmon_running to check if mdmon is running, so
> the pid file should be checked in either VAR_RUN or ALT_RUN

I don't agree with this.

The only time that any code should care about ALT_RUN is when mdmon is
starting.  It chooses VAR_RUN or ALT_RUN to use, and possibly looks for an
old instance to kill.

When starting mdmon without "--takeover", if it decided to use VAR_RUN, it
would not check ALT_RUN to see if an old mdmon was running.  So I have
replaced you patch with a patch to include that extra check when starting
mdmon without --takeover.
Maybe that is the case you intended to address??

Thanks,
NeilBrown



> 
> Signed-off-by: Luca Berra <bluca@comedia.it>
> ---
>   mdadm.h |    2 +-
>   mdmon.c |    6 +++---
>   util.c  |   14 ++++++++++++--
>   3 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/mdadm.h b/mdadm.h
> index df3a056..7efa8bf 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -897,7 +897,7 @@ extern int open_container(int fd);
>   
>   extern char *pid_dir;
>   extern int mdmon_running(int devnum);
> -extern int mdmon_pid(int devnum);
> +extern int mdmon_pid(int devnum, const char *pid_dir);
>   extern int check_env(char *name);
>   extern __u32 random32(void);
>   extern int start_mdmon(int devnum);
> diff --git a/mdmon.c b/mdmon.c
> index 57fd492..3410e84 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -441,10 +441,10 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   	sigaction(SIGPIPE, &act, NULL);
>   
>   	if (takeover) {
> -		victim = mdmon_pid(container->devnum);
> +		victim = mdmon_pid(container->devnum, pid_dir);
>   		if (victim < 0) {
>   			pid_dir = ALT_RUN;
> -			victim = mdmon_pid(container->devnum);
> +			victim = mdmon_pid(container->devnum, pid_dir);
>   		}
>   		if (victim >= 0)
>   			victim_sock = connect_monitor(container->devname);
> @@ -467,7 +467,7 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   			exit(3);
>   		}
>   		/* if there is a pid file, kill whoever is there just in case */
> -		victim = mdmon_pid(container->devnum);
> +		victim = mdmon_pid(container->devnum, NULL);
>   	}
>   	if (container->ss->load_super(container, mdfd, devname)) {
>   		fprintf(stderr, "mdmon: Cannot load metadata for %s\n",
> diff --git a/util.c b/util.c
> index 2fe566d..50e04bf 100644
> --- a/util.c
> +++ b/util.c
> @@ -1465,12 +1465,22 @@ int fd2devnum(int fd)
>   
>   char *pid_dir = VAR_RUN;
>   
> -int mdmon_pid(int devnum)
> +int mdmon_pid(int devnum, const char *pid_dir)
>   {
>   	char path[100];
>   	char pid[10];
>   	int fd;
>   	int n;
> +
> +	/* if pid_dir is null try to detect it */
> +	if (!pid_dir) {
> +		n = mdmon_pid(devnum, VAR_RUN);
> +		if (n >= 0)
> +			return n;
> +		else
> +			return mdmon_pid(devnum, ALT_RUN);
> +	}
> +
>   	sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
>   	fd = open(path, O_RDONLY | O_NOATIME, 0);
>   
> @@ -1485,7 +1495,7 @@ int mdmon_pid(int devnum)
>   
>   int mdmon_running(int devnum)
>   {
> -	int pid = mdmon_pid(devnum);
> +	int pid = mdmon_pid(devnum, NULL);
>   	if (pid <= 0)
>   		return 0;
>   	if (kill(pid, 0) == 0)

