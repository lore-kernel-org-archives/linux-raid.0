From: seth vidal <skvidal@phy.duke.edu>
Subject: disk failure and badblocks
Date: Sat, 22 Nov 2003 03:22:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069489341.4351.5.camel@binkley>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 I had a disk fail out of sw-raid5 array with a medium error. I'd like
to check the disk for bad blocks, and if it shows up with some, call me
vendor and get them to replace the disk. In the past I've shut the
machine down and run the scsi bios media check. Would it be possible for
me to remove this disk from the array and run badblocks on it to get the
same information? If I could not shut down the system I would prefer to.
My major wonder is will badblocks be effective for looking for a medium
error?

Thanks,

-sv



