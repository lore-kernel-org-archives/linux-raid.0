From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] raid1: prefer disk without bad blocks
Date: Wed, 10 May 2017 12:57:01 -0700
Message-ID: <20170510195701.dvrp52cwdyvampev@kernel.org>
References: <1494413599-8749-1-git-send-email-tomasz.majchrzak@intel.com>
 <1494422180-22772-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494422180-22772-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 03:16:20PM +0200, Tomasz Majchrzak wrote:
> If an array consists of two drives and the first drive has the bad
> block, the read request to the region overlapping the bad block chooses
> the same disk (with bad block) as device to read from over and over and
> the request gets stuck. If the first disk only partially overlaps with
> bad block, it becomes a candidate ("best disk") for shorter range of
> sectors. The second disk is capable of reading the entire requested
> range and it is updated accordingly, however it is not recorded as a
> best device for the request. In the end the request is sent to the first
> disk to read entire range of sectors. It fails and is re-tried in a
> moment but with the same outcome.
> 
> Actually it is quite likely scenario but it had little exposure in my
> test until commit 715d40b93b10 ("md/raid1: add failfast handling for
> reads.") removed preference for idle disk. Such scenario had been passing
> as second disk was always chosen when idle.
> 
> Update a candidate ("best disk") to read from if disk can read entire
> range. Do it only if other disk has already been chosen as a candidate
> for a smaller range. Otherwise, don't update it - let the head position /
> disk type logic to select a disk.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  drivers/md/raid1.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> v2:
>   updated the title not to include internal defect number :)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a1f3fbe..e7ab3bb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -628,8 +628,11 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
>  					break;
>  			}
>  			continue;
> -		} else
> +		} else {
> +			if ((sectors > best_good_sectors) && (best_disk >= 0))
> +				best_disk = disk;

best_disk = -1 seems better here to me. If this is the only disk, we will
choose in below 'if (best_disk == -1)' check. If there are more disks which
cover the whole range, we will choose the best disk with minimum seek/pending.

Thanks,
Shaohua
>  			best_good_sectors = sectors;
> +		}
>  
>  		if (best_disk >= 0)
>  			/* At least two disks to choose from so failfast is OK */
> -- 
> 1.8.3.1
> 
