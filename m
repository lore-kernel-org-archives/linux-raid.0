From: <robin-lists@robinbowes.com>
Subject: Sanity check installation scheme
Date: Thu, 15 Apr 2004 00:37:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S262063AbUDNXhL/20040414233712Z+1806@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm building a server from a few bits and pieces I have spare, including
several 4.3GB SCSI drives. I'll most likely be using Fedora since I'm
familiar with the Redhat flavour of linux.

To maximise disk space I'd like to use software RAID-5 across either 3 or 4
disks (depends how many I can squeeze into the case!). However, I am aware
that it is not possible to boot from a Software RAID-5 array. To overcome
this, I propose to create a small RAID-1 array across two drives to hold
/boot, plus swap partitions on one or two other drives. I may also consider
another RAID-1 array for /.

Here's what I envisage:

Partition | sda          | sdb          | sdc      | sdd      |
----------+--------------+--------------+----------+----------+
        1 | RAID-1       | RAID-1       | swap     | swap     |
          | (/boot, 80M) | (/boot, 80M) | (180M)   | (180M)   |
          +--------------+--------------+----------+----------+
        2 | RAID-1       | RAID-1       | RAID-5   | RAID-5   |
          | (/, 100M)    | (/, 100M)    | (~4G)    | (~4G)    |
          +--------------+--------------+----------+----------+
        3 | RAID-5       | RAID-5       |
          | (~4G)        | (~4G)        |
          +--------------+--------------+

This will give me the following partitions:

/     100MB, mirrored
/boot 80MB, mirrored
/usr, /var, et. All on ~12G RAID-5 array.

Does this look feasible? Can you see any major gotchas? Any better
suggestions?

Thanks,

R.

