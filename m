From: rfu@kaneda.iguw.tuwien.ac.at
Subject: migrating raid-1 to different drive geometry ?
Date: Mon, 24 Jan 2005 15:59:10 +0100
Message-ID: <20050124145910.GC29766@kaneda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm running Fedora Core 1 on a server with 2 identical
60 GB ATA drives. These drives are organized in a RAID1
with 4 partitions.

I now want to replace both drives with two different
(but also identical) ATA drives with about 80 to 120 GB
capacity each.

how can the existing raid setup be moved to the new disks 
without data loss ?

I guess it must be something like this:

1) physically remove first old drive
2) physically add first new drive
3) re-create partitions on new drive
4) run raidhotadd for each partition
5) wait until all partitions synced
6) repeat with second drive

the big question is: since the drive geometry will definitely different
between old 60GB and new 80GB drive(s), how do the new partitions 
have to be created on the new drive ?
- do they have to have exactly the same amount of blocks ?
- may they be bigger ?

are there better strategies for such a migration ?

tnx in advance.

rainer. 

