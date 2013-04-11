From: Mihail Daskalov <mdaskalov@technologica.com>
Subject: Is (non-failed) disk replace possible without loosing redundancy ?
Date: Thu, 11 Apr 2013 15:07:57 +0000
Message-ID: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,
I am newbie to this list, so forgive me if this was already discussed, and answered. I have searched the archives, but could not find an answer to my question (except something called hot-replace, that I couldn't understand much about).

I would like to replace a disk in a mirror (raid1 array) with a third disk, that is present in the system (it is actually added as a spare to the array).
This is part of some storage reorganization and drive replacement process (change old disks with new ones).
Is there a way to gracefully replace a non-failed drive in an array, without loosing redundancy. 
I think I would like to achieve the following:
1.	Add a third disk to a mirror array
2.	Ask the md subsystem to create triple mirror, and sync information to the third disk.
3.	Remove one of the other 2 disks on the system
4.	The system will stay with 2 up-to-date mirrors of the blocks

This could be called a 'Copy-and-replace' operation. It could have some optimization - for example - maintain only 2 copies of the information (for example blocks that were not yet copied to the third disk will be on disks {1,2}, and blocks that are already copied would be on {1,3} in the case when disk 2 is being replaced by disk 3).

So my questions is how can I achieve this, or similar functionality, and in what version of the kernel and tools, if at all possible?

I specifically would like to underline that I know I can do:
1. Add third disk as spare
2. fail disk 2
3. wait for the resync to finish

I would like to avoid this, as while resync-ing I would only have one copy of the blocks.

Thanks in advance,
Mihail Daskalov
