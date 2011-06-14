From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: Sometimes reshape cannot be finished
Date: Wed, 15 Jun 2011 09:15:36 +1000
Message-ID: <20110615091536.59a8a3fd@notabene.brown>
References: <20110614125622.12762.4928.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110614125622.12762.4928.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 14 Jun 2011 14:56:22 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When array size is not aligned to copy area, number of migration unit
> is increased in init_migr_record_imsm():7665 to reshape whole array.
> During calculation of last migration unit, this should be in mind also,
> otherwise checkpoint (max-1) is always written and reshape
> is never finished in mdadm.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 5dc8ca8..d525295 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7788,20 +7788,30 @@ abort:
>  int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
>  {
>  	struct intel_super *super = st->sb;
> +	unsigned long long blocks_per_unit;
> +
>  	if (load_imsm_migr_rec(super, info) != 0) {
>  		dprintf("imsm: ERROR: Cannot read migration record "
>  			"for checkpoint save.\n");
>  		return 1;
>  	}
>  
> -	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
> +	blocks_per_unit = __le32_to_cpu(super->migr_rec->blocks_per_unit);
> +	if (blocks_per_unit == 0) {
>  		dprintf("imsm: no migration in progress.\n");
>  		return 2;
>  	}
> -
>  	super->migr_rec->curr_migr_unit =
> -	  __cpu_to_le32(info->reshape_progress /
> -			__le32_to_cpu(super->migr_rec->blocks_per_unit));
> +		info->reshape_progress / blocks_per_unit;
> +	/* check if array is alligned to copy area
> +	 * if it is not alligned, add one to current migration unit value
> +	 * this can happend on array reshape finish only
> +	 */
> +	if (info->reshape_progress % blocks_per_unit)
> +		super->migr_rec->curr_migr_unit++;
> +	super->migr_rec->curr_migr_unit =
> +		__cpu_to_le32(super->migr_rec->curr_migr_unit);
> +
>  	super->migr_rec->rec_status = __cpu_to_le32(state);
>  	super->migr_rec->dest_1st_member_lba =
>  	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit))


I think it is a bit untidy storing a value in cpu-order in super->migr_rec
and then changing it to little-endian later.  It feels error prone.
So I have changed it to use a local variable for the cpu-order version as
below.

Thanks,
NeilBrown

commit f8b72ef517ea305f714230b0503f94ae5f1b8fa4
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Wed Jun 15 09:13:49 2011 +1000

    imsm: FIX: Sometimes reshape cannot be finished
    
    When array size is not aligned to copy area, number of migration unit
    is increased in init_migr_record_imsm():7665 to reshape whole array.
    During calculation of last migration unit, this should be in mind also,
    otherwise checkpoint (max-1) is always written and reshape
    is never finished in mdadm.
    
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index 5dc8ca8..bb76f74 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7788,24 +7788,34 @@ abort:
 int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 {
 	struct intel_super *super = st->sb;
+	unsigned long long blocks_per_unit;
+	unsigned long long curr_migr_unit;
+
 	if (load_imsm_migr_rec(super, info) != 0) {
 		dprintf("imsm: ERROR: Cannot read migration record "
 			"for checkpoint save.\n");
 		return 1;
 	}
 
-	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+	blocks_per_unit = __le32_to_cpu(super->migr_rec->blocks_per_unit);
+	if (blocks_per_unit == 0) {
 		dprintf("imsm: no migration in progress.\n");
 		return 2;
 	}
+	curr_migr_unit = info->reshape_progress / blocks_per_unit;
+	/* check if array is alligned to copy area
+	 * if it is not alligned, add one to current migration unit value
+	 * this can happend on array reshape finish only
+	 */
+	if (info->reshape_progress % blocks_per_unit)
+		curr_migr_unit++;
 
 	super->migr_rec->curr_migr_unit =
-	  __cpu_to_le32(info->reshape_progress /
-			__le32_to_cpu(super->migr_rec->blocks_per_unit));
+		__cpu_to_le32(curr_migr_unit);
 	super->migr_rec->rec_status = __cpu_to_le32(state);
 	super->migr_rec->dest_1st_member_lba =
-	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit))
-			* __le32_to_cpu(super->migr_rec->dest_depth_per_unit));
+		__cpu_to_le32(curr_migr_unit *
+			      __le32_to_cpu(super->migr_rec->dest_depth_per_unit));
 	if (write_imsm_migr_rec(st) < 0) {
 		dprintf("imsm: Cannot write migration record "
 			"outside backup area\n");
