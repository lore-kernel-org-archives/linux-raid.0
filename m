From: Jason Lunz <lunz@falooley.org>
Subject: Re: degraded raid5 refuses to start
Date: Sun, 2 Jul 2006 01:37:40 +0000 (UTC)
Message-ID: <e87814$bvn$1@sea.gmane.org>
References: <e86oub$buu$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

lunz@falooley.org said:
> How do I get this array going again?  Am I doing something wrong?
> Reading the list archives indicates that there could be bugs in this
> area, or that I may need to recreate the array with -C (though that
> seems heavyhanded to me).

This is what I ended up doing. I made backups of the three superblocks,
then recreated them with:

# mdadm -C /dev/md2 -n4 -l5 /dev/sda3 missing /dev/hda1 /dev/hdc1

(I knew the chunk size and layout would be the same, since I just use
the defaults).

After this, the array works again. I have before and after images of the
three superblocks if anyone wants to look into how they got into this
state.

As far as I can see, the problem was that the broken array got into a
state where the superblock counts were like this:

   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Mon Jun 26 22:51:12 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0

notice how the total number of Working + Failed (5) exceeds the number
of disks in the array. Maybe there's a bug to be fixed here that lets
these counters get out of whack somehow?

After reconstructing the array, the Failed count went back down to 1,
and everything started working normally again. I wonder if simply
decrementing that one value in each superblock would have been enough to 
get the array going again, rather than rewriting all the superblocks. If
so, maybe that can be safely built into mdadm? 

Either that, or it was having two disks marked State: active and one
marked clean in the degraded array.

anyway, I have a dead disk and kept all my data, so thanks.

Jason

