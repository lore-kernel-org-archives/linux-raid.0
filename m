From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: imsm: Do not change serial if disk failed
Date: Thu, 24 Mar 2011 10:17:45 +1100
Message-ID: <20110324101745.524e90e2@notabene.brown>
References: <20110323163629.15574.93174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110323163629.15574.93174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 23 Mar 2011 17:36:29 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> This patch rollback one change connected with mdadm-OROM
> compatibility:
> adding ':0' at the end of disk serial number if disk is
> detected as failed.
> Current mdadm's implementation does not distinguish two
> cases when disk is marked as failed:
> 1. If disk is really failed- disconnected, broken
> 2. Just marked as failed by mdadm- using "-f" option
> 
> Second case is not yet fully handled and compatible with
> IMSM standard.
> Changing serial number of existing, operational disk causes
> problems in "thunderdome" and "load_super" functions that use
> serial numbers to disks comparisons and searching.
> The change must be recalled until full support will be
> developed.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  super-intel.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 2b41e08..a91bcc2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5232,11 +5232,6 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
>  	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
>  		return 0;
>  
> -	sprintf(buf, "%s:0", disk->serial);
> -	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
> -		shift = len - MAX_RAID_SERIAL_LEN + 1;
> -	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
> -
>  	disk->status |= FAILED_DISK;
>  	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
>  	if (map->failed_disk_num == 0xff)


Applied thanks.

That was my last remaining issue before I'm comfortable releasing
mdadm-3.2.1
Does Intel have anything concerns about releasing the current code as
mdadm-3.2.1?

Thanks,
NeilBrown
