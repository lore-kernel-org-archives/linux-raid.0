From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
 2.6.33
Date: Mon, 14 Dec 2009 17:37:58 -0700
Message-ID: <1260837478.23193.33.camel@dwillia2-linux.ch.intel.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	 <20091214150725.49de72f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091214150725.49de72f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2009-12-13 at 21:07 -0700, Neil Brown wrote:
> +static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t len)
> +{
> +	unsigned long long recovery_start;
> +
> +	if (cmd_match(buf, "none"))
> +		recovery_start = MaxSector;
> +	else if (strict_strtoull(buf, 10, &recovery_start))
> +		return -EINVAL;
> +
> +	if (rdev->mddev->pers &&
> +	    rdev->raid_disk >= 0)
> +		return -EBUSY;

Ok, I had a chance to test this out and have a question about how you
envisioned mdmon handling this restriction which is a bit tighter than
what I had before.  The prior version allowed updates as long as the
array was read-only.  This version forces recovery_start to be written
at sysfs_add_disk() time (before 'slot' is written). The conceptual
problem I ran into was a race between ->activate_spare() determining the
last valid checkpoint and the monitor thread starting up the array:

->activate_spare(): read recovery checkpoint
( array becomes read/write )
( array becomes dirty, checkpoint invalidated )
sysfs_add_disk(): write invalid recovery checkpoint
( recovery starts from the wrong location )

The scheme I came up with was to not touch recovery_start in the manager
thread and let the monitor thread have the last word on the recovery
checkpoint.  It would only write to md/rdX/recovery_start at the initial
readonly->active transition, otherwise recovery starts from default-0.
Is the patch below off base?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1cc5f2d..bd24e20 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2467,7 +2467,8 @@ static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t le
 	else if (strict_strtoull(buf, 10, &recovery_start))
 		return -EINVAL;
 
-	if (rdev->mddev->pers &&
+	if (mddev->ro != 1 &&
+	    rdev->mddev->pers &&
 	    rdev->raid_disk >= 0)
 		return -EBUSY;
 


