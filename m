From: Sam Hurst <sam@sam-hurst.co.uk>
Subject: Re: RAID wiped superblock recovery
Date: Sun, 17 May 2020 14:55:18 +0100
Message-ID: <05011140-3625-5326-96c9-e995f93260f4@sam-hurst.co.uk>
References: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
 <0f954924-e7ae-c81e-55f1-afc41e293a18@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0f954924-e7ae-c81e-55f1-afc41e293a18@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

On 11/05/2020 15:18, Phil Turmel wrote:
>> So I've come to the conclusion that the only way forward is to use 
>> `mdadm --create` and hope I get the array back that way, with new 
>> superblocks.
> 
> Yes.  Be sure to always include --assume-clean in these trials.
> 
>> However, it's my understanding that you need to add these disks in the 
>> correct order - and given I have 7 disks, that's 5040 possible 
>> permutations! The original four disks show their device roles, so I'm 
>> /assuming/ that's the order in which they need adding:
> 
> Yes, existing superblocks can be trusted.  You should show the complete 
> "mdadm -E" output for each of these member devices for our reference.

My complete mdadm -E output:

sosh@toothless:/$ sudo mdadm -E /dev/sda /dev/sdb /dev/sdc /dev/sdd 
/dev/sdf /dev/sdg /dev/sdh
/dev/sda:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=944 sectors
           State : clean
     Device UUID : 08c24be4:d352cbb0:edd50ba7:3a70e02e

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat May  2 09:49:27 2020
   Bad Block Log : 512 entries available at offset 24 sectors
        Checksum : b1df527c - correct
          Events : 2687251

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : 80d493f1:9649882b:bdcdeceb:cb61f937

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat May  2 09:49:27 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 87de4546 - correct
          Events : 2687251

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : 078aa94c:de9ad5e8:dcb5b43c:bf12292f

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat May  2 09:49:27 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : e838e526 - correct
          Events : 2687251

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : 47eb651d:9d5eb96b:3b8e9d78:882f5f49

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat May  2 09:49:27 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 91f7ff4f - correct
          Events : 2687251

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=944 sectors
           State : clean
     Device UUID : 00000000:00000000:00000000:00000000

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat May  2 09:49:27 2020
   Bad Block Log : 512 entries available at offset 24 sectors
        Checksum : b1df527c - expected 46dbf779
          Events : 2687251

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : ....... ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=944 sectors
           State : active
     Device UUID : 00000000:00000000:00000000:00000000

     Update Time : Thu Jan  1 01:00:00 1970
        Checksum : 0 - expected e7edc1ab
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : ....... ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f3667bf3:e2b718c2:22cbea68:428ea6ca
            Name : toothless:WDRAID
   Creation Time : Sat Oct 22 10:52:47 2016
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650675200 (13971.97 GiB 15002.29 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=944 sectors
           State : active
     Device UUID : 00000000:00000000:00000000:00000000

     Update Time : Thu Jan  1 01:00:00 1970
        Checksum : 0 - expected e7edc1ab
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : ....... ('A' == active, '.' == missing, 'R' == replacing)

>> So I've tried all six permutations of the devices showing as "spare" 
>> at the end and I can never get a sensible filesystem out when I do a 
>> --create.
>>
>> Does anyone have any other ideas, or can offer some wisdom into what 
>> to do next? Otherwise I'm writing a shell script to test all 5040 
>> permutations...
> 
> It isn't just order that matters.   You must get the right data offset 
> and chunk size.  Defaults have changed over the years, and offsets 
> typically change (+/- 1 chunk) during reshapes.
> 
> You'll probably have to manually specify this stuff.  Be sure to use the 
> latest released version of mdadm, even if you have to compile it yourself.
> 
> If your data offsets are at least a couple megabytes, consider 
> partitioning these disks at the same time as you reconstruct--simply 
> adjust the data offset for the start sector of the partition.  This will 
> avoid future issues with stupid mobos.  (You aren't the first to suffer 
> from this.)

So I've now tried doing this and sadly haven't really gotten anywhere. 
Given the output of mdadm -E, I've specified the chunk size as 512K, and 
the data offset as 134MB (given the reported offset of 262144 sectors * 
sector size of 512 bytes on the devices).

Given your statement that I could trust the existing superblocks, I 
haven't messed around with the order of those and instead I've just been 
messing around with the order of the three disks which are unhappy. So 
I've been putting sda first (active 0), then sdc (active 1), sdb (active 
2), and sdd (active 3). As I said last time, I'm using overlay images to 
avoid screwing up the disks. My create command line is as below:

mdadm --create /dev/md1 --chunk=512 --level=6 --assume-clean 
--data-offset=134M --raid-devices=7 /dev/mapper/sda /dev/mapper/sdc 
/dev/mapper/sdb /dev/mapper/sdd ${UNHAPPY_DISK1} ${UNHAPPY_DISK2} 
${UNHAPPY_DISK3}

Apologies that it's taken a while to respond to your mail, I just 
haven't had much time to look at this during the week.


Best Regards,
Sam
