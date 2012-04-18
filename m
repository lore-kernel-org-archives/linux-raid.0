From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Disk link failure impact on Disks and RAID superblock in MD.
Date: Wed, 18 Apr 2012 12:52:58 +0100
Message-ID: <4F8EAB1A.6000800@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was wondering about the following:

Superblocks, and all RAID metadata, are stored on disks (to assemble the 
RAID), and also on the RAID (while assembled), and are necessary to run 
a RAID correctly, so long as at least <parity reached> of superblocks on 
disks are available, as <parity reached> number of disks are required 
for a specific RAID level to run (this excludes RAID 0 obviously).

This means that so long as less than 1 disk fails in RAID5, no more than 
one superblock will be lost and therefore the RAID can still assemble, 
and the metadata be read.

However, in modern RAID systems, the disks are all connected through a 
single path, being a SAS cable connected to a JBOD or a single SATA 
controller that can fail/crash.

Also, the RAID is not protected against power failure, which in my head 
are a bit equivalent to a complete disk link failure (SAS cable pulled).

In these cases where all the disks are lost at once, what is the 
probability of superblock corruption (both on the RAID superblock and 
the individual disks)?

If the superblock was being written during the failure, would it be 
incompletely written and therefore corrupted?

How reliably is it to keep a RAID alive (being able to re-assemble it) 
after continuously pulling and pushing the SAS cable?

Regards,
Ben.
