From: Neil Brown <neilb@suse.de>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Tue, 8 Aug 2006 21:12:14 +1000
Message-ID: <17624.29070.246605.213021@cse.unsw.edu.au>
References: <or8xlztvn8.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alexandre Oliva on Tuesday August 8
Sender: linux-raid-owner@vger.kernel.org
To: Alexandre Oliva <aoliva@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 8, aoliva@redhat.com wrote:
> Assume I have a fully-functional raid 1 between two disks, one
> hot-pluggable and the other fixed.
> 
> If I unplug the hot-pluggable disk and reboot, the array will come up
> degraded, as intended.
> 
> If I then modify a lot of the data in the raid device (say it's my
> root fs and I'm running daily Fedora development updates :-), which
> modifies only the fixed disk, and then plug the hot-pluggable disk in
> and re-add its members, it appears that it comes up without resyncing
> and, well, major filesystem corruption ensues.
> 
> Is this a known issue, or should I try to gather more info about it?

Looks a lot like
   http://bugzilla.kernel.org/show_bug.cgi?id=6965

Attached are two patches.  One against -mm and one against -linus.

They are below.

Please confirm if the appropriate one help.

NeilBrown

(-mm)

Avoid backward event updates in md superblock when degraded.

If we
  - shut down a clean array,
  - restart with one (or more) drive(s) missing
  - make some changes
  - pause, so that they array gets marked 'clean',
the event count on the superblock of included drives
will be the same as that of the removed drives.
So adding the removed drive back in will cause it
to be included with no resync.

To avoid this, we only update the eventcount backwards when the array
is not degraded.  In this case there can (should) be no non-connected
drives that we can get confused with, and this is the particular case
where updating-backwards is valuable.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-08-03 11:42:48.000000000 +1000
+++ ./drivers/md/md.c	2006-08-07 08:57:10.000000000 +1000
@@ -1609,6 +1609,17 @@ repeat:
 		nospares = 1;
 	if (force_change)
 		nospares = 0;
+	if (mddev->degraded)
+		/* If the array is degraded, then skipping spares is both
+		 * dangerous and fairly pointless.
+		 * Dangerous because a device that was removed from the array
+		 * might have a event_count that still looks up-to-date,
+		 * so it can be re-added without a resync.
+		 * Pointless because if there are any spares to skip,
+		 * then a recovery will happen and soon that array won't
+		 * be degraded any more and the spare can go back to sleep then.
+		 */
+		nospares = 0;
 
 	sync_req = mddev->in_sync;
 	mddev->utime = get_seconds();

---------------------------------------

(-linus)

Avoid backward event updates in md superblock when degraded.

If we
  - shut down a clean array,
  - restart with one (or more) drive(s) missing
  - make some changes
  - pause, so that they array gets marked 'clean',
the event count on the superblock of included drives
will be the same as that of the removed drives.
So adding the removed drive back in will cause it
to be included with no resync.

To avoid this, we only update the eventcount backwards when the array
is not degraded.  In this case there can (should) be no non-connected
drives that we can get confused with, and this is the particular case
where updating-backwards is valuable.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-08-08 09:00:44.000000000 +1000
+++ ./drivers/md/md.c	2006-08-08 09:04:04.000000000 +1000
@@ -1597,6 +1597,19 @@ void md_update_sb(mddev_t * mddev)
 
 repeat:
 	spin_lock_irq(&mddev->write_lock);
+
+	if (mddev->degraded && mddev->sb_dirty == 3)
+		/* If the array is degraded, then skipping spares is both
+		 * dangerous and fairly pointless.
+		 * Dangerous because a device that was removed from the array
+		 * might have a event_count that still looks up-to-date,
+		 * so it can be re-added without a resync.
+		 * Pointless because if there are any spares to skip,
+		 * then a recovery will happen and soon that array won't
+		 * be degraded any more and the spare can go back to sleep then.
+		 */
+		mddev->sb_dirty = 1;
+
 	sync_req = mddev->in_sync;
 	mddev->utime = get_seconds();
 	if (mddev->sb_dirty == 3)
