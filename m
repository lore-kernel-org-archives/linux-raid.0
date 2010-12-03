From: Phil Karn <karn@ka9q.net>
Subject: RAID-5 implementation questions
Date: Fri, 03 Dec 2010 00:49:52 -0800
Message-ID: <4CF8AF30.5070505@ka9q.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are there any papers documenting the implementation of the Linux RAID
subsystem? I'm interested in some of the details of how RAID-5 works.

I've never seen a virgin disk drive from the factory that wasn't all
0's. Creating a RAID array on a set of such drives triggers an initial
rebuild that simply writes lots zeroes on lots of zeroes. With disks now
pushing past 2 TB, this can easily take half a day.

Except for the admittedly somewhat useful side effect of scanning the
disks for bad sectors, all this activity seems rather unnecessary. Is
there a way to create a RAID-5 (or any other RAID level) array so that
it will immediately come up without an initial rebuild?

File systems generally don't read disk blocks that they haven't already
written. So even when you build a RAID array from drives with old data,
I can't see how skipping the initial rebuild can cause any real harm.
The first write to any block causes the RAID system to initialize the
parity in that stripe, thus making it possible to regenerate that block
in case of a drive failure.

During the initial rebuild of a RAID-5 array, /proc/mdstat suggests that
the array is operating in degraded mode and the last drive in the array
is being rebuilt. Is this true, i.e., are all the rebuild writes going
to that last drive?

How does a rebuilding RAID-5 array handle a read or write operation when
it lands on the "broken" drive? Does it depend on whether the block is
before or after the rebuild pointer?

Thanks much,

Phil
