From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Problem with patch: "reject a re-add request that cannot be honoured"
 (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Wed, 6 Jun 2012 19:09:25 +0300
Message-ID: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
it looks like we are hitting an issue with this patch.
Kernel is stock ubuntu-precise (3.2.0-23 36), mdadm is v3.2.3. (We are
aware that this version of mdadm has an issue of unaligned writes, so
we backported the fix to it into this version).

We are testing the following simple scenario:
# 2-way raid1 with a missing drive
# a fresh drive (no superblock) is added (not re-added) to the raid,
and the raid happily starts rebuilding it
# at some point in time, this drive fails, so rebuild aborts, drive is
kicked out.
# later the drive recovers and "mdadm remove & re-add" is attempted
# re-add fails

Some debugging suggests the following:

- The superblock of the drive to be re-added looks like this:

 Avail Dev Size : 10483712 (5.00 GiB 5.37 GB)
     Array Size : 10483688 (5.00 GiB 5.37 GB)
  Used Dev Size : 10483688 (5.00 GiB 5.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 100096 sectors
          State : clean
  Resync Offset : N/A sectors
    Device UUID : d9114d02:76153894:87aaf09d:c55da9be
Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jun  6 18:36:55 2012
       Checksum : 94468c9d - correct
         Events : 192
   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)


So the drive has a valid recovery offset (MD_FEATURE_RECOVERY_OFFSET
set) and a valid role.

- The "re-add" path of mdadm performs calls getinfo_super1(), which performs:
role = __le16_to_cpu(sb->dev_roles[__le32_to_cpu(sb->dev_number)]);
...
info->disk.state = 6; /* active and in sync */
info->disk.raid_disk = role;

So at this point, MD_DISK_ACTIVE and MD_DISK_SYNC are set.

- mdadm issues ADD_NEW_DISK, which arrives to add_new_disk() in the kernel
- the kernel performs:
if (!mddev->persistent) {
... // not relevant to our case
} else
	super_types[mddev->major_version].
		validate_super(mddev, rdev);

- validate_super() performs:
	if ((le32_to_cpu(sb->feature_map) &
	     MD_FEATURE_RECOVERY_OFFSET))
		rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
	else
		set_bit(In_sync, &rdev->flags);
	rdev->raid_disk = role;

So In_sync flag is not set, because we have a recovery offset.

- Then the code introduced by the patch does:
	if ((info->state & (1<<MD_DISK_SYNC)) &&
	    (!test_bit(In_sync, &rdev->flags) ||
	     rdev->raid_disk != info->raid_disk)) {
		/* This was a hot-add request, but events doesn't
		 * match, so reject it.
		 */
		export_rdev(rdev);
		return -EINVAL;
	}

So the first part of "OR" succeeds and we abort.

An observation: this problem only happens with a fresh drive
apparently. If drive that was already In_sync fails and then is
re-added, kernel does not update its superblock until recovery
completes. So its superblock has no valid recovery_offset, and this
problem doesn't happen. The code that skips updating the superblock
was added as part of this email thread:
http://www.spinics.net/lists/raid/msg36275.html. However, I did not
dig deeper why the superblock gets updated in my case. But the
scenario above repros easily.

Q1: Can you confirm that my analysis is correct?
Q2: Is this an expected behavior? I would assume that no, because the
same case for a failed drive (not a fresh drive) works fine
Q3: How would you recommend to handle this?

Thanks!
Alex.
