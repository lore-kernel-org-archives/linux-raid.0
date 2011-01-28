From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/7] FIX: Array after takeover has to be frozen
Date: Fri, 28 Jan 2011 10:40:16 +1000
Message-ID: <20110128104016.0b91cc75@nbeee.brown>
References: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
	<20110126150341.20454.8079.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126150341.20454.8079.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 26 Jan 2011 16:03:41 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> Problem occurs when we want to expand single disk raid0 array.
> This is done via degraded 2 disks raid4 array. When new spare
> is added to array, md immediately initiates recovery before
> mdadm can configure and start reshape. This is due fact that 2 disk
> raid4/5 array is special md case. Mdmon does nothing here because
> container is blocked.
> Put array in to frozen state allows mdadm to finish configuration
> before reshape is executed in md.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index df352f8..8b9625d 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1657,6 +1657,7 @@ static int reshape_array(char *container, int
> fd, char *devname, fprintf(stderr, Name ": level of %s changed to
> %s\n", devname, c);	
>  		orig_level = info->array.level;
> +		sysfs_freeze_array(info);
>  	}
>  
>  	if (reshape.level > 0 && st->ss->external &&

This looks like it is in the wrong place.  Surely we should freeze the
array *before* we set the level - though as long as it is frozen before
we add spares I suspect it works OK.

I have moved the 'freeze' earlier, but I think I need to rethink all
the freezing - it doesn't seem very tidy at the moment.

Thanks,
NeilBrown
