From: Tom Oehser <tom@toms.net>
Subject: superblock, kicking non-fresh, ide slaves, problems, ideas
Date: Wed, 30 Jun 2004 12:50:06 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406301240560.324@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I have 2 raid 5 arrays-

 - one is 4 hardware/scsi disks with the system and speed-sensitive stuff.

 - one is 4 software/ide disks with large files, not-speed-critical stuff.

So, the motherboard having 2 connectors, and not caring so much
about the speed issue, I put the IDE drives 2 per cable into the MB.

So, an IDE drive failed (hda).

- It hosed the DMA on that channel, so that hdb wouldn't work either.

- When the system shut down, it wrote new superblocks to hdc and hdd.

- So, now I can't bring up the array, as hdb is "kicking non-fresh"
  (even though, in fact, there was no activity when hda failed, the
  filesystems were not even mounted).

One question, and one comment:

- Is this something where:

	mdadm -A -f /dev/md0 /dev/hdb1 /dev/hdc1 /dev/hdd1

  will fix it?  Is this command safe?

- Is there some smartness that the raid driver could be given such
  that it would detect this kind of situation, especially with ide
  channels failing this way, and not put the superblocks of the 3
  good drives out of sync when the 1 drive goes down?

-Help, -Tom

