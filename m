From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
Date: Mon, 28 Apr 2008 20:51:08 -0700
Message-ID: <20080428205108.874eb9e3.akpm@linux-foundation.org>
References: <20080429133104.20146.patches@notabene>
	<1080429033527.20385@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1080429033527.20385@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, 29 Apr 2008 13:35:27 +1000 NeilBrown <neilb@suse.de> wrote:

> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Found when trying to reassemble an active externally managed array.
> Without this check we hit the more noisy "sysfs duplicate" warning in
> the later call to kobject_add.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/md.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> +++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
> @@ -1369,6 +1369,11 @@ static int bind_rdev_to_array(mdk_rdev_t
>  		MD_BUG();
>  		return -EINVAL;
>  	}
> +
> +	/* prevent duplicates */
> +	if (find_rdev(mddev, rdev->bdev->bd_dev))
> +		return -EEXIST;
> +
>  	/* make sure rdev->size exceeds mddev->size */
>  	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
>  		if (mddev->pers) {

Smells racy.  Do we have enough locking in place here to make this more
than a best-effort thing?
