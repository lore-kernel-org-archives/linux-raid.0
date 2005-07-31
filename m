From: Gordon Henderson <gordon@drogon.net>
Subject: Re: SATA RAID-1 benchmarks
Date: Sun, 31 Jul 2005 10:31:16 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
References: <E1Dz603-0005Ah-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1Dz603-0005Ah-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Jul 2005, Jeff Breidenbach wrote:

>
> Hi all,
>
> I just ran a Linux software RAID-1 benchmark with some 500GB SATA
> drives in NCQ mode, along with a non-RAID control. Details are here
> for those interested.
>
>       http://www.jab.org/raid-bench/
>
> Comments are appreciated. I'm curious if people are happy, sad, or
> surprised by any of the numbers, and whether or not a hardware RAID
> would have a prayer of doing better in any category.

The results you get are about what I get on various systems - essentially
with RAID-1 you get about the same speed as a single drive will get. You
can get a little bit more if the reads read from alternative disks (which
I understand they do based on the strip size). Writing is the killer
though as it has to write to both disks at the same time, but on a 2-disk
setup I've not noticed much difference from a single drive. I have a few
systems that have a 4-way (and more) RAID-1 for the boot/root partition
and then writes are slower, but it's not an issue for them.

I've not used a hardware raid system for many years though, so no real
clues about how good or bad they might be these days. Personally I'm a
shade wary of them, especially if you need additional drivers - if I was
going down that route, I think I'd rather have a completely separate box
that just connects in with a single SCSI cable and looks like a single
SCSI disk, so you can use it with your favourite known and trusted SCSI
card and driver, but then who's to say that the SCSI card driver is any
better (or worse) than the RAID card driver...


Heres one of my typical 2-disk IDE setups (Athlon XP2400+, 512MB RAM,
nVidia nForce2 IDE controller)

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
cerberus         1G           47356  19 25435   8           48554   8 312.1   0

cerberus:/var/tmp# hdparm -tT /dev/md1 /dev/hda1 /dev/hdc1

/dev/md1:
 Timing cached reads:   1472 MB in  2.00 seconds = 735.01 MB/sec
 Timing buffered disk reads:  172 MB in  3.02 seconds =  56.94 MB/sec

/dev/hda1:
 Timing cached reads:   1480 MB in  2.00 seconds = 738.64 MB/sec
 Timing buffered disk reads:  174 MB in  3.03 seconds =  57.38 MB/sec

/dev/hdc1:
 Timing cached reads:   1468 MB in  2.00 seconds = 733.74 MB/sec
 Timing buffered disk reads:  170 MB in  3.01 seconds =  56.54 MB/sec


and heres a 2 disk SATA system: (Xeon HT 3GHz, 2GB RAM, Intel SATA
controller)

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ns1              4G           46985  17 21626   6           46214   4 355.3   0

ns1:/var/tmp# hdparm -tT /dev/md1 /dev/sda1 /dev/sdb1

/dev/md1:
 Timing cached reads:   4116 MB in  2.00 seconds = 2058.31 MB/sec
 Timing buffered disk reads:  174 MB in  3.00 seconds =  57.99 MB/sec

/dev/sda1:
 Timing cached reads:   4096 MB in  2.00 seconds = 2048.31 MB/sec
 Timing buffered disk reads:  176 MB in  3.03 seconds =  58.11 MB/sec

/dev/sdb1:
 Timing cached reads:   4116 MB in  2.00 seconds = 2057.28 MB/sec
 Timing buffered disk reads:  176 MB in  3.02 seconds =  58.27 MB/sec

(Both running the same OS; Debian sarge with a custom compiled 2.6.11
kernel)

So theres not much in it-really. Right now, for the smaller 2-disk servers
I'm building, I'm sticking to traditional IDE/P-ATA - but thats just
because I still see problems with things like SMART and HDDTEMP with SATA
drives. I'm sure this will improve in time though, and when I have the
budget, it's still SCSI drives for stability and performance.

There are lots of really "cute"/easy to use SATA drive caddy and backplane
systems now though, so it is tempting to use them for bigger multi TB
storage systems...

Gordon
