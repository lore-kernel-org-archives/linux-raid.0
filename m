From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 01/21] imsm: FIX: Cannot create volume
Date: Thu, 9 Jun 2011 12:42:18 +1000
Message-ID: <20110609124218.1b7f7457@notabene.brown>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
	<20110608160941.24327.74788.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160941.24327.74788.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 08 Jun 2011 18:09:41 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Clearing info structure causes mdadm is not able to create workable volume.
> 
> During volume creation info structure passed to getinfo() function
> contains some information already and cannot be cleared.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index b8d8b4e..471dbd2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2075,7 +2075,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>  	unsigned int component_size_alligment;
>  	int map_disks = info->array.raid_disks;
>  
> -	memset(info, 0, sizeof(*info));
>  	if (prev_map)
>  		map_to_analyse = prev_map;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I'm sorry, but this is just a very silly patch.

In many caches the 'info' structure is completely uninitialised, so it really
does make sense to initialise it, which is why I added that.
Just removing it *must* be wrong.

It would be much more helpful if you had explained what the "some
information" was.

Maybe it is the '->next' field that container_content_imsm() sets before
calling getinfo_super_imsm_volume()?? Well that getinfo_super_imsm_volume
doesn't use that field, so we can just move the assignment afterwards.

or maybe ... getinfo_super_imsm_volume uses info->disk.raid_disk, but no
caller ever sets that up that I can see, so that code is plainly wrong
(though ddf makes the same mistake so that is probably my fault).
I've 'fixed' them both to just report on the 'first' disk as that is no worse
than what they currently do.

I that doesn't fix your problem, please explain exactly what is being cleared
that shouldn't be.

NeilBrown

commit 9894ec0d64a9faab719d016bbbf5fbc842757df6
Author: NeilBrown <neilb@suse.de>
Date:   Thu Jun 9 12:42:02 2011 +1000

    Fix some fall-out from recent memset-zero for getinfo_super
    
    container_content_imsm was setting info->next before calling
    getinfo_super_imsm_container which now zeros everything.
    So move that assignment to afterwards.
    
    So both imsm and ddf were assuming info->disk.raid_disk means
    something but it doesn't.  So fix those.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-ddf.c b/super-ddf.c
index 21a917e..3fba2eb 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1429,9 +1429,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 			info->component_size = __be64_to_cpu(vc->conf.blocks);
 	}
 
-	for (dl = ddf->dlist; dl ; dl = dl->next)
-		if (dl->raiddisk == info->disk.raid_disk)
-			break;
+	dl = ddf->dlist;
 	info->disk.major = 0;
 	info->disk.minor = 0;
 	if (dl) {
diff --git a/super-intel.c b/super-intel.c
index b8d8b4e..6fed9eb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2079,9 +2079,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	if (prev_map)
 		map_to_analyse = prev_map;
 
-	for (dl = super->disks; dl; dl = dl->next)
-		if (dl->raiddisk == info->disk.raid_disk)
-			break;
+	dl = super->disks;
+
 	info->container_member	  = super->current_vol;
 	info->array.raid_disks    = map->num_members;
 	info->array.level	  = get_imsm_raid_level(map_to_analyse);
@@ -5446,11 +5445,10 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 				sizeof(*this));
 			break;
 		}
-		memset(this, 0, sizeof(*this));
-		this->next = rest;
 
 		super->current_vol = i;
 		getinfo_super_imsm_volume(st, this, NULL);
+		this->next = rest;
 		for (slot = 0 ; slot <  map->num_members; slot++) {
 			unsigned long long recovery_start;
 			struct mdinfo *info_d;

