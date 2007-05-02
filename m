From: Slawek <slawekn1@open-e.com>
Subject: attempt to access beyond end of device on RAID0 with mdadm
Date: Wed, 02 May 2007 16:28:56 +0200
Message-ID: <4638A028.1010706@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am using Debian 3.1 (sarge) with 2.6.17.13-gen64-smp kernel.
I have storage of 53 TB (6 units with 9.5 T). All of them are stripped
(Raid0) using mdadm 1.9.0. On this unit  have created with LVM2 Volume
Group and 3 logical Volumes. One for SWAP (4GB), one for some system
files encrypted with dm-crypt and with 1GB size. The rest of free space
is used for Logical Volume for data.

Yesterday I saw in dmesg that:


attempt to access beyond end of device
dm-6: rw=1, want=10468036824, limit=2097152
attempt to access beyond end of device
dm-6: rw=1, want=1381842776, limit=2097152
attempt to access beyond end of device
dm-6: rw=1, want=2907847344, limit=2097152
attempt to access beyond end of device
dm-6: rw=1, want=822338824, limit=2097152
Buffer I/O error on device dm-6, logical block 102792352
lost page write due to I/O error on dm-6
Aborting journal on device dm-6.
ext3_abort called.
EXT3-fs error (device dm-6): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only

dm-6 is my system partition

I have checked the disks and RAIDs , everything was OK.
I suspect that this is related to mdadm and some of its variables which
has been probably overflowed.
Have you met with something like this before? Do you have a solution?

I am very happy using mdadm and a bit afraid about my data. There is
around 7TB of data.

Best Regards
Bruce
