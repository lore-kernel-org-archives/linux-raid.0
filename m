From: Brad Campbell <brad@wasp.net.au>
Subject: Swapping out for larger disks
Date: Tue, 08 May 2007 14:50:29 +0400
Message-ID: <464055F5.2090108@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I've got 3 arrays here. A 3 drive raid-5, a 10 drive raid-5 and a 15 drive raid-6. They are all 
currently 250GB SATA drives.

I'm contemplating an upgrade to 500GB drives on one or more of the arrays and wondering the best way 
to do the physical swap.

The slow and steady way would be to degrade the array, remove a disk, add the new disk, lather, 
rinse, repeat. After which I could use mdadm --grow. There is the concern of a degraded array here 
though (and one of the reasons I'm looking to swap is some of the disks have about 30,000 hours on 
the clock and are growing the odd defect).

I was more wondering about the feasibility of using dd to copy the drive contents to the larger 
drives (then I could do 5 at a time) and working it from there.

It occurs though that the superblocks would be in the wrong place for the new drives and I'm 
wondering if the kernel or mdadm might not find them.

Ideas? Suggestions ?

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
