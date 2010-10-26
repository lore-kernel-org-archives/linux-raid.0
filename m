From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md/raid5: initialize ->recovery_offset when growing
 raid_disks
Date: Tue, 26 Oct 2010 16:35:24 +1100
Message-ID: <20101026163524.09b9e812@notabene>
References: <20101022180311.6563.6666.stgit@localhost6.localdomain6>
	<20101022180359.6563.11717.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101022180359.6563.11717.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 22 Oct 2010 11:03:59 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> We mark the disk in-sync, and also need to init ->recovery_offset lest
> we confuse older versions of mdadm that don't consider this case at
> assembly (i.e. that when growing we assume the disk is insync).
> 
> mdadm: /dev/md0 assembled from 3 drives and  1 rebuilding - not enough to start the array.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/raid5.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9e8ecd5..f8a27d4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5580,6 +5580,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  			if (raid5_add_disk(mddev, rdev) == 0) {
>  				char nm[20];
>  				if (rdev->raid_disk >= conf->previous_raid_disks) {
> +					rdev->recovery_offset = MaxSector;
>  					set_bit(In_sync, &rdev->flags);
>  					added_devices++;
>  				} else


Sorry, but I'm not getting this one....

rdev->recovery_offset is only ever used when In_sync is clear.  So it makes
no sense to give it a value when In_sync is set.

Maybe there are some places where we clear In_sync that need to have
recovery_offset set to zero, but it isn't obvious to me that that would
explain your symptom.

Can you give a bit more detail of the problem you are seeing please?

Thanks,
NeilBrown
