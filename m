From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RAID5: Fixing or Recovering Faulty Disk
Date: Thu, 27 Jun 2002 13:41:05 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNACEPFDAAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just expanded our RAID5 software raid from 6 to 9 disks. Prior to the
change, there were no problems. There were no errors on the console or in
the logs after installing the disks, before reconfiguring the RAID. I had
some data corruption problems with "raidreconf" so I reconstructed the RAID
from scratch. Again, no apparent errors.

When I began to restore the data to the array, /dev/sdc generated some
errors (see below) and was marked faulty, then kicked from the array. The
hot spare was picked up and synced properly.

I have now completely restored the data but I want to fix whatever was wrong
with "sdc" and add it back into the array. I could find no documentation
about how to remove the "faulty" flag or check the disk for bad blocks
without adding it to the array. I'm assuming that it may have had some bad
spots on the disk, but it's a little suspicious that this happened after
upgrading the array. This particular disk drive was not physically touched
during the hardware upgrade. All other drives appear to be operating
normally.

I'd appreciate any feedback you folks can offer.

--Cal Webster
Network Manager
NAWCTSD ISEO CPNC
cwebster@ec.rr.com


