From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: getinfo_super_imsm_volume() doesn't fill all
 disk information
Date: Thu, 14 Jul 2011 15:42:31 +1000
Message-ID: <20110714154231.160be763@notabene.brown>
References: <20110701163448.28088.30128.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110701163448.28088.30128.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 01 Jul 2011 18:34:48 +0200 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> From: Adam Kwolek <adam.kwolek@intel.com>
> 
> Issue:
> getinfo_super_imsm_volume() clears entire 'info' structure before filling with new
> information. Disk number and raid_disk can be required later by caller
> but it is also cleared.
> 
> Resolution:
> Patch backs up all disk information before zeroing info structure and
> restore it before function return.
> The patch aslo reverses workaround for the same problem introduced
> in commit:
> 
> 80e4abc99c7f5a16c56c1c4084bfad63aec03c01
> FIX: Cannot create volume
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Create.c      |    9 ---------
>  super-intel.c |   13 ++++++++++++-
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index 48115db..8d88aa1 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -856,15 +856,6 @@ int Create(struct supertype *st, char *mddev,
>  					/* getinfo_super might have lost these ... */
>  					inf->disk.major = major(stb.st_rdev);
>  					inf->disk.minor = minor(stb.st_rdev);
> -					/* FIXME the following should not be needed
> -					 * as getinfo_super is suppose to set
> -					 * them.  However it doesn't for imsm,
> -					 * so we have this hack for now
> -					 */
> -					if (st->ss == &super_imsm) {
> -						inf->disk.number = dnum;
> -						inf->disk.raid_disk = dnum;
> -					}
>  				}
>  				break;
>  			case 2:
> diff --git a/super-intel.c b/super-intel.c
> index 0bddc6b..e3a693c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2204,11 +2204,20 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>  	unsigned int component_size_alligment;
>  	int map_disks = info->array.raid_disks;
>  
> -	memset(info, 0, sizeof(*info));
>  	if (prev_map)
>  		map_to_analyse = prev_map;
>  
> +	/* find requested (by info->disk.number) disk on the list */
>  	dl = super->disks;
> +	while (dl) {
> +		if (dl->index == info->disk.number)
> +			break;
> +		dl = dl->next;
> +	}
> +	if (!dl)
> +		dl = super->disks;
> +
> +	memset(info, 0, sizeof(*info));
>  
>  	info->container_member	  = super->current_vol;
>  	info->array.raid_disks    = map->num_members;
> @@ -2275,6 +2284,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>  	if (dl) {
>  		info->disk.major = dl->major;
>  		info->disk.minor = dl->minor;
> +		info->disk.number = dl->index;
> +		info->disk.raid_disk = dl->index;
>  	}
>  
>  	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
> 

I'm sorry, but this is still wrong.  Sometimes getinfo_super_imsm_volume
is called with an uninitialised 'info' so using any value for any field it
in is wrong (with the exception that if 'map' is not NULL, then
array.raid_disks must be set).

Here is the correct patch which I have now applied.

NeilBrown

commit ca0748fa494425dc025441a8622088126e25e61d
Author: NeilBrown <neilb@suse.de>
Date:   Thu Jul 14 15:42:10 2011 +1000

    imsm: getinfo_super_imsm_volume() doesn't fill all disk information
    
    getinfo_super_imsm_volume doesn't correctly set info.disk fields
    because it doesn't know which disk to set them from.
    It should be the last disk passed to add_to_super.
    
    So add a field 'current_disk' to record this disk in add_to_super, and
    use it in getinfo_super.
    
    This allows us to remove a hack in Create.c
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Create.c b/Create.c
index 48115db..8d88aa1 100644
--- a/Create.c
+++ b/Create.c
@@ -856,15 +856,6 @@ int Create(struct supertype *st, char *mddev,
 					/* getinfo_super might have lost these ... */
 					inf->disk.major = major(stb.st_rdev);
 					inf->disk.minor = minor(stb.st_rdev);
-					/* FIXME the following should not be needed
-					 * as getinfo_super is suppose to set
-					 * them.  However it doesn't for imsm,
-					 * so we have this hack for now
-					 */
-					if (st->ss == &super_imsm) {
-						inf->disk.number = dnum;
-						inf->disk.raid_disk = dnum;
-					}
 				}
 				break;
 			case 2:
diff --git a/super-intel.c b/super-intel.c
index 70cf993..b5868e9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -341,7 +341,7 @@ struct intel_super {
 		struct extent *e; /* for determining freespace @ create */
 		int raiddisk; /* slot to fill in autolayout */
 		enum action action;
-	} *disks;
+	} *disks, *current_disk;
 	struct dl *disk_mgmt_list; /* list of disks to add/remove while mdmon
 				      active */
 	struct dl *missing; /* disks removed while we weren't looking */
@@ -2201,7 +2201,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	if (prev_map)
 		map_to_analyse = prev_map;
 
-	dl = super->disks;
+	dl = super->current_disk;
 
 	info->container_member	  = super->current_vol;
 	info->array.raid_disks    = map->num_members;
@@ -2263,11 +2263,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		info->new_chunk = info->array.chunk_size;
 		info->delta_disks = 0;
 	}
-	info->disk.major = 0;
-	info->disk.minor = 0;
+
 	if (dl) {
 		info->disk.major = dl->major;
 		info->disk.minor = dl->minor;
+		info->disk.number = dl->index;
+		info->disk.raid_disk = dl->index;
 	}
 
 	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
@@ -4349,7 +4350,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		mpb->family_num = __cpu_to_le32(sum);
 		mpb->orig_family_num = mpb->family_num;
 	}
-
+	super->current_disk = dl;
 	return 0;
 }
 
