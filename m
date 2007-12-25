From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 004 of 7] md: Allow devices to be shared between md
 arrays.
Date: Tue, 25 Dec 2007 14:04:05 -0800
Message-ID: <20071225140405.550369cd.akpm@linux-foundation.org>
References: <20071214171950.1308.patches@notabene>
	<1071214062628.1872@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1071214062628.1872@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 14 Dec 2007 17:26:28 +1100 NeilBrown <neilb@suse.de> wrote:

> +		mddev_unlock(rdev->mddev);
> +		ITERATE_MDDEV(mddev, tmp) {
> +			mdk_rdev_t *rdev2;
> +
> +			mddev_lock(mddev);
> +			ITERATE_RDEV(mddev, rdev2, tmp2)
> +				if (test_bit(AllReserved, &rdev2->flags) ||
> +				    (rdev->bdev == rdev2->bdev &&
> +				     rdev != rdev2 &&
> +				     overlaps(rdev->data_offset, rdev->size,
> +					    rdev2->data_offset, rdev2->size))) {
> +					overlap = 1;
> +					break;
> +				}
> +			mddev_unlock(mddev);
> +			if (overlap) {
> +				mddev_put(mddev);
> +				break;
> +			}
> +		}

eww, ITERATE_MDDEV() and ITERATE_RDEV() are an eyesore.

for_each_mddev() and for_each_rdev() would at least mean the reader doesn't
need to check the implementation when wondering what that `break' is
breaking from.

>  #define	In_sync		2		/* device is in_sync with rest of array */
>  #define	WriteMostly	4		/* Avoid reading if at all possible */
>  #define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
> +#define	AllReserved	6		/* If whole device is reserved for

The naming style here is inconsistent.

A task for the keen would be to convert these to an enum and add some
namespacing prefix to them.  
