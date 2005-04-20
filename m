From: Robbie Hughes <spam@dynsysgroup.com>
Subject: remove resyncing disk
Date: Wed, 20 Apr 2005 17:52:58 +0100
Message-ID: <426688EA.80802@dynsysgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can anyone help?
I am having problems with a raid1 setup i built ages ago.
The machine got taken to a datacentre recently and I thought the other 
day to check things over on it.
I then discovered that only one of the 2 drives was actually part of the 
/dev/md0 filesystem, i then added the other drive and resyncing began.
the output is as below:


#mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Jun 10 09:52:47 2004
     Raid Level : raid1
     Array Size : 39843648 (37.100 GiB 40.80 GB)
    Device Size : 39843648 (37.100 GiB 40.80 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Apr 20 17:37:10 2005
          State : clean, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


 Rebuild Status : 6% complete

    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1      22       66        1      active sync   /dev/hdd2
       2       3        3        0      spare   /dev/hda3
           UUID : 533f5ae9:cdd1c37a:57475cdd:bce0f006
         Events : 0.7535478


The main problem i have now is that this output is a day and a half 
hence. It has been continually resyncing since I added the drive and 
when it gets to 100%, it starts over.

I thought this was odd so i checked dmesg to find 8 messages like this:

hdd: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdd: dma_intr: error=0x40 { UncorrectableError }, LBAsect=76658506, 
sector=76658504
end_request: I/O error, dev hdd, sector 76658504

finishing in a
raid1: hdd: unrecoverable I/O read error for block 76052608
md: md0: sync done.
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 39843648 blocks.

so i ran badblocks and discovered 8 bad blocks right at the tail end of 
my /dev/hdd2 drive that is the no (1) drive in the array, not the spare.

So far as I can tell, I am now stuffed.
I guess i need to do one of 3 things:

1) Stop the mad resyncing process before the system overheats (will this 
happen??)
2) fix the bad blocks and do a good resync before swapping out the 
failed drive
3) copy what i can off the server (i have no data on the failed blocks 
or anywhere near them) and replace the drive having rebuilt the server.

If anyone can offer me any advice on how to do this, I would be most 
grateful. The datacentre is over 100 miles away so I really don't want 
to go there until my next scheduled trip (in a couple of weeks) If i can 
set the other HD up and get both running together properly I would be v 
happy, even just stopping the resyncing would be a bonus. I am just 
afraid of running mdadm -r /dev/md0 /dev/hda3 in the middle of a resync. 
Will this do anything bad?

All advice much appreciated....
robbie
