From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: Raid 4 idea!
Date: Sun, 9 Apr 2006 00:40:37 +0200
Message-ID: <03ee01c65b5d$77dc4bd0$2c00a8c0@dcccs>
References: <005901c65ad7$ea45f6c0$2c00a8c0@dcccs> <443824A8.6070903@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

...

> > What do you think, Neil?

> I don't know what Neil thinks, but I have never liked the performance
implications of RAID-4, could you say a few words about why 4 rather  than
5? My one test with RAID-4 showed the parity drive as a huge bottleneck, and
seeing that practice followed theory, I gave up on it.

I think the performance is depend on the specific job.
In my case, the level 4 is better than level 5.
My system is a download server.
This job makes a lot of reads, and some write.
I use 4x12 unit raid4 array, and 1 raid0 array from 4 raid4.

Why?
let me see:
1. easy to start without the parity disk.
    1/a without the parity disk, it is more faster than raid5/4, and i can
easy and fast upload the server with data, and after the upload is done,
relatively quickly can generate the 4x1 parity information at one time!
    1/b if more disk fails, a little easyer to recover than raid5

2. I speaks more read and a little write.
On raid5 if somebody want to write only one bit to the array, all drive need
to read, and two disk is need to write after.
This requires too much time to force to wait the read processes.
But on raid4, all the drives need to read, and only one of the valuable
drives need to write! (+ the parity drive)
This is a little bit faster for me...

3. and this is the most important:
My system have 2 bottleneck with about 1000 downloader users at one time:
a, the drives seek time
b, the io bandwith.
I can make the balance between this 2 bottleneck with the readahead
settings.
On raid 5 the blockdev readahead _reads the parity too_, and waste the
bandwith, and the cache of the drive, the cache in memory, but can seeks N
drive.
On raid 4, the readahead is all valuable, but i can use only N-1 drive to
seeking.

4. on case of very high download traffic, and requires an upload too, i can
disable the party, and speed up the write process, and after the load is
fall back to normal, i can recreate the parity again.
This is a balance between the  performance, and redundancy.
This is a little dangerous, but this is my choise, and this way is, why
linux is so beautiful! :-)

5. with Neils patch i can use the bitmap too. ;-)

6. the parity drive becomes the bottleneck because it is offload the other
drives.
On other hand, if i plan to upgrade the system, i only need to buy faster
parity device! :-)

7/a on extreme case, i can move the parity out from the box, using NBD.
The nbd server can speed up and / or can store all the four parity drive
with more cost effective way.

7/b Optionally i can set up the NBD server again, and silenty (slowly)
reconstruct the parity again using the legacy raid 1, and i can use one USB
mobile rack to move the live parity from loop device to the new HDD in rack,
and i need to stop the system only for replace the bad disk to the new done
synced parity drive.
(I did not use hot-swap at the moment.)

> And in return I'll point out that this makes recovery very expensive, read
everything while reconstructing, then read everything all over again when
making a new parity drive after repair.

On my idea?
Yes, this is right.
But!
If one drive is failing, the parity disk convertion close equal time to
reconstruction, except, it goes more and more faster while the degraded
raid4 array gets closer to the clean raid0! (raid4 without parity)

And with one (exactly 4x1) failed drive my system can go on the top
performance, until i replace the old drive to new one.

The final parity recreation on raid4:
I can only point to the mdadm default raid5 creation mechanism, the "fantom"
spare drive!
Neil sad, this is faster than norma raid5 creation, and he have right!
With this option, only 1 disk is writing, and all other is only reading!

Cheers,
Janos





-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

