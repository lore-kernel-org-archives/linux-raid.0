From: jes.sorensen@gmail.com
Subject: Re: [PATCH 2/4] mdadm/util:integrate fstat operations into one utility function
Date: Wed, 05 Apr 2017 11:43:44 -0400
Message-ID: <wrfj4ly2eu6n.fsf@gmail.com>
References: <20170401125145.14440-1-zlliu@suse.com>
        <20170401125145.14440-3-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-3-zlliu@suse.com> (Zhilong Liu's message of
        "Sat, 1 Apr 2017 20:51:43 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> mdadm/util: there are dupilicate codes about fstat checking the
> block device, move the operations into one utility function and
> make it concise.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    | 10 ++--------
>  Create.c      |  5 +----
>  Grow.c        |  4 +---
>  Incremental.c | 13 +------------
>  bitmap.c      | 12 ++++--------
>  mdadm.h       |  1 +
>  super-intel.c | 10 ++--------
>  util.c        | 15 +++++++++++++++
>  8 files changed, 27 insertions(+), 43 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index c6571e6..47c6685 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -204,14 +204,8 @@ static int select_devices(struct mddev_dev *devlist,
>  				pr_err("cannot open device %s: %s\n",
>  				       devname, strerror(errno));
>  			tmpdev->used = 2;
> -		} else if (fstat(dfd, &stb)< 0) {
> -			/* Impossible! */
> -			pr_err("fstat failed for %s: %s\n",
> -			       devname, strerror(errno));
> -			tmpdev->used = 2;
> -		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -			pr_err("%s is not a block device.\n",
> -			       devname);
> +		} else if (check_blkdev_via_fstat(dfd, devname) &&
> +			   fstat(dfd, &stb)) {
>  			tmpdev->used = 2;
>  		} else if (must_be_container(dfd)) {
>  			if (st) {

Same complaint as prior patch, do not run fstat() twice!!!!

Jes
