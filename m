From: "Gernot A. Weber" <gernot@tux-web.de>
Subject: broken disk?
Date: Mon, 8 Apr 2002 22:27:25 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204082219000.845-100000@kopernikus.tux-web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

since last weekend my machine (dual PIII-450) is attached to a software
raid 5 (three scsi-disks - several partitions on each - three raid
arrays). After a few hours the system freezes. I found foolowing ebtries
in the logs:

Apr  8 20:56:01 kopernikus kernel: (scsi0:A:2:0): Unexpected busfree in
Data-out
 phase
Apr  8 20:56:01 kopernikus kernel: SEQADDR == 0x1a6
Apr  8 20:56:01 kopernikus kernel: Device 08:25 not ready.
Apr  8 20:56:01 kopernikus kernel:  I/O error: dev 08:25, sector 128
Apr  8 20:56:01 kopernikus kernel: Device 08:25 not ready.

Is the disk broken? And - WHICH disk is it (I assume it's the disk with
ID2, but is there a map, which tells me the meaning of Device 08:25?)? One
disk goes offline after some hours - but I'm able to reattach it and
rebuild the data on it. I found a jumper on the disk which says enable
auto spin - what does it mean? Sorry, when I'm probably a bit out of topic
with this SCSI problems... I also got some messages like:

Apr  8 09:18:25 kopernikus kernel: (scsi0:A:2:0): Locking max tag count at
64

Are these serios?

Thanks a lot in advance

    Gernot Weber


-- 
Gernot A. Weber
http://www.tux-web.de

Only wimps use tape backup: _real_ men just upload their important stuff
on ftp, and let the rest of the world mirror it.

                              Linus Torvalds, after a hard drive crash

