From: Sam Hurst <sam@sam-hurst.co.uk>
Subject: Re: RAID wiped superblock recovery
Date: Sun, 17 May 2020 15:01:51 +0100
Message-ID: <aa4b9947-39cd-6c30-79f0-138d307c9620@sam-hurst.co.uk>
References: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
 <0f954924-e7ae-c81e-55f1-afc41e293a18@turmel.org>
 <05011140-3625-5326-96c9-e995f93260f4@sam-hurst.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05011140-3625-5326-96c9-e995f93260f4@sam-hurst.co.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/05/2020 14:55, Sam Hurst wrote:
> So I've now tried doing this and sadly haven't really gotten anywhere. 
> Given the output of mdadm -E, I've specified the chunk size as 512K, and 
> the data offset as 134MB (given the reported offset of 262144 sectors * 
> sector size of 512 bytes on the devices).
> 
> Given your statement that I could trust the existing superblocks, I 
> haven't messed around with the order of those and instead I've just been 
> messing around with the order of the three disks which are unhappy. So 
> I've been putting sda first (active 0), then sdc (active 1), sdb (active 
> 2), and sdd (active 3). As I said last time, I'm using overlay images to 
> avoid screwing up the disks. My create command line is as below:
> 
> mdadm --create /dev/md1 --chunk=512 --level=6 --assume-clean 
> --data-offset=134M --raid-devices=7 /dev/mapper/sda /dev/mapper/sdc 
> /dev/mapper/sdb /dev/mapper/sdd ${UNHAPPY_DISK1} ${UNHAPPY_DISK2} 
> ${UNHAPPY_DISK3}

One other thing which I meant to write on the previous email but forgot, 
my test of "is the array sane" is to try and mount the XFS filesystem on 
the array. However, each time it just fails to find the filesystem 
superblock and is generally unhappy.

Reading the manpage, the only other thing I can see which I could put 
into the --create command is the layout of the array, which I'm fairly 
sure was left-symmetric because that's what the original RAID 5 array 
was according to my backup of the RAID configuration before moving to 
RAID 6, but I can't remember what the second parity disk layout was.

And in case it is helpful, the following is what mdadm thinks about the 
new array that I try to build.

root@toothless:~# mdadm -D /dev/md1
/dev/md1:
            Version : 1.2
      Creation Time : Sun May 17 14:38:34 2020
         Raid Level : raid6
         Array Size : 14650644480 (13971.94 GiB 15002.26 GB)
      Used Dev Size : 2930128896 (2794.39 GiB 3000.45 GB)
       Raid Devices : 7
      Total Devices : 7
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Sun May 17 14:38:34 2020
              State : clean
     Active Devices : 7
    Working Devices : 7
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : toothless.local:1  (local to host toothless.local)
               UUID : ddf9f835:dc0fdad0:c864d5f5:f70ecbbf
             Events : 1

     Number   Major   Minor   RaidDevice State
        0     253        2        0      active sync   /dev/dm-2
        1     253        3        1      active sync   /dev/dm-3
        2     253        0        2      active sync   /dev/dm-0
        3     253        1        3      active sync   /dev/dm-1
        4     253        4        4      active sync   /dev/dm-4
        5     253        6        5      active sync   /dev/dm-6
        6     253        5        6      active sync   /dev/dm-5

-Sam
