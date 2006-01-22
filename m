From: Michael Barnwell <xterminate@xterminate.me.uk>
Subject: Silent Corruption on RAID5
Date: Sun, 22 Jan 2006 16:44:37 +0000
Message-ID: <43D3B675.20804@xterminate.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm experiencing silent data corruption on my RAID 5 set of four 400GB 
SATA disks.

I first had the problem a couple of weeks ago and thought it was related 
to using reiserfs on my system because I hadn't used it before but have 
another perfectly functional RAID 5 array running ext3 after lots of 
testing I find the problem happens with ext3 on the array as well, and 
after even more testing I find that the problem only occurs on the array 
not the individual hard disks.

My test consists of making a ~10GB file of zeros, then checking it for 
non-zero bytes, I've also tried creating the file of zeros on a 
functional array and copying it across with the same results.

dd bs=1024 count=10000k if=/dev/zero of=./10GB.tst
od -t x1 s0/10GB.tst

These commands give me one row of zeros on my other RAID 5 set on the 
same box and on each individual hard disk in the array when I put ext3 
on them all to see if one was faulty but when they are in RAID the od 
spouts lots of non-zeros at me.

<snip>
21524747740 00 00 00 00 00 00 00 00 00 00 00 00 00 50 5c 36
21524747760 00 10 00 00 00 00 a7 23 00 10 00 80 00 00 00 00
21524750000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
21525147740 00 00 00 00 00 00 00 00 00 00 00 00 00 50 5c 36
21525147760 00 10 00 00 00 00 a7 23 00 10 00 80 00 00 00 00
21525150000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<snip>

There is a fair bit of that and the last time I ran it I got an I/O 
array and the mount went into read only mode.

I figure the problem is either with the Silicon Image 3114 hardware or 
driver that supports the array or the RAID subsystem but like I 
mentioned earlier my other RAID 5 set of three 120GB drives on two IDE 
controllers works fine.

I'm running Debian sarge with a 2.6.15-1 kernel, it has an Athlon 
XP2200, 1GB of RAM, Asus A7N8X-Deluxe motherboard, 2 Maxtor IDE 
controllers, one Silicon Image 3114 PCI adapter, along with the on-board 
Silicon Image 3112 controller - 2x 10GB IDE disks and a DVD ROM drive on 
the on-board IDE controller, 3x 120GB Seagate hard disks on the PCI IDE 
adapters, 2x 80GB Seagate disks on the on-board SilImg 3112 controller 
and finally 4x 400GB disks on the SilImg 3114 PCI adapter.


biggs:/mnt/test/s0# uname -a
Linux biggs 2.6.15.1.060121 #1 Sat Jan 21 17:01:30 GMT 2006 i686 GNU/Linux
biggs:/mnt/test/s0# cat /proc/mdstat
Personalities : [raid1] [raid5]
md2 : active raid5 sdd1[4] sdc1[2] sdb1[1] sda1[0]
       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
       [=>...................]  recovery =  8.3% (32500608/390708736) 
finish=253.3min speed=23564K/sec

md1 : active raid5 hdg1[0] hde1[2] hdi1[1]
       234436352 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid1 hdb2[0] hda2[1]
       9502336 blocks [2/2] [UU]

unused devices: <none>

(Note: md2 is the array with problems, and I've done the tests when its 
been fully synced with the same results)


So, does anyone have any suggestions or tests I could perform to narrow 
down where my problem is?

Regards,

Michael Barnwell.
