From: rob pfile <rpfile@gmail.com>
Subject: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Wed, 6 Apr 2011 18:45:15 -0700
Message-ID: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

any collective wisdom on what to do here? i've got a 4-disk raid5, and the most recent checkarray showed several bad blocks caused by uncorrectable read errors on two of the disks in the array. both disks in question show 0 reallocated sectors, but one looks like this:

197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       16
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       16

and the other like this:

197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       14
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       3
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       11

i'm a bit worried about failing one of these disks for fear that the other might give uncorrectable read errors during the rebuild. if i *had* to choose one, should i choose the one with all the pending sectors, or the one with all the uncorrectable sectors?

does it makes sense to do a smartctl -t offline scan on one or both of these disks first?

i guess i could take the array offline, clone one of the disks with dd, and then swap the clone in. but... is there a way to clone one disk in the array using mdadm? in other words, is there a way to construct a clean copy of one of the disks even if there are raid-correctable read errors?

i do have backups, so perhaps it will not kill me if the array dies, but i'd like to tread carefully and try and get out of this mess without nuking everything.

thanks for any advice,

rob














