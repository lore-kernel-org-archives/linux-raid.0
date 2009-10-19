From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 11/12] mdmon: exec(2) when the switchroot argument is
	not "/"
Date: Mon, 19 Oct 2009 12:57:59 +1100
Message-ID: <19163.51111.737753.564465@notabene.brown>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
	<20091014021111.31570.92486.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday October 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids


Hi Dan,
 thanks for all these.  I have pulled them and pushed them out.

However:

On Tuesday October 13, dan.j.williams@intel.com wrote:
> Try to execute mdmon from the target namespace.  When used for initramfs
> handovers we need to drop all references to the initramfs filesystem for
> that memory to be freed.

I'm not 100% sure of this one.

Presumably an initramfs is mounted at '/', and the new root is mounted
at e.g. /newroot, and we are running:

  mdmon md127 /newroot

and we want to drop all references to '/' that are held by mdmon.
Is that right?
This doesn't do that.  The working directory and the root directory
are still '/' and the newly exec'ed mdmon isn't going to drop them.

Don't you want:
   chdir(switchroot);
   chroot(switchroot);
   execl("/sbin/mdmon", "mdmon", devname, NULL);

and not bother with the sprintf??

NeilBrown


> 
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  mdmon.c |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/mdmon.c b/mdmon.c
> index 5f87e78..d3e8be5 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -369,6 +369,29 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
>  
>  	dprintf("starting mdmon for %s in %s\n",
>  		devname, switchroot ? : "/");
> +
> +	/* try to spawn mdmon instances from the target file system */
> +	if (switchroot && strcmp(switchroot, "/") != 0) {
> +		char path[1024];
> +		pid_t pid;
> +
> +		sprintf(path, "%s/sbin/mdmon", switchroot);
> +		switch (fork()) {
> +		case 0:
> +			execl(path, "mdmon", devname, NULL);
> +			exit(1);
> +		case -1:
> +			return 1;
> +		default:
> +			pid = wait(&status);
> +			if (pid > -1 && WIFEXITED(status) &&
> +			    WEXITSTATUS(status) == 0)
> +				return 0;
> +			else
> +				return 1;
> +		}
> +	}
> +
>  	mdfd = open_dev(devnum);
>  	if (mdfd < 0) {
>  		fprintf(stderr, "mdmon: %s: %s\n", devname,
