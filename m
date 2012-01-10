From: Bobby Kent <bpkent@wholeworldwindow.net>
Subject: Meaning of "Used Dev Space" in "mdadm --detail" output for a 6 disk
 RAID10 array
Date: Mon, 09 Jan 2012 21:20:39 -0500
Message-ID: <007601cccf3e$72191470$564b3d50$@wholeworldwindow.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm sure the question has come up before, so my apologies for raising it again.  Google has not been my friend in my researches over the past week or so other than leading to my discovery of this list, which has made for some interesting reading over the past couple of days.  

Is there any documentation that details how the output of "mdadm --detail" should be interpreted?  The following, longish, email provides some background for my reasons to ask this question, which in all honesty is probably driven by fear as much as anything (the fear being, did I make a fundamental error when initially configuring my arrays, and if so, how can I rectify matters with the least amount of pain).

I have 6 x 2 TB hdds (/dev/sd[a-f]) each of which is partitioned as follows:

# fdisk -l /dev/sda

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x526b747f

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63   209728574   104864256   fd  Linux raid autodetect
/dev/sda2       209728575   419457149   104864287+  fd  Linux raid autodetect
/dev/sda3       419457150   629185724   104864287+  fd  Linux raid autodetect
/dev/sda4       629185725  3907024064  1638919170   fd  Linux raid autodetect

When I created MD raid devices back in March 2010 with mdadm 3.0 I executed the following:

for i in $(seq 1 4) ; do 
  mknod /dev/md${i} b 9 ${i} 
done

for i in $(seq 1 4) ; do 
  mdadm --create /dev/md${i} --level=10 --raid-devices=6 \
  /dev/sda${i} /dev/sdb${i} /dev/sdc${i} /dev/sdd${i} /dev/sde${i} /dev/sdf${i} 
done

All seemed well with the set up and it has been operating pretty much trouble free for the past couple of years.  This past week I've had multiple hangs; I'm not certain of the root cause, the first hang happened shortly after I upgraded from Gentoo Linux 3.0.6 to 3.1.6, and since then I've reverted to 3.0.6 as a precautionary measure.  The hangs continued after the kernel downgrade and upon looking at syslog I noticed that a couple of my raid devices never completed their resyncs, which lead me to look at the output of mdadm.

# mdadm --detail /dev/md127
/dev/md127:
        Version : 0.90
  Creation Time : Wed Apr 21 10:42:30 2010
     Raid Level : raid10
     Array Size : 4916757312 (4688.99 GiB 5034.76 GB)
  Used Dev Size : 1638919104 (1563.00 GiB 1678.25 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 127
    Persistence : Superblock is persistent


    Update Time : Fri Jan  6 16:29:14 2012
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           UUID : d80cefe2:9de8e12a:cb201669:f728008a
         Events : 0.2583784

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       8       52        3      active sync   /dev/sdd4
       4       8       68        4      active sync   /dev/sde4
       5       8       84        5      active sync   /dev/sdf4

In the linux-raid email history I saw some comments about use of metadata 0.90 in conjunction with HDDs > than 2 TBs and while this didn't seem to apply, as I had a couple of md arrays not in active use, I figured there was little harm in updating them to 1.0:

# mdadm --detail /dev/md125
/dev/md125:
        Version : 1.0
  Creation Time : Sun Jan  8 14:55:40 2012
     Raid Level : raid10
     Array Size : 314592576 (300.02 GiB 322.14 GB)
  Used Dev Size : 104864192 (100.01 GiB 107.38 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Mon Jan  9 09:48:12 2012
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           Name : bobby4:125  (local to host bobby4)
           UUID : 093825ec:924344ef:b87c73f3:212723fa
         Events : 2

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
       5       8       82        5      active sync   /dev/sdf2

The metadata update was a fairly trivial exercise, once I realized that I needed to specify the chunk size (as already noted the arrays were originally established with mdadm 3.0 and since then I've upgraded to 3.1.4):

mdadm --create /dev/md125 -c 64 --metadata 1.0 --level=10 --assume-clean --raid-devices=6 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2 /dev/sdf2

and I am not averse to performing the equivalent for the two arrays that remain at 0.90, though as one of them supports /var and /usr (and a couple of other filesystems, via the use of LVM) I expect I will have to boot with a LiveCD or similar.  

Is this a worthwhile and recommended activity?  If so, why?  Should I specify the size of the array in addition to the chunk size (and, if so, what should I use as my guide?)?  I am in the process of performing a full back up of the arrays that have not had metadata updates, though the positive experience with the two I've already completed gives me confidence that I'll likely not need to restore (still better to have a backup and not need it than vice versa :-) ).

The mdadm --detail output takes me back to my opening question.  In either case Used Dev Space is approx. 1/3rd of the Array Size, and Array Size appears to be the user available capacity.  Is Used Dev Space a measure of the capacity on each member device used by the array?  This appears to match the value reported, though as mentioned, I couldn't find anything to support such a conclusion, indeed the first Google hit for my query:

http://www.linuxquestions.org/questions/red-hat-31/what-does-used-dev-size-mean-mdadm-detail-767177/

does not refer to raid10 at all and appears to imply that something is amiss; in RAID10, isn't the RAID overhead the same as RAID1?  That is, 50% of the total HDD capacity is used to mirror the other 50%, so as a user I only have access to 50% of the total HDD capacity (at least broadly speaking, there are minor losses for various overheads like the metadata)?  That was certainly my expectation, and given the recent exchange on the comparative merits of RAID6 vs RAID10, am glad I opted for RAID10, albeit my primary reason for the choice was performance related.

Thanks,

Bobby



