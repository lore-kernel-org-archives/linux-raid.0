From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Prepare mdadm for migrations (external meta)
Date: Mon, 14 Feb 2011 11:17:18 +1100
Message-ID: <20110214111718.446fb4ac@notabene.brown>
References: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 10 Feb 2011 14:55:53 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This few patches prepares mdadm for level and chunk size migration using external metadata.
> 1. FIX: delta_disk can have UnSet value
>   A while ago I've reported problem that delta_disks can have UnSet value, so adding it
>   to raid_disks can produce error in mdadm. Looking my first patch you proposed
>   to address this problem by changing reshape_super() interface rather than
>   set condition on function call. This patch implements your idea.
> 
> 2. FIX: Get spares from external metadata
>    imsm: FIX: Add spare disks information to array description
>   Those 2 patches addresses problem with not initializes spares counter in mdinfo
>   using external metadata.
> 
> 3. FIX: Add raid5 to raid0 case to analyse_change()
>   This patch adds missing of level transition in Grow.c

I've applied all of these though I changed the last one to:


--- a/Grow.c
+++ b/Grow.c
@@ -1056,6 +1056,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		info->array.layout = ALGORITHM_PARITY_N;
 	case 5:
 		switch (info->new_level) {
+		case 0:
 		case 4:
 			re->level = info->array.level;
 			re->before.data_disks = info->array.raid_disks - 1;


as I think that is all that is required.

Thanks,

NeilBrown


> 
> This series should be applied on devel-3.2 branch with my yesterday's 4 patches
> 
> BR
> Adam
> 
> ---
> 
> Adam Kwolek (4):
>       FIX: Add raid5 to raid0 case to analyse_change()
>       imsm: FIX: Add spare disks information to array description
>       FIX: Get spares from external metadata
>       FIX: delta_disk can have UnSet value
> 
> 
>  Grow.c        |   36 ++++++++++++++++++++++++++++++------
>  mdadm.h       |    3 ++-
>  super-intel.c |   14 +++++++++++++-
>  3 files changed, 45 insertions(+), 8 deletions(-)
> 

