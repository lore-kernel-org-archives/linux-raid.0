From: Reindl Harald <h.reindl@thelounge.net>
Subject: RAID10 and 'writemostly' support
Date: Thu, 16 Feb 2017 15:08:32 +0100
Message-ID: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

i am new and was redirected to this list from the bugtracker
please have a look at https://bugzilla.kernel.org/show_bug.cgi?id=194551

currently "writemostly" seems to be only supported on "real" RAID1 while 
i was in hope that by the conecpt of RAID10 having more or less 
RAID0+RAID1 it would also work on RAID10 (and on the virtual machine wre 
i tested mdadm with the flag before buying the disks it did not complain)

RAID10 with "writemostly" makes a lot of sense for large storages to get 
them fast *and* reliable without make it extremly expensive

* you don't want RAID5/RAID6 rebuild over many TB
* very large SSD for RAID1 are much more expensive than smaller ones

so with 4x2 TB disks you get 4 TB useable storage and with "writemostly" 
which would be in the best case "writeonly" you have a lightening fast 
RAID0 on SSD with good redundancy

most workloads are read-intense with less writes (rsync with --checksum 
enabled, booting, starting large applications...)

another benefit: different technologies - it's very unlikely that both 
disks of a stripe fail at the same time or due rebuild when one half is 
a SSD and the other a HDD
