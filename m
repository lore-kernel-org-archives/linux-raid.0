From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: close parent file descriptors when starting
 mdmon.
Date: Tue, 30 Aug 2011 09:31:57 +1000
Message-ID: <20110830093157.1ae34f8c@notabene.brown>
References: <20110829154949.15993.32383.stgit@gklab-128-044.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110829154949.15993.32383.stgit@gklab-128-044.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Aug 2011 17:49:49 +0200 Maciej Patelczyk
<maciej.patelczyk@intel.com> wrote:

> When mdadm is invoked by fork-and-exec it inherits all open file
> descriptors and when mdadm forks to exec mdmon those file descriptors
> are passed to mdmon. Mdmon closes only first 97 fd and that in some
> cases is not enough.

Can you describe and actual can when it is not enough?  Maybe there is some
other problem where mdadm is not closing things as it should.

> This commit adds function which looks at the '/proc/<pid>/fd' directory
> and closes all inherited file descriptors except the standard ones (0-2).

I'm not thrilled by this approach.
For a start, the loop could close the fd that is being used to
read /proc/<pid>/fd, so subsequent fds won't get seen or closed.

I would much rather do as the comment suggests and use O_CLOEXEC on all opens
so that everything gets closed when we do an exec.

About the most I  would be willing to do in closing more fds before the exec
is to keep closing until we get too many failures.
e.g.
  fd = 3;
  failed = 0;
  while (failed < 20) {
      if (close(fd) < 0)
          failed ++;
      else
          failed = 0;
      fd++;
  }

NeilBrown


> 
> Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
> ---
>  util.c |   41 +++++++++++++++++++++++++++++++++++++----
>  1 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/util.c b/util.c
> index ce03239..b844447 100644
> --- a/util.c
> +++ b/util.c
> @@ -30,7 +30,12 @@
>  #include	<sys/un.h>
>  #include	<ctype.h>
>  #include	<dirent.h>
> +#include	<sys/types.h>
>  #include	<signal.h>
> +#include	<stdlib.h>
> +#include	<string.h>
> +#include	<errno.h>
> +#include	<unistd.h>
>  
>  /*
>   * following taken from linux/blkpg.h because they aren't
> @@ -1571,11 +1576,41 @@ int mdmon_running(int devnum)
>  	return 0;
>  }
>  
> +static void close_parent_fds(void)
> +{
> +	pid_t pid;
> +	char buf[128];
> +	DIR *dirp;
> +	struct dirent *d_entry;
> +	int fd;
> +
> +	pid = getpid();
> +	if (snprintf(buf, sizeof(buf), "/proc/%d/fd", (int)pid) < 0)
> +		return;
> +
> +	dirp = opendir((const char *)buf);
> +	if (!dirp)
> +		return;
> +
> +	while((d_entry = readdir(dirp)) != NULL) {
> +		if (!strcmp(d_entry->d_name, ".") ||
> +		    !strcmp(d_entry->d_name, ".."))
> +			continue;
> +		errno = 0;
> +		fd = (int)strtol(d_entry->d_name, NULL, 10);
> +		if (errno)
> +			continue;
> +		if (fd > 2)
> +			close(fd);
> +	}
> +	closedir(dirp);
> +}
> +
>  int start_mdmon(int devnum)
>  {
>  	int i;
>  	int len;
> -	pid_t pid;	
> +	pid_t pid;
>  	int status;
>  	char pathbuf[1024];
>  	char *paths[4] = {
> @@ -1603,9 +1638,7 @@ int start_mdmon(int devnum)
>  
>  	switch(fork()) {
>  	case 0:
> -		/* FIXME yuk. CLOSE_EXEC?? */
> -		for (i=3; i < 100; i++)
> -			close(i);
> +		close_parent_fds();
>  		for (i=0; paths[i]; i++)
>  			if (paths[i][0])
>  				execl(paths[i], "mdmon",

