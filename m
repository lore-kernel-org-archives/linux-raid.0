From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/9] imsm:FIX: one spare can be added to raid0 only
Date: Wed, 12 Jan 2011 16:44:36 +1100
Message-ID: <20110112164436.04b5e337@notabene.brown>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140411.13862.59242.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111140411.13862.59242.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 15:04:11 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This is part of original commit "Add spares to raid0 in mdadm"
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 90bff47..ef51000 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3442,6 +3442,8 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
>  	return 0;
>  }
>  
> +static int write_super_imsm(struct supertype *st, int doclose);
> +
>  static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
>  			      int fd, char *devname)
>  {
> @@ -3506,6 +3508,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
>  		super->disks = dd;
>  	}
>  
> +	if (!mdmon_running(st->container_dev)) {
> +		dprintf("imsm: mdmon is not active- write metadata by mdadm\n");
> +		super->updates_pending++;
> +		write_super_imsm(st, 0);
> +	}
> +
>  	return 0;
>  }
>  


No.
I don't want "mdmon_running" tests in super-intel.c

What is the problem you are trying to fix (the comment in the patch should
*always* answer that question for me - I shouldn't have to ask).

NeilBrown

