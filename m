From: Brad Campbell <brad@wasp.net.au>
Subject: Raid-6 stability gets my vote
Date: Sat, 16 Jul 2005 00:44:38 +0400
Message-ID: <42D82036.3060602@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

This message is really just for future googles.
I have been running a 15 disk raid-6 since 24th feb in production and can completely vouch for it's 
stability. I have had both simulated and real drive failures and it has handled itself perfectly 
under all cases. Unclean shutdowns and resyncs have all been perfect.
I know it's tagged as stable in any case, but I still get E-mails from people dragging my name from 
google asking about it, so I place this here for the public record.

storage1:/home/brad# mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Thu Feb 24 14:51:17 2005
      Raid Level : raid6
      Array Size : 3186525056 (3038.91 GiB 3263.00 GB)
     Device Size : 245117312 (233.76 GiB 251.00 GB)
    Raid Devices : 15
   Total Devices : 15
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Jul 15 13:27:51 2005
           State : clean
  Active Devices : 15
Working Devices : 15
  Failed Devices : 0
   Spare Devices : 0

Many thanks to hpa and others responsible for raid-6. I have already had a 2 drive failure and they 
were so close together even a hot spare would not have had time to rebuild.

Also thanks to Neil Brown for a great monitoring and management tool. Mdadm and it's monitoring to 
E-mail has been invaluable.

I'd also like to thank Maxtor for producing drives that actually have useful S.M.A.R.T. data. Wish 
the other manuf's would follow suit.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
