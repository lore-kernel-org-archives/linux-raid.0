From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: raid1: prevent adding a "too recent" device to a mirror?
Date: Fri, 6 Aug 2010 13:14:25 -0400
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF866CE6@EXHQ.corp.stratus.com>
References: <AC1B83CE65082B4DBDDB681ED2F6B2EF866CCA@EXHQ.corp.stratus.com> <20100723133136.7cb7e6a0@notabene>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20100723133136.7cb7e6a0@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does the following patch look something like what you had in mind?

I originally did this in raid1 with a RHEL 5 (2.6.18) kernel because
that's where I need the fix, but the patch below is against md.c from a
RHEL 6 (2.6.32) kernel (since it's less removed from the latest
kernel.org kernel).

This seems to work correctly for me, only tested with raid1. Some notes:

- I had to return '0' in the add_new_disk case, because if I returned an
error mdadm would try again, with a "normal add" instead of a "re-add"
(meaning the disk would be added, and a full sync performed).

- I had to modify super_1_sync to completely fill dev_roles, instead of
just filling it in for those devices currently present in the array
(without this change, starting a raid1 with only 1 device could cause
the superblock to show two active devices, when in fact one device
should have been marked faulty).

Nate



--- md.c.orig	2010-08-06 08:53:23.000000000 -0400
+++ md.c	2010-08-06 12:49:53.000000000 -0400
@@ -854,6 +854,53 @@ static unsigned int calc_sb_csum(mdp_sup
 	return csum;
 }
 
+/* Check if an rdev to be added to an mddev is split, meaning it had
been
+   assembled without including devices currently in the array. In this
case,
+   the rdev's superblock will show faulty/removed devices which are not
+   currently faulty in the mddev. */
+static int is_split_rdev(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdk_rdev_t *rdev2;
+
+	list_for_each_entry(rdev2, &mddev->disks, same_set) {
+
+		if (rdev2 == rdev) {
+			continue;
+		}
+
+		if (test_bit(Faulty, &rdev2->flags) || (rdev2->desc_nr <
0)) {
+			continue;
+		}
+
+		if (mddev->major_version == 0) {
+
+			mdp_super_t *sb;
+			mdp_disk_t *d;
+
+			sb = (mdp_super_t *)page_address(rdev->sb_page);
+			d = &sb->disks[rdev2->desc_nr];
+
+			if (d->state &
+			    (1<<MD_DISK_FAULTY | 1<<MD_DISK_REMOVED)) {
+				return 1;
+			}
+
+		} else if (mddev->major_version == 1) {
+
+			struct mdp_superblock_1 *sb;
+			int role;
+
+			sb = (struct
mdp_superblock_1*)page_address(rdev->sb_page);
+			role =
le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
+
+			if (role == 0xfffe) {
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
 
 /*
  * Handle superblock details.
@@ -1592,7 +1639,10 @@ static void super_1_sync(mddev_t *mddev,
 		if (rdev->sb_size & bmask)
 			rdev->sb_size = (rdev->sb_size | bmask) + 1;
 	}
-	for (i=0; i<max_dev;i++)
+
+	/* Use sb->max_dev instead of max_dev so an absent device with
+	   a higher desc_nr is marked faulty. */
+	for (i=0; i<le32_to_cpu(sb->max_dev); i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
 	list_for_each_entry(rdev2, &mddev->disks, same_set) {
@@ -4338,6 +4388,15 @@ static int md_run(mddev_t *mddev)
 		analyze_sbs(mddev);
 	}
 
+	/* Refuse to start a split array. */
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (is_split_rdev(mddev, rdev)) {
+			printk("md: %s: split array, manual
intervention"
+			       " required\n", mdname(mddev));
+			return -EINVAL;
+		}
+	}
+
 	if (mddev->level != LEVEL_NONE)
 		request_module("md-level-%d", mddev->level);
 	else if (mddev->clevel[0])
@@ -5081,6 +5140,16 @@ static int add_new_disk(mddev_t * mddev,
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
+
+		/* Don't add a device that's been split from the array.
*/
+		if (is_split_rdev(mddev, rdev)) {
+			printk("md: %s: kicking %s from array:"
+			       " split array, manual intervention
required\n",
+			       mdname(mddev), bdevname(rdev->bdev,b));
+			export_rdev(rdev);
+			return 0; // so mdadm doesn't try again
+		}
+
 		/* set save_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&





-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, July 22, 2010 11:32 PM
To: Dailey, Nate
Cc: linux-raid@vger.kernel.org
Subject: Re: raid1: prevent adding a "too recent" device to a mirror?

On Thu, 22 Jul 2010 13:40:19 -0400
"Dailey, Nate" <Nate.Dailey@stratus.com> wrote:

> Hi, I'm looking for some guidance... not sure if this is a bug, or
just
> something that's not supposed to work:
> 
> - I'm working with a 2-disk raid1 with an internal bitmap, might also
> apply to other personalities
> - remove one disk from the raid1
> - make some changes to the remaining disk in the raid1
> - stop the raid1
> - assemble the raid1 using only the disk that had previously been
> removed (the less-recent disk)
> - now, add the other disk (the more-recent disk)

Yes, this is a problem scenario.

I think the right way to address it is to notice that each device thinks
that
the other is failed/removed and determine that they must be completely
out of
sync with each other, and refuse to allow the both in the same array
without
completely re-initialising one of them.

Your idea of rejecting devices with event counts larger than the bitmap
knows
about might be useful too, though I would do it in bitmap.c (which you
cannot
do as you don't want to change md-mod.ko)

Thanks,
NeilBrown


> 
> A resync occurs, but doesn't actually bring the disks into sync (doing
a
> check shows non-zero mismatch_cnt). Presumably this is because the
> bitmap on the less-recent disk has no idea of the changes made after
it
> was taken out of the mirror.
> 
> Probably not a common occurrence, but not unthinkable for this to
happen
> (in the case I'm dealing with, it was booting from a single disk from
a
> raid1 that had been set aside as a backup, then adding a more-recent
> disk to the mirror).
> 
> Is this something that should be fixed? I've been playing around with
> this, and have something that seems to work for me (keeping the change
> entirely in raid1... need to run a standard RHEL 5.5 kernel, so I
can't
> change the MD core). The basic idea is that I detect if the disk's
> superblock events counter is > the bitmap's events_cleared counter,
and
> refuse to add the disk to the raid1 in that case because it means that
> the disk being added had been assembled at some point after being
> removed from the raid1. Could instead trigger a full sync in this
case,
> though kicking the disk out allows data to be recovered from it.
> 
> There could be a similar problem if something like this happened for
an
> array without a bitmap, though in that case it would only mean loss of
> the changed data on the more-recent disk, not an incomplete sync. I
> couldn't think of an easy way around this one.
> 
> Anyway, following is a portion of the patch I'm using. Is something
like
> this generally applicable to MD? If not, do you see any problems with
my
> approach, even if it's not acceptible upstream?
> 
> --- raid1.c.orig	2010-07-22 13:31:14.000000000 -0400
> +++ raid1.c	2010-07-21 09:53:34.000000000 -0400
> 
> ... snip copies of unexported functions taken from md.c, my copies
start
> with raid1_ ...
> 
> @@ -1094,6 +1152,69 @@ static int raid1_add_disk(mddev_t *mddev
>  	int mirror = 0;
>  	mirror_info_t *p;
>  
> +	/* We need to protect against adding a "more-recent" device to
> an
> +	   array with a bitmap. Adding such a device will result in an
> +	   incomplete sync. This could happen if a device were removed
> +	   from an array, leaving the array running with only the more-
> +	   recent device. If the array were later restarted using only
> +	   the "less-recent" device, then we must prevent adding the
> more-
> +	   recent device back into the array (since the less-recent
> bitmap
> +	   wouldn't reflect changes made to the more-recent device).
> +
> +	   We depend on events_cleared to detect this condition, since
> it's
> +	   not incremented for a degraded array. Need to use sb->events_
> +	   cleared because bitmap->events_cleared isn't updated. An out-
> +	   of-date bitmap would cause events_cleared to change, and
> might
> +	   allow the more-recent device to be added to the array. This
> isn't
> +	   so bad, because this condition would also trigger a full
> sync. So,
> +	   data corruption would be avoided, but any more-recent data on
> the
> +	   more-recent device would be lost.
> +
> +	   We check saved_raid_disk >= 0 because we want to always allow
> +	   adds when a full sync will be done (saved_raid_disk < 0
> triggers
> +	   conf->fullsync = 1, below).
> +
> +	   This is not so much of a problem for an array without a
> bitmap,
> +	   since a full sync will always be done. However, it would
> still
> +	   be nice to prevent adding the more-recent device in this case
> +	   to avoid losing more-recent data on that device.
> +	*/
> +	if ((rdev->saved_raid_disk >= 0) && mddev->bitmap) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&mddev->bitmap->lock, flags);
> +		if (!mddev->bitmap->sb_page) {
> +			spin_unlock_irqrestore(&mddev->bitmap->lock,
> flags);
> +		} else {
> +			bitmap_super_t *bm_sb;
> +			mdp_super_t *sb;
> +			__u64 events, bm_events_cleared;
> +
> +			spin_unlock_irqrestore(&mddev->bitmap->lock,
> flags);
> +
> +			bm_sb = (bitmap_super_t *)
> +				kmap_atomic(mddev->bitmap->sb_page,
> KM_USER0);
> +			bm_events_cleared =
> le64_to_cpu(bm_sb->events_cleared);
> +			kunmap_atomic(bm_sb, KM_USER0);
> +
> +			sb = (mdp_super_t *)page_address(rdev->sb_page);
> +			events = md_event(sb);
> +
> +			if ((events & ~1) > bm_events_cleared) {
> +				char b[BDEVNAME_SIZE];
> +
> +				printk("raid1: %s: kicking %s from array
> (bad"
> +				       " event count %llu > %llu
> cleared),"
> +				       " manual intervention
> required\n",
> +				       mdname(mddev),
> bdevname(rdev->bdev,b),
> +				       events, bm_events_cleared);
> +				raid1_unbind_rdev_from_array(rdev);
> +				raid1_export_rdev(rdev);
> +				return 0;
> +			}
> +		}
> +	}
> +
>  	for (mirror=0; mirror < mddev->raid_disks; mirror++)
>  		if ( !(p=conf->mirrors+mirror)->rdev) {
> 
> 
> 
> Thanks for any advice you can provide,
> 
> Nate Dailey
> Stratus Technologies
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

