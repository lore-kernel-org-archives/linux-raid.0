From: Neil Brown <neilb@suse.de>
Subject: Re: Growing raid 5 to 6; /proc/mdstat reports a strange value?
Date: Wed, 10 Feb 2010 13:12:55 +1100
Message-ID: <20100210131255.7cd8ccdb@notabene.brown>
References: <4877c76c1001241949p20089932saae123a1c2871ac0@mail.gmail.com>
	<20100129232334.45a4103c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129232334.45a4103c@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jan 2010 23:23:34 +1100
Neil Brown <neilb@suse.de> wrote:

> On Sun, 24 Jan 2010 19:49:31 -0800
> Michael Evans <mjevans1983@gmail.com> wrote:
> 
> > mdX : active raid5 sdd1[8](S) sdb1[7](S) sdf8[0] sdl8[4] sdk2[5]
> > sdc1[6] sdj6[3] sdi8[1]
> >      Y blocks super 1.1 level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]
> > 
> > # mdadm --grow /dev/mdX --level=6 --raid-devices=8
> > --backup-file=/root/mdX.backupfile
> > 
> > mdX : active raid6 sdd1[8] sdb1[7] sdf8[0] sdl8[4] sdk2[5] sdc1[6]
> > sdj6[3] sdi8[1]
> >      Y blocks super 1.1 level 6, 128k chunk, algorithm 18 [8/9] [UUUUUU_U]
> >      [>....................]  reshape =  0.0% (33920/484971520)
> > finish=952.6min speed=8480K/sec
> > 
> > !!! mdadm 3.1.1 I wanted an 8 device raid-6;  Why do you show 9?
> 
> That is weird isn't it.  It is showing that 8 devices are in the array, of
> which 9 are working.  That cannot be right.
> More worrying is that the second last device claim to not be present, which
> doesn't seem right.

The second last device being missing is actually correct.  The '_' doesn't
actually mean "missing" but just "not completely in-sync".
When you converted from RAID5 to RAID6 it added the 7th device which clearly
was not in-sync.
Then converting to an 8-device array added the 8th device, but as the array
was not expecting any data to be on this device it is by definition
in-sync and so represented by "U".

The only problem is that it says "9" are in-sync where it should say "7"
are.
The following patch, which I have submitted upstream, fixes this.

Thanks again for the report.

NeilBrown


Author: NeilBrown <neilb@suse.de>
Date:   Tue Feb 9 12:31:47 2010 +1100

    md: fix 'degraded' calculation when starting a reshape.
    
    This code was written long ago when it was not possible to
    reshape a degraded array.  Now it is so the current level of
    degraded-ness needs to be taken in to account.  Also newly addded
    devices should only reduce degradedness if they are deemed to be
    in-sync.
    
    In particular, if you convert a RAID5 to a RAID6, and increase the
    number of devices at the same time, then the 5->6 conversion will
    make the array degraded so the current code will produce a wrong
    value for 'degraded' - "-1" to be precise.
    
    If the reshape runs to completion end_reshape will calculate a correct
    new value for 'degraded', but if a device fails during the reshape an
    incorrect decision might be made based on the incorrect value of
    "degraded".
    
    This patch is suitable for 2.6.32-stable and if they are still open,
    2.6.31-stable and 2.6.30-stable as well.
    
    Cc: stable@kernel.org
    Reported-by: Michael Evans <mjevans1983@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e84204e..b5629c3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5464,11 +5464,11 @@ static int raid5_start_reshape(mddev_t *mddev)
 		    !test_bit(Faulty, &rdev->flags)) {
 			if (raid5_add_disk(mddev, rdev) == 0) {
 				char nm[20];
-				if (rdev->raid_disk >= conf->previous_raid_disks)
+				if (rdev->raid_disk >= conf->previous_raid_disks) {
 					set_bit(In_sync, &rdev->flags);
-				else
+					added_devices++;
+				} else
 					rdev->recovery_offset = 0;
-				added_devices++;
 				sprintf(nm, "rd%d", rdev->raid_disk);
 				if (sysfs_create_link(&mddev->kobj,
 						      &rdev->kobj, nm))
@@ -5480,9 +5480,12 @@ static int raid5_start_reshape(mddev_t *mddev)
 				break;
 		}
 
+	/* When a reshape changes the number of devices, ->degraded
+	 * is measured against the large of the pre and post number of
+	 * devices.*/
 	if (mddev->delta_disks > 0) {
 		spin_lock_irqsave(&conf->device_lock, flags);
-		mddev->degraded = (conf->raid_disks - conf->previous_raid_disks)
+		mddev->degraded += (conf->raid_disks - conf->previous_raid_disks)
 			- added_devices;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
