From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Mon, 2 Jul 2007 08:35:18 +0200
Message-ID: <200707020835.18420.infomails@tronserver.dyndns.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <18056.9918.537787.152462@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18056.9918.537787.152462@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 02 July 2007 00:12:14 Neil Brown wrote:

> Kernel logs from the boot would help here.
> Logs would help.

Sure. The interesting part from dmesg is this:

hdg: max request size: 512KiB
hdg: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63, 
UDMA(100)
hdg: cache flushes supported
 hdg: hdg1 hdg2 hdg3 hdg4
hda: max request size: 512KiB
hda: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, 
UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdb: max request size: 512KiB
hdb: 490234752 sectors (251000 MB) w/7936KiB Cache, CHS=30515/255/63, 
UDMA(100)
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3 hdb4
md: md3 stopped.
md: bind<hdb3>
md: bind<hda3>
raid5: device hda3 operational as raid disk 0
raid5: device hdb3 operational as raid disk 1
raid5: allocated 3163kB for md3
raid5: raid level 5 set md3 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:hda3
 disk 1, o:1, dev:hdb3

What I really don't understand is the output of /proc/mdstat after a reboot:

Personalities : [raid6] [raid5] [raid4]
md4 : active raid5 hdg4[1] hda4[2]
      368643328 blocks level 5, 4k chunk, algorithm 2 [3/2] [_UU]

md2 : active raid5 hda2[0] hdg2[2]
      1027968 blocks level 5, 4k chunk, algorithm 2 [3/2] [U_U]

md3 : active raid5 hda3[0] hdb3[1]
      20980736 blocks level 5, 4k chunk, algorithm 2 [3/2] [UU_]

All arrays are degraded, but different disks are missing. md3 (the root 
partition) is missing its hdg, as the logfile tells. md2 and md4 are now 
missing its hdb:

md: md2 stopped.
md: bind<hdg2>
md: bind<hda2>
raid5: device hda2 operational as raid disk 0
raid5: device hdg2 operational as raid disk 2
raid5: allocated 3163kB for md2
raid5: raid level 5 set md2 active with 2 out of 3 devices, algorithm 2

Btw., is that significant that the order is different? In md4, the hdg-disk is 
raid-disk 1, whereas it is raid-disk 2 in md2. 

> Maybe /etc/mdadm/mdadm.conf lists "device=...." where it shouldn't.

Should be irrelevant, as the root-fs, where mdadm.conf resides, is on a raid 
itself.

> Maybe the other IDE controller uses a module that it loaded late.

Hmm, I'd need to check that after I rebuild the arrays. Maybe the other 
IDE-controller is not in the initrd. That wouldn't explain the missing hdb, 
though.
-- 
YT,
Michael
