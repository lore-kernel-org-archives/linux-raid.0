From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/6] FIX: mdadm throws coredump on exit in error case
Date: Mon, 17 Jan 2011 12:33:43 +1100
Message-ID: <20110117123343.07494fa2@notabene.brown>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
	<20110113145034.12728.14388.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113145034.12728.14388.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 13 Jan 2011 15:50:34 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When mdadm falls in "reduce size" error on takeovered array it jumps
> to release and tries execute backward takeover. This time sra pointer is not initialized
> and coredump is generated.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 7cc6bae..f1a6218 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1594,7 +1594,7 @@ static int reshape_array(char *container, int cfd, int fd, char *devname,
>  	unsigned long cache;
>  	unsigned long long array_size;
>  	int done;
> -	struct mdinfo *sra;
> +	struct mdinfo *sra = NULL;
>  	int info_reloaded = 0;
>  
>  
> @@ -1802,7 +1802,6 @@ static int reshape_array(char *container, int cfd, int fd, char *devname,
>  	sra = sysfs_read(fd, 0,
>  			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
>  			 GET_CACHE);
> -
>  	if (!sra) {
>  		fprintf(stderr, Name ": %s: Cannot get array details from sysfs\n",
>  			devname);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown

