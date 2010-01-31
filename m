From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Sun, 31 Jan 2010 15:21:35 -0500
Message-ID: <7c2a12e21001311221r57f41ae8r7ee20470adcd8d6a@mail.gmail.com>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
	 <20100109192326.GB16383@rap.rap.dk>
	 <87bpgmyu37.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bpgmyu37.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Keld Jorn Simonsen <keld@keldix.com>, Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 22, 2010 at 11:37 AM, Goswin von Brederlow
<goswin-v-b@web.de> wrote:
> I think his initial idea of raid1 is verry good. With write-mostly all
> reads should come from the fast SSD. I would also add write-behind.
> That way writes will not wait for the rotating disk and get the full
> SSD speed as well.

Recently I got an Intel X25-M 80G, and have been trying this out.  I
figured some people here might be interested in the results.  I've
mirrored the SSD to a slow 80G partition on an old spinning-rust 160G
disk, which is set to write-mostly, with write-behind of 16384 (the
max).  The bitmap is on a separate unmirrored partition on the SSD.
My root filesystem is on it, ext4 on top of LVM, using 60G out of
73.77G allocated to LVM, with a separate 500M-ish mirrored boot
partition at the start, and a gap in between for storing unmirrored
things (like all my RAID bitmaps).

I did six runs of bonnie++ overnight:

1) 128 files, both disks working.
2) 1024 files, both disks working.
3) 128 files, conventional disk failed and removed.
4) 1024 files, conventional disk failed and removed.
5) Same as (2).
6) Same as (4).  (Note that in this case, the disk ended up being
failed but not removed, but this should make no difference.)

At the end of this e-mail, I've attached the full script I ran and its
full output.  These are the bonnie++ numbers for the six tests, best
viewed in a fixed-width font on a pretty wide screen (126 chars):

         |      Sequential out      |  Sequential in   | Random  |
|     Sequential create     |       Random create      |
         |per char| block  |rewrite |per char|  block  | Seeks   |
| Create |  Read   | Delete | Create |  Read   |Delete |
monoid,6G,47571,90,55343,30,41390,24,55803,96,233594,54,4923.0,36,
128,25973,94,+++++,+++,15910,41,27179,85,+++++,+++,11922,38
monoid,6G,48358,90,55378,25,41338,25,56883,95,233689,52,4233.0,29,1024,19819,70,64728,
75,  848, 4,14928,60,55484, 79,  463, 3
monoid,6G,48751,90,77485,27,45263,25,55660,94,238757,49,5107.7,33,
128,28027,86,+++++,+++,20161,49,29618,88,+++++,+++,14780,43
monoid,6G,44503,83,73894,29,42975,26,56463,95,237173,53,5052.9,36,1024,18073,73,66151,
81, 5348,28,18102,65,60213, 77, 3441,23
monoid,6G,48580,91,55567,24,40748,22,56803,95,237006,49,4828.2,29,1024,20332,67,73175,
80,  783, 4,13615,45,58066, 74,  489, 3
monoid,6G,48966,92,77517,29,43999,24,56863,94,198557,38,3553.8,16,1024,19273,68,72414,
86, 6326,31,16499,60,56438, 75, 2784,15

(Where two numbers are given, the first is KB out per second and the
second is CPU usage, as far as I can figure.) Note that there was lots
of memory free here, about 2.5G (-/+ buffers/cache as reported by
free).  My conclusions:

1) The file creation tests with only 128 files should just be ignored,
they look like they're in-memory.  The 1024-file tests look more
plausible.

2) All reads perform comparably whether the extra disk is present or
not, as expected.  There's some variation, but then, I wasn't being
very scientific.

3) Tests 3, 4, and 6 (only SSD) are about 35% faster on the sequential
out rewrite test.  The per-char sequential out test was CPU-bound, and
everything performed the same.  Everything also performed the same on
the rewrite test; I'm not sure why.

4) Sequential file creation is about the same between tests 4 and 6
(only SSD) and tests 2 and 5 (both disks).  Random file creation gives
the disk+SSD about a 20% lead.  But both sequential and random
deletion have an order-of-magnitude difference between the two.  I
don't know why this might be -- lots of buffering for some operations
but not others?

Overall, this seems like a very feasible setup, and I'll certainly be
sticking with it, even though it will obviously slow down some writes.
 Hope this data will be useful (or at least interesting) to someone.

The script that I ran from the at job follows, with a couple of
comments added.  I ran it using ionice -c1 to reduce the effects of
any concurrent operations.



#!/bin/bash
cd /tmp
echo Test 1; echo
free -m
bonnie -u 0 -n 128
echo; echo Test 2; echo
free -m
echo
bonnie -u 0 -n 1024
echo; echo Test 3; echo
free -m
echo
mdadm --fail /dev/md1 /dev/sda2
sleep 5
mdadm --remove /dev/md1 /dev/sda2
echo
bonnie -u 0 -n 128
echo; echo Test 4; echo
free -m
echo
bonnie -u 0 -n 1024
echo
free -m
echo; echo 'Re-adding sda2 and waiting for sync'; echo
sudo mdadm --add /dev/md1 --write-mostly /dev/sda2
sleep 1800
cat /proc/mdstat
echo; echo Test 5; echo
free -m
echo
bonnie -u 0 -n 1024
echo
mdadm --fail /dev/md1 /dev/sda2
# The second command was run too fast and failed, I forgot the sleep 5
from above.
mdadm --remove /dev/md1 /dev/sda2
echo; echo Test 6; echo
free -m
echo
bonnie -u 0 -n 1024
echo
free -m
echo
# Also failed, since the device hadn't been removed.
sudo mdadm --add /dev/md1 --write-mostly /dev/sda2




Output of script:




Test 1

            total       used       free     shared    buffers     cached
Mem:          3024       2085        938          0        589        973
-/+ buffers/cache:        522       2501
Swap:         1023        526        497
Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 47571  90 55343  30 41390  24 55803  96 233594  54  4923  36
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
               128 25973  94 +++++ +++ 15910  41 27179  85 +++++ +++ 11922  38
monoid,6G,47571,90,55343,30,41390,24,55803,96,233594,54,4923.0,36,128,25973,94,+++++,+++,15910,41,27179,85,+++++,+++,11922,38

Test 2

            total       used       free     shared    buffers     cached
Mem:          3024        544       2480          0         51         30
-/+ buffers/cache:        462       2562
Swap:         1023        526        497

Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 48358  90 55378  25 41338  25 56883  95 233689  52  4233  29
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
              1024 19819  70 64728  75   848   4 14928  60 55484  79   463   3
monoid,6G,48358,90,55378,25,41338,25,56883,95,233689,52,4233.0,29,1024,19819,70,64728,75,848,4,14928,60,55484,79,463,3

Test 3

            total       used       free     shared    buffers     cached
Mem:          3024        788       2235          0        332         50
-/+ buffers/cache:        405       2619
Swap:         1023        565        458

mdadm: set /dev/sda2 faulty in /dev/md1
mdadm: hot removed /dev/sda2

Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 48751  90 77485  27 45263  25 55660  94 238757  49  5108  33
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
               128 28027  86 +++++ +++ 20161  49 29618  88 +++++ +++ 14780  43
monoid,6G,48751,90,77485,27,45263,25,55660,94,238757,49,5107.7,33,128,28027,86,+++++,+++,20161,49,29618,88,+++++,+++,14780,43

Test 4

            total       used       free     shared    buffers     cached
Mem:          3024        441       2582          0         48         25
-/+ buffers/cache:        367       2656
Swap:         1023        594        429

Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 44503  83 73894  29 42975  26 56463  95 237173  53  5053  36
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
              1024 18073  73 66151  81  5348  28 18102  65 60213  77  3441  23
monoid,6G,44503,83,73894,29,42975,26,56463,95,237173,53,5052.9,36,1024,18073,73,66151,81,5348,28,18102,65,60213,77,3441,23

            total       used       free     shared    buffers     cached
Mem:          3024        734       2289          0        329         42
-/+ buffers/cache:        362       2661
Swap:         1023        609        414

Re-adding sda2 and waiting for sync

mdadm: re-added /dev/sda2
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md2 : active raid1 sdb1[0] sda1[1](W)
     521984 blocks [2/2] [UU]
     bitmap: 0/64 pages [0KB], 4KB chunk, file: /mnt/ssd-junk/boot-bitmap

md3 : active raid10 sdc2[2] sdd2[1]
     488102656 blocks super 1.2 64K chunks 2 far-copies [2/2] [UU]
     bitmap: 1/466 pages [4KB], 512KB chunk, file: /mnt/ssd-junk/extra-bitmap

md1 : active raid1 sda2[1](W) sdb2[0]
     77352896 blocks [2/2] [UU]
     bitmap: 29/296 pages [116KB], 128KB chunk, file: /mnt/ssd-junk/root-bitmap

unused devices: <none>

Test 5

            total       used       free     shared    buffers     cached
Mem:          3024       1374       1649          0        357        621
-/+ buffers/cache:        396       2627
Swap:         1023        602        421

Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 48580  91 55567  24 40748  22 56803  95 237006  49  4828  29
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
              1024 20332  67 73175  80   783   4 13615  45 58066  74   489   3
monoid,6G,48580,91,55567,24,40748,22,56803,95,237006,49,4828.2,29,1024,20332,67,73175,80,783,4,13615,45,58066,74,489,3

mdadm: set /dev/sda2 faulty in /dev/md1
mdadm: hot remove failed for /dev/sda2: Device or resource busy

Test 6

            total       used       free     shared    buffers     cached
Mem:          3024        720       2303          0        335         40
-/+ buffers/cache:        345       2678
Swap:         1023        653        370

Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                   -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
monoid           6G 48966  92 77517  29 43999  24 56863  94 198557  38  3554  16
                   ------Sequential Create------ --------Random Create--------
                   -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
             files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
              1024 19273  68 72414  86  6326  31 16499  60 56438  75  2784  15
monoid,6G,48966,92,77517,29,43999,24,56863,94,198557,38,3553.8,16,1024,19273,68,72414,86,6326,31,16499,60,56438,75,2784,15

            total       used       free     shared    buffers     cached
Mem:          3024       2174        849          0        545       1261
-/+ buffers/cache:        366       2657
Swap:         1023        674        349

mdadm: Cannot open /dev/sda2: Device or resource busy
