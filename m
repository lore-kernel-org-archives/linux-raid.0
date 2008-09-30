From: "Michael Egglestone" <michael@estone.ca>
Subject: server crash, mdadm rebuild
Date: Tue, 30 Sep 2008 10:45:11 -0700
Message-ID: <20080930172716.M76555@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

Had a server crash the other day and trying to diagnose.
Nothing was reported in the logs, its the same look and feel as
if someone walked up and pushed the reset button on the box.

At crash time, the keyboard was dead, and there was a bunch of hex data
on the screen. Nothing I could understand.  :)

Upon reboot, the md_d0 array raid 5 of 6 sata drives started a rebuild.
Finished successfully.

Since nothing was reported in the logs, I'm guessing this was some kind of 
hardware error, maybe mostly pointing to memory. 
My md_d0 is partitioned into 3 arrays, one of which is used for swap.
The other 2 are used for file storage.

Is it a bad idea to use a partition'd array for swap?
Is it a bad idea to use raid 5 for swap?

Smartmontools doesn't show anything that would suggest that a drive is going 
bad, but I suppose its still possible. 

The system is dual xeon, 8Gig RAM, running Debian 4.0 AMD64. (kernel 2.6.18)
md0 = /boot --> Raid1    (EXT3)
md1 = /     --> Raid10   (EXT3)
md_d0p1 = swap   --> Raid5
md_d0p2 = /home  --> Raid5 (XFS)
md_d0p3 = /usr/local/share --> Raid5 (XFS)

Ever hear of anything else that might cause a weird crash like that?
Maybe I shouldn't use a partitioned array?

Thanks in advance!

Cheers,
Mike


