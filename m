From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: indicate that metadada has to be written
Date: Sun, 20 Mar 2011 15:49:16 +1100
Message-ID: <20110320154916.6aff5cd1@notabene.brown>
References: <20110318092822.12990.23679.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110318092822.12990.23679.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 10:28:22 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> During adding spare disks to raid0, spare metadata is not written.
> This is due to exit form sync_metadata() on empty updates_pending flag.
> 
> When mdmon is absent indicate sync_metadata() to flush changes to disks.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 44c100b..acd7571 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3838,6 +3838,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
>  	} else {
>  		dd->next = super->disks;
>  		super->disks = dd;
> +		super->updates_pending++;
>  	}
>  
>  	return 0;


Applied, thanks.

NeilBrown
