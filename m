From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/3] md: ping userspace on 'write-pending' events
Date: Thu, 1 May 2008 14:44:48 +1000
Message-ID: <18457.19136.168378.816525@notabene.brown>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	<20080430011933.20468.45086.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday April 29
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 29, dan.j.williams@intel.com wrote:
> Also, when userspace writes 'active', clear all mddev->flags to satisfy
> md_write_start (the other bits do not matter to external-metadata arrays).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks Dan.

There are two things that I don't like about this patch.

1/ I don't think clearing all the flags in array_state_store is really
   right.   You do that to make sure that MD_CHANGE_DEVS is clear, but
   there is no guarantee that it won't be set again before it is
   tested in md_write_start.
   I think it is best to just get md_write_start (and md_allow_write)
   to just test the bits they are really interested in.

2/ having the tests of mddev->external isn't necessary.  I really want
   "array_state" to get a notification whenever it changes, no matter
   what sort of metadata is being used.

Change the patch based on those observations I get:

---------------------------------
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:58.000000000 +1000
+++ ./drivers/md/md.c	2008-05-01 14:35:16.000000000 +1000
@@ -5434,8 +5434,11 @@ void md_write_start(mddev_t *mddev, stru
 			md_wakeup_thread(mddev->thread);
 		}
 		spin_unlock_irq(&mddev->write_lock);
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
 	}
-	wait_event(mddev->sb_wait, mddev->flags==0);
+	wait_event(mddev->sb_wait,
+		   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 }
 
 void md_write_end(mddev_t *mddev)
@@ -5470,6 +5473,12 @@ void md_allow_write(mddev_t *mddev)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
 		md_update_sb(mddev, 0);
+
+		sysfs_notify(&mddev->kobj, NULL, "array_state");
+		/* wait for the dirty state to be recorded in the metadata */
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 	} else
 		spin_unlock_irq(&mddev->write_lock);
 }
----------------------------

Look OK ??

Thanks,
NeilBrown


> ---
> 
>  drivers/md/md.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6859bcd..ad53035 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2664,7 +2664,7 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
>  		if (mddev->pers) {
>  			restart_array(mddev);
>  			if (mddev->external)
> -				clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +				mddev->flags = 0;
>  			wake_up(&mddev->sb_wait);
>  			err = 0;
>  		} else {
> @@ -5413,9 +5413,14 @@ void md_write_start(mddev_t *mddev, struct bio *bi)
>  		if (mddev->in_sync) {
>  			mddev->in_sync = 0;
>  			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +			spin_unlock_irq(&mddev->write_lock);
> +
> +			/* notify userspace to handle clean->dirty */
> +			if (mddev->external)
> +				sysfs_notify(&mddev->kobj, NULL, "array_state");
>  			md_wakeup_thread(mddev->thread);
> -		}
> -		spin_unlock_irq(&mddev->write_lock);
> +		} else
> +			spin_unlock_irq(&mddev->write_lock);
>  	}
>  	wait_event(mddev->sb_wait, mddev->flags==0);
>  }
> @@ -5451,7 +5456,13 @@ void md_allow_write(mddev_t *mddev)
>  		    mddev->safemode == 0)
>  			mddev->safemode = 1;
>  		spin_unlock_irq(&mddev->write_lock);
> -		md_update_sb(mddev, 0);
> +
> +		/* wait for the dirty state to be recorded in the metadata */
> +		if (mddev->external) {
> +			sysfs_notify(&mddev->kobj, NULL, "array_state");
> +			wait_event(mddev->sb_wait, mddev->flags == 0);
> +		} else
> +			md_update_sb(mddev, 0);
>  	} else
>  		spin_unlock_irq(&mddev->write_lock);
>  }
