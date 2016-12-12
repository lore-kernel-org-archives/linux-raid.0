From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Always return last partition end address in 512B blocks
Date: Mon, 12 Dec 2016 14:30:28 -0500
Message-ID: <wrfjshptrlm3.fsf@redhat.com>
References: <1481195606-13227-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481195606-13227-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Thu, 8 Dec 2016 12:13:26 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> For 4K disks 'endofpart' is an index of the last 4K sector used by partition.
> mdadm is using number of 512-byte sectors, so value returned by
> get_last_partition_end must be multiplied by 8 for devices with 4K sectors.
> Also, unused 'ret' variable has been removed.
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  util.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

I am a little wary of this since I don't have any 4k sector drivers to
test with, so I will come yelling at you if this breaks something :)

> diff --git a/util.c b/util.c
> index 883eaa4..46c1280 100644
> --- a/util.c
> +++ b/util.c
> @@ -1430,6 +1430,7 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
>  	struct MBR boot_sect;
>  	unsigned long long curr_part_end;
>  	unsigned part_nr;
> +	unsigned int sector_size;
>  	int retval = 0;
>  
>  	*endofpart = 0;
> @@ -1469,6 +1470,9 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
>  		/* Unknown partition table */
>  		retval = -1;
>  	}
> +	/* calculate number of 512-byte blocks */
> +	if (get_dev_sector_size(fd, NULL, &sector_size))
> +		*endofpart *= sector_size/512;

I really would prefer to see a parenthesis around this here and use of
proper spacing.

Thanks,
Jes
