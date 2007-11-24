From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: RAID5 rebuild with a bad source drive fails
Date: Sat, 24 Nov 2007 13:29:24 +0300
Message-ID: <1133422176.20071124132924@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid,

  I have a home fileserver which used a 6-disk RAID5 array
with old disks and cheap IDE controllers (all disks are 
IDE masters).

  As was expected, sooner or later the old hardware (and/or 
cabling) began failing. The array falls apart, in particular
currently it has 5 working disks and one marked as a spare 
(which was working before).

  The rebuild does not complete, because half-way through
one of the "working" disks has a set of bad blocks (about
30 of them). When the rebuild process (or the mount process)
hits these blocks, I get a non-running array with 4 working 
drives, one failed and one spare.

  While I can force-assemble the failing drive back into
the array, it's not useful - rebuild fails again and again.

  Question 1: is there a superblock-edit function, or maybe 
an equivalent manual procedure, which would let me mark the 
"spare" drive as a working part of the array?

  It [mostly] has all the data in correct stripes; at least 
the event counters are all the same, and it may be a better
working drive than the one with bad blocks.

  Even if I succeeded in editing all the superblocks to believe
that the "spare" disk is "okay" now, would it help in my data
recovery? :)

  Question 2: the disk's hardware apparetly fails to relocate
the bad blocks. Is it possible for the metadevice layer to 
do the same - remap and/or ignore the bad blocks? 

  In particular, is it possible for linux md to consider a
block of data as a "failed" quantum, not the whole partition
or disk, and try to use all 6 drives I have to deliver the
usable data (at least in some sort of recovery mode)?

-- 
Best regards,
 Jim Klimov                          mailto:klimov@2ka.mipt.ru

