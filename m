From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/5] FIX: Validate input in ping_monitor function
Date: Thu, 27 Jan 2011 13:14:22 +1000
Message-ID: <20110127131422.7bc7ff5e@nbeee.brown>
References: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
	<20110124141728.16405.6921.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110124141728.16405.6921.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, 24 Jan 2011 15:17:29 +0100
Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:

> For native case we do not have monitor running so we have to
> return without pinging.
> Moreover we have NULL as input parameter. We should to avoid
> segmentation fault.

I have not applied this patch or the next one.
I would rather not call ping_XXX when not needed, rather than have it
check if it was needed or not.

NeilBrown

> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  msg.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/msg.c b/msg.c
> index 76e74e7..b97ebec 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -206,8 +206,13 @@ int fping_monitor(int sfd)
>  /* give the monitor a chance to update the metadata */
>  int ping_monitor(char *devname)
>  {
> -	int sfd = connect_monitor(devname);
> -	int err = fping_monitor(sfd);
> +	int sfd, err;
> +
> +	if (!devname)
> +		return -1;
> +
> +	sfd = connect_monitor(devname);
> +	err = fping_monitor(sfd);
>  
>  	close(sfd);
>  	return err;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

