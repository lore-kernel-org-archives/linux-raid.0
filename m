From: James Howells <james@howells.uk.net>
Subject: Missing Drives
Date: Wed, 21 Jul 2010 01:29:41 +0100
Message-ID: <201007210129.41566.james@howells.uk.net>
Reply-To: james@howells.uk.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone.

Fantastic job with the Linux mdadm tool but I've got a problem that I need 
some support with.

(Before you all ask, I've Googled this one to death, so please don't think of 
me as ignorant and blind).

Basically, I have a 5 disk RAID-5 array in an Addonics external enclosure. 
Each disk is 1TB in size. Since I am running it over USB, it's takes 3-3.5 
days to resync the disks if something goes pear-shaped.

Now, I don't think the software is at fault because I've had the drive 
replaced with a brand new disk and it's doing the exact same thing - 
drive /dev/sde loses it's partition data (the drive's superblock) and the md 
device's superblock. The data is unaffected since I only ever mount the 
device as read-only unless I need RW capability. I physically power the 
device down after unmounting the partition and stopping the array.

Whilst other people have had this problem of drives suddenly "losing 
everything", they have been able to recover, but I cannot keep my computer 
running for 3-3.5 days just to rebuild good data!

My question is:

Is it possible to copy the md superblock from one known good drive to another 
and assemble it as forced-clean?

It's easy enough to recreate the partition table with a simple:

dd if=/dev/sda of=/dev/sde count=1 bs=512

command but I believe the mdadm superblock lives at the end of the drive and 
if I could recreate that then I could at least recover from a failure of a 
known-good drive without needing a resync.

I'm looking into getting the RAID controller card (actually an eSATA 5-1 mini 
card) replaced or repaired but in the meantime, I am exploring all avenues.

This only happens on /dev/sde and not on any other device. Swapping hard 
drives around doesn't make any difference either - /dev/sde is perfectly 
readable. Clearly, though, I am not happy about building an array with a 
drive in that "cursed" slot since the loss of another drive in a RAID-5 would 
destroy everything stored on the array.

Any advice would be gratefully appreciated.

Regards,

James

PS. I'm running Debian Lenny 2.6.26-2-686 32-bit kernel with mdadm version 
2.6.7.2-3 (repackaged for Debian).
