From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: Verifying spare drive, best practices
Date: Fri, 21 Mar 2008 12:13:57 -0300
Message-ID: <18403.53429.355889.906445@fisica.ufpr.br>
References: <47E33AF8.6020106@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E33AF8.6020106@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius (maurice@harddata.com) wrote on 20 March 2008 22:35:
 >Given this situation:
 >7 disks in total
 >RAID5 of 6 disks, and a hot spare.
 >
 >mdadm show the 6 disks, but not the spare.
 >
 >As a maintenance question, where one wants to periodically ensure that 
 >the hot spare is both available and good.
 >How should one best :
 >1) Verify the hot spare is still available.
 >2) Verify that the hot spare is healthy?

I usually do a dd if=/dev/zero of=/dev/spare to write to all sectors
and give the drive a chance to remap bad blocks. Then run smartctl
with a long test, and smartctl -a to see the results.

If there are partitions I use sfdisk -d /dev/disk-in-array |sfdisk -f
/dev/spare to copy the partition table from one of the other disks to
the spare, or any other (non-manual...) method to restore the partitioning.

This can be easily included in the routine array checks.
