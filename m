From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 2/2] fix mdmon takeover
Date: Wed, 3 Mar 2010 11:52:53 +1100
Message-ID: <20100303115253.48645cfb@notabene.brown>
References: <cover.1267282753.git.bluca@comedia.it>
	<2-2.1267282753.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2-2.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 27 Feb 2010 16:07:51 +0100
Luca Berra <bluca@comedia.it> wrote:

> there are two cases that would result in two mdmon processes for the
> same array
> takeover not detecting pid file in ALT_RUN
> if running mdmon a second time without "--takeover"
> 
> Signed-off-by: Luca Berra <bluca@comedia.it>
> ---
>   mdmon.c |   10 +++++++++-
>   msg.c   |    2 +-
>   util.c  |    4 ++--
>   3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mdmon.c b/mdmon.c
> index d593ebc..a2b7946 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -441,7 +441,6 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   	sigaction(SIGPIPE, &act, NULL);
>   
>   	if (takeover) {
> -		pid_dir = VAR_RUN;
>   		victim = mdmon_pid(container->devnum);
>   		if (victim < 0) {
>   			pid_dir = ALT_RUN;

Is this just a micro-optimisation? or does it have some real functional
significance?

> @@ -453,6 +452,15 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   
>   	ignore = chdir("/");
>   	if (victim < 0) {
> +		pid_dir = ALT_RUN;
> +		if (ping_monitor(container->devname) == 0) {
> +			fprintf(stderr, "mdmon: %s already managed\n",
> +				container->devname);
> +			if (!takeover)
> +				fprintf(stderr, "\trun mdmon --takeover instead\n");
> +			exit(3);
> +		}
> +		pid_dir = VAR_RUN;
>   		if (ping_monitor(container->devname) == 0) {
>   			fprintf(stderr, "mdmon: %s already managed\n",
>   				container->devname);

I don't understand this.  We always know where the pid file is, why do we
have to check again?

> diff --git a/msg.c b/msg.c
> index cc07b96..d2d8445 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -147,7 +147,7 @@ int connect_monitor(char *devname)
>   	int pos;
>   	char *c;
>   
> -	pos = sprintf(path, "%s/", VAR_RUN);
> +	pos = sprintf(path, "%s/", pid_dir);
>   	if (is_subarray(devname)) {
>   		devname++;
>   		c = strchr(devname, '/');

This is correct, thanks.

> diff --git a/util.c b/util.c
> index 1def2a0..2fe566d 100644
> --- a/util.c
> +++ b/util.c
> @@ -1475,11 +1475,11 @@ int mdmon_pid(int devnum)
>   	fd = open(path, O_RDONLY | O_NOATIME, 0);
>   
>   	if (fd < 0)
> -		return 0;
> +		return -1;
>   	n = read(fd, pid, 9);
>   	close(fd);
>   	if (n <= 0)
> -		return 0;
> +		return -1;
>   	return atoi(pid);
>   }
>   

This is needed too.
For now I'll keep just the last two chunks.

Thanks.
NeilBrown

