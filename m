From: Brice B <nesta@iceburg.net>
Subject: Cheap NAS RAID device
Date: Sun, 4 May 2003 16:45:19 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305041645.19097.nesta@iceburg.net>
References: <S261785AbTEDVYF/20030504212405Z+2713@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S261785AbTEDVYF/20030504212405Z+2713@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm currently trying to build myself a *home* fileserver w/ the
following requirements:

1) Small, portable & durable
2) At least 240GB (maintain scalability)
3) Must be redundant (RAID 1 or 5)
4) Cannot exceed $850

 The basic application of the device will be to hold backed up data, and
to serve ogg/mp3 files.

 So far I haven't been able to find any 1U NAS turn-key raid solution for
anything under $2000 for just the chasis! So this thing is going to have to
be hacked together, and this is what I've come up with:

1 EPIA MB w/ VIA C3 800mhz Processor (mini ITX)
A tailored case [ likely out of a tape deck ]
3 120GB IDE drives
[Possilbe Raid Controller]
Linux [ 2.4 or 2.5 kernel ] w/ NFS, apache, samba

 My ?'s are:

 Will the performance of a linux software raid level 5 be sufficient w/
the VIA C3 800mhz Processor?

 Will the data be safe under LSR? ie. If a disk dies, will I be warned?
When I shutdown & replace the disk, will data remain?

 Am I better off using a 3Ware Escalade or a Promise FastTrax SX4000 to
handle my array?

 Will I have to have a 4th HD to boot off of.. or can I create a custom
bootable CD that will bring up my system (kernel, raid, apache, nfs,
samba) ? Or should I boot directly from RAID?

Thanks,

  Brice Burgess
 
