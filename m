From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Upgrading Raid1 array to have 2. disks.
Date: Wed, 07 May 2003 01:24:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB8441F.8070606@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry if this is the wrong list to post this on.

I have made an error when creating a new raid1 array as I specified that
the raid should consist of only one disk. Now, I would like to add 
another disk, but mdadm insists on adding it as a spare disk, offering 
no data redundancy.

Before:
md0 : active raid1 ide/host0/bus0/target0/lun0/part1[0]
       1048704 blocks [1/1] [U]

After running
# mdadm -add /dev/md/0
     /dev/ide/host0/bus0/target0/lun0/part1[0]

md0 : active raid1 ide/host0/bus1/target0/lun0/part1[1] 
ide/host0/bus0/target0/lun0/part1[0]
       1048704 blocks [1/1] [U]


I have read the manpages, and tried googling without success.
I do not wish to destroy the data on the discs, and recreate the array 
but It might be a last resort. Can anyone help me convince mdadm to add 
the 2. partition as an active disk.

Regards
Anders Fugmann

P.s.
Please CC me, as I'm not subscribed to the list.


