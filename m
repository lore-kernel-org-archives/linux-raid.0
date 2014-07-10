From: Wilson Jonathan <i400s@hotmail.com>
Subject: Partitioning on top of raid mirror device questions.
Date: Thu, 10 Jul 2014 12:24:37 +0100
Message-ID: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In my system I am running a few virtual systems, currently they reside
in raw files.

Initially I created a raid1 partition, with an ext4 file system on top
of the whole partition.

/dev/md/md85 from /dev/sda5 /dev/sdb5 mirror 120G

However I know from experience that raw files can be a bit slow (totally
different setup, raid6), so I wondered about the possibility of creating
3 individual partitions on top of the raid and if this would improve
performance.

Having read the man, it seems that partitions on top of raid are fine,
and no special options are required in the raid creation.

Now the questions.

Alignment... 

Now I understand that the base disk partitions require alignment based
on the drive... and I assume mdadm then creates its internal structure
so that it is also aligned, or does it? 

My wondering here is that I know mdadm has an area that holds data bout
the raid, then another area that holds the data... if the data area
(chunks? I may have the wrong term) was not aligned to the underlying
drives then would a write of "chunkX" potentially partially write to
disk area62 and disk area63 (for example) causing the underlying disk to
do a RMR.

If we assume that raid/base disk is all hunky dory alignment wise, this
then brings me on to partitions on top of the raid...

As raid when partitioned pretends to be a block disk device; when I used
gdisk to look at it without performing anything except a look at its
layout it reports its a normal disk, 512bytes, first usable sector 34,
partitions will be aligned on 2048 sector boundaries.

So my question is am I correct in thinking that "md85 partition 01" will
align to (an imaginary) 2048 boundary on "md85" which will align to the
real 2048 boundary on "sda5/sdb5"?

I may just stick with raw files but as I am in the process of upgrading
it piqued my interest and might be worth converting to partitions, or
possibly LVM which seems the preferred or most documented option (bit
I'm not sure I want to add a whole new set of skills and learning curve
at the moment). 

My intention is to add 2 more disks to the mirror raid, which while not
changing the write performance I believe will improve the read
performance... at least as far as I can tell, again is this assumption
correct?

Thanks in advance. 

Jon.

