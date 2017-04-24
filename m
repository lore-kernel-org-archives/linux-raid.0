From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 13:04:55 +0200
Message-ID: <20170424110455.GA4949@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 24, 2017 at 09:34:04AM +0200, Patrik Dahlström wrote:
> I've let a program compare both raid sets (5 and 6 disk) overnight. So
> far it has gone from 128 MB to 14 TB without finding common data. Does
> that tell us anything?

Are both RAID sets created correctly?

On the 6 disk one, `file -s /dev/mdX` should say ext filesystem.

If that's not there it's certainly incorrect. (The reverse isn't true though.)

I experiment a little:

# truncate -s 100M a b c d e f
# for f in ?; do losetup --find --show "$f"; done
# mdadm --create /dev/md42 --level=5 --raid-devices=5 /dev/loop{0,1,2,3,4}
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md42 started.
# i=0; while printf "%015x\n" $i; do let i+=16; done > /dev/md42
# hexdump -C -n 64 -s 808080 /dev/md42
000c5490  30 30 30 30 30 30 30 30  30 30 63 35 34 39 30 0a  |0000000000c5490.|
000c54a0  30 30 30 30 30 30 30 30  30 30 63 35 34 61 30 0a  |0000000000c54a0.|
000c54b0  30 30 30 30 30 30 30 30  30 30 63 35 34 62 30 0a  |0000000000c54b0.|
000c54c0  30 30 30 30 30 30 30 30  30 30 63 35 34 63 30 0a  |0000000000c54c0.|
000c54d0

So in this sample array the data itself represents the offset it should be at.
This is just so we can verify later.

Now grow.

# echo 1 > /sys/block/md42/md/sync_speed_min
# echo 256 > /sys/block/md42/md/sync_speed_max
# mdadm --grow /dev/md42 --raid-devices=6 --add /dev/loop5
mdadm: added /dev/loop5
mdadm: Need to backup 10240K of critical section..
# watch grep -A3 md42 /proc/mdstat
... wait for it to reach around 50% or whatever ...
# mdadm --stop /dev/md42
mdadm: stopped /dev/md42
# mdadm --examine /dev/loop1
[...]
  Reshape pos'n : 296960 (290.00 MiB 304.09 MB)
  Delta Devices : 1 (5->6)
[...]

Now create two RAID sets:

# losetup -D
# for f in ? ; do cp "$f" "$f".a ; done;
# for f in ? ; do cp "$f" "$f".b ; done;
# for a in *.a ; do losetup --find --show "$a" ; done
# for b in *.b ; do losetup --find --show "$b" ; done
# mdadm --create /dev/md42 --assume-clean --level=5 --raid-devices=5 /dev/loop{0,1,2,3,4}
# mdadm --create /dev/md42 --assume-clean --level=5 --raid-devices=6 /dev/loop{5,6,7,8,9,10}

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md42 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      405504 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      
md43 : active raid5 loop10[5] loop9[4] loop8[3] loop7[2] loop6[1] loop5[0]
      506880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]

And compare:

# hexdump -C -n 64 /dev/md42
00000000  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 0a  |000000000000000.|
00000010  30 30 30 30 30 30 30 30  30 30 30 30 30 31 30 0a  |000000000000010.|
00000020  30 30 30 30 30 30 30 30  30 30 30 30 30 32 30 0a  |000000000000020.|
00000030  30 30 30 30 30 30 30 30  30 30 30 30 30 33 30 0a  |000000000000030.|
00000040
# hexdump -C -n 64 /dev/md43
00000000  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 0a  |000000000000000.|
00000010  30 30 30 30 30 30 30 30  30 30 30 30 30 31 30 0a  |000000000000010.|
00000020  30 30 30 30 30 30 30 30  30 30 30 30 30 32 30 0a  |000000000000020.|
00000030  30 30 30 30 30 30 30 30  30 30 30 30 30 33 30 0a  |000000000000030.|
00000040

This is identical because in this example, the offset didn't change.

# hexdump -C -n 64 -s 80808080 /dev/md42
04d10890  30 30 30 30 30 30 30 30  35 66 31 30 38 39 30 0a  |000000005f10890.|
04d108a0  30 30 30 30 30 30 30 30  35 66 31 30 38 61 30 0a  |000000005f108a0.|
04d108b0  30 30 30 30 30 30 30 30  35 66 31 30 38 62 30 0a  |000000005f108b0.|
04d108c0  30 30 30 30 30 30 30 30  35 66 31 30 38 63 30 0a  |000000005f108c0.|
04d108d0
# hexdump -C -n 64 -s 80808080 /dev/md43
04d10890  30 30 30 30 30 30 30 30  34 64 31 30 38 39 30 0a  |000000004d10890.|
04d108a0  30 30 30 30 30 30 30 30  34 64 31 30 38 61 30 0a  |000000004d108a0.|
04d108b0  30 30 30 30 30 30 30 30  34 64 31 30 38 62 30 0a  |000000004d108b0.|
04d108c0  30 30 30 30 30 30 30 30  34 64 31 30 38 63 30 0a  |000000004d108c0.|
04d108d0

For this offset, md42 was wrong, md43 is correct.

# hexdump -C -n 64 -s 300808080 /dev/md42
11edf790  30 30 30 30 30 30 30 31  31 65 64 66 37 39 30 0a  |000000011edf790.|
11edf7a0  30 30 30 30 30 30 30 31  31 65 64 66 37 61 30 0a  |000000011edf7a0.|
11edf7b0  30 30 30 30 30 30 30 31  31 65 64 66 37 62 30 0a  |000000011edf7b0.|
11edf7c0  30 30 30 30 30 30 30 31  31 65 64 66 37 63 30 0a  |000000011edf7c0.|
11edf7d0
# hexdump -C -n 64 -s 300808080 /dev/md43
11edf790  30 30 30 30 30 30 30 31  31 65 64 66 37 39 30 0a  |000000011edf790.|
11edf7a0  30 30 30 30 30 30 30 31  31 65 64 66 37 61 30 0a  |000000011edf7a0.|
11edf7b0  30 30 30 30 30 30 30 31  31 65 64 66 37 62 30 0a  |000000011edf7b0.|
11edf7c0  30 30 30 30 30 30 30 31  31 65 64 66 37 63 30 0a  |000000011edf7c0.|
11edf7d0

For this offset, md42 and md43 overlapped. Grow progressed that far yet 
without writing into the original data of the 5disk raid5. This could be 
a suitable merge point for a linear device mapping.

# hexdump -C -n 64 -s 400008080 /dev/md42
17d7a390  30 30 30 30 30 30 30 31  37 64 37 61 33 39 30 0a  |000000017d7a390.|
17d7a3a0  30 30 30 30 30 30 30 31  37 64 37 61 33 61 30 0a  |000000017d7a3a0.|
17d7a3b0  30 30 30 30 30 30 30 31  37 64 37 61 33 62 30 0a  |000000017d7a3b0.|
17d7a3c0  30 30 30 30 30 30 30 31  37 64 37 61 33 63 30 0a  |000000017d7a3c0.|
17d7a3d0
# hexdump -C -n 64 -s 400008080 /dev/md43
17d7a390  30 30 30 30 30 30 30 31  33 31 37 61 33 39 30 0a  |00000001317a390.|
17d7a3a0  30 30 30 30 30 30 30 31  33 31 37 61 33 61 30 0a  |00000001317a3a0.|
17d7a3b0  30 30 30 30 30 30 30 31  33 31 37 61 33 62 30 0a  |00000001317a3b0.|
17d7a3c0  30 30 30 30 30 30 30 31  33 31 37 61 33 63 30 0a  |00000001317a3c0.|
17d7a3d0

For this offset, md42 is correct and md43 is wrong.
Grow did not progress that far.

That's the general outline of the idea. 
The problem in your case is of course, your data is not that easy to verify.

( You can't even easily verify your disk order, offsets, et cetera.
  These are things you have to figure out by yourself,
  not sure how else to help you. Best of luck. )

Regards
Andreas Klauer
