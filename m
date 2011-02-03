From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: crash during getting map
Date: Thu, 3 Feb 2011 17:03:38 +1100
Message-ID: <20110203170338.38c28ae3@notabene.brown>
References: <20110201075736.4921.34737.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201075736.4921.34737.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 01 Feb 2011 08:57:37 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When get_imsm_map() is called with second_map parameter == '-1'
> and array is not in migration state NULL pointer is returned.
> This is wrong. '-1' means return map as migration record points.
> 
> '-1' can be passed to get_imsm_map() from imsm_num_data_members().
> imsm_num_data_members() is called to get current map members based
> on migr_state information
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 84ab47b..ee0d9c4 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -567,15 +567,16 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
>  {
>  	struct imsm_map *map = &dev->vol.map[0];
>  
> -	if (second_map && !dev->vol.migr_state)
> +	if ((second_map == 1) && !dev->vol.migr_state)
>  		return NULL;
> -	else if (second_map) {
> +	else if ((second_map == 1) ||
> +		 ((second_map < 0) && (dev->vol.migr_state))) {
>  		void *ptr = map;
>  
>  		return ptr + sizeof_imsm_map(map);
>  	} else
>  		return map;
> -		
> +
>  }
>  
>  /* return the size of the device.

Thanks.
I added some comments and took the opportunity to simplify
get_imsm_ord_tbl_ent.  See below.

NeilBrown

commit 5e7b0330669594ee79201d19ff45a7850fa0f951
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Thu Feb 3 17:02:39 2011 +1100

    imsm: FIX: crash during getting map
    
    When get_imsm_map() is called with second_map parameter == '-1'
    and array is not in migration state NULL pointer is returned.
    This is wrong. '-1' means return map as migration record points.
    
    '-1' can be passed to get_imsm_map() from imsm_num_data_members().
    imsm_num_data_members() is called to get current map members based
    on migr_state information
    
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index 84ab47b..4081071 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -565,17 +565,24 @@ static size_t sizeof_imsm_map(struct imsm_map *map)
 
 struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
+	/* A device can have 2 maps if it is in the middle of a migration.
+	 * If second_map is:
+	 *    0   - we return the first map
+	 *    1   - we return the second map if it exists, else NULL
+	 *   -1   - we return the second map if it exists, else the first
+	 */
 	struct imsm_map *map = &dev->vol.map[0];
 
-	if (second_map && !dev->vol.migr_state)
+	if (second_map == 1 && !dev->vol.migr_state)
 		return NULL;
-	else if (second_map) {
+	else if (second_map == 1 ||
+		 (second_map < 0 && dev->vol.migr_state)) {
 		void *ptr = map;
 
 		return ptr + sizeof_imsm_map(map);
 	} else
 		return map;
-		
+
 }
 
 /* return the size of the device.
@@ -654,14 +661,7 @@ static __u32 get_imsm_ord_tbl_ent(struct imsm_dev *dev,
 {
 	struct imsm_map *map;
 
-	if (second_map == -1) {
-		if (dev->vol.migr_state)
-			map = get_imsm_map(dev, 1);
-		else
-			map = get_imsm_map(dev, 0);
-	} else {
-		map = get_imsm_map(dev, second_map);
-	}
+	map = get_imsm_map(dev, second_map);
 
 	/* top byte identifies disk under rebuild */
 	return __le32_to_cpu(map->disk_ord_tbl[slot]);
