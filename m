From: Eric Sandeen <sandeen@sandeen.net>
Subject: md raid1 passes barriers, but xfs doesn't use them?
Date: Mon, 23 Jun 2008 21:23:10 -0500
Message-ID: <48605A8E.9070903@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
List-Id: linux-raid.ids

So md raid1 is happy to pass down any barrier writes that it sees, but
this bit in xfs_mountfs_check_barriers() at mount time:

        if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
                                        QUEUE_ORDERED_NONE) {
                xfs_fs_cmn_err(CE_NOTE, mp,
                  "Disabling barriers, not supported by the underlying
device");
                mp->m_flags &= ~XFS_MOUNT_BARRIER;
                return;
        }

winds up with XFS disabling barriers on these devices.  However, if this
is simply commented out, XFS happily tests barriers, finds that they
work, leaves them turned on and all subsequent barrier writes to the
device succeed.

Perhaps what we have here is a failure to communicate?  :)

I'm not sure; *should* XFS be looking for a QUEUE_ORDERED tag?  Should
MD be setting one?  Maybe there should be a QUEUE_ORDERED_PASSTHRU flag?
 Or should XFS just stick with the test write and ignore the flag?  I'm
not sure of the queue->ordered flag details, but it seems that XFS & md
raid1 both try hard to keep barriers in force, and there's a disconnect
here somewhere.

Thanks,
-Eric
