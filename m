From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 12/13] FIX: parity disks use for redundant levels only
Date: Wed, 12 Jan 2011 15:59:53 +1100
Message-ID: <20110112155953.3dd620df@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112904.10776.88816.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110112904.10776.88816.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 12:29:04 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> For raid0 reshape spares should not be increased by parity disk.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 74ec429..9d31087 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1637,7 +1637,9 @@ static int reshape_array(char *container, int fd, char *devname,
>  	}
>  	spares_needed = max(reshape.before.data_disks,
>  			    reshape.after.data_disks)
> -		+ reshape.parity - array.raid_disks;
> +			    - array.raid_disks;
> +	if (info->array.level != 0)
> +		spares_needed += reshape.parity;
>  
>  	if (!force && spares_needed < info->array.spare_disks) {
>  		fprintf(stderr,

Thanks.
I have fixed this issue differently, as follows.

NeilBrown

commit 88c1a083919b53b2e6b4ca71d17e86a26d6e4b8b
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jan 12 15:59:24 2011 +1100

    Don't complain about missing spares when reshaping a raid0.
    
    To reshape a RAID0 we convert to RAID4 first.  This makes it look
    like it could be degraded and so we are tempted to ensure there are
    enough spares.  However this is not appropriate for RAID0, so
    explicitly exclude new_level == RAID0 in this check
    
    Reported-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 9edd4c7..109b0c1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1613,7 +1613,9 @@ static int reshape_array(char *container, int fd, char *devname,
 			    reshape.after.data_disks)
 		+ reshape.parity - array.raid_disks;
 
-	if (!force && spares_needed > info->array.spare_disks) {
+	if (!force &&
+	    info->new_level > 0 &&
+	    spares_needed > info->array.spare_disks) {
 		fprintf(stderr,
 			Name ": Need %d spare%s to avoid degraded array,"
 			" and only have %d.\n"
