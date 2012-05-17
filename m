From: Wiliam Colls <william.colls@rogers.com>
Subject: rebuilding Raid1 array
Date: Thu, 17 May 2012 14:15:08 -0400
Message-ID: <4FB5402C.10306@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


We recently had one of the disks in a 2 disk RAID1 array go down. We 
successfully removed the failed unit from the array, replaced the 
physical disk, and rebooted. Once back up and running the partition 
table from the working disk was copied to the new physical disk, and 
then the appropriate partition was added back into the array, and the 
array began to resync, and now appears to be running happily.

In reviewing the process afterwards, I realised that the partition was 
never formatted (ext3). Does the resync apply the format as part of the 
process? mdstat shows the expected results:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid1 sdc1[0] sdb1[1]
       244195904 blocks [2/2] [UU]

and there are no error messages in the system log.

Thanks for your time.

-- 
I know that you believe that you understand what you think I said, but I 
am not sure that you realise that what you heard was not what I meant.
