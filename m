From: Valentijn <v@lentijn.sess.ink>
Subject: ignoring %s as it reports %s as failed
Date: Tue, 10 Feb 2015 16:54:44 +0100
Message-ID: <54DA29C4.2010000@lentijn.sess.ink>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

This is a repost - I sent it to linux-raid back in January, but you were 
all still having holidays - or hangovers or anything.

I was wondering why "--assemble --force" didn't work for a particular 
(failed) raid-device. I got it to work and the data is safe now, but the 
question about the non-working assembly remains.

I was trying to resurrect an array from a Synology disk station. As 
follows: raid5 array with 4 disks, one disk utterly broken 
(click-clack-click), one disk thrown out of the array.

Please note, that I used dmsetup to create an overlay disk, so the 
"/dev/mapper/diskXp5" actually points to a /dev/sdN5 which is the 
original array; I'm trying to not harm the original data. Here is the 
result of mdadm v3.2.5 running assemble+force:

~# mdadm --verbose --assemble --force /dev/md99 /dev/mapper/disk1p5 
/dev/mapper/disk2p5 /dev/mapper/disk3p5
mdadm: looking for devices for /dev/md99
mdadm: /dev/mapper/disk1p5 is identified as a member of /dev/md99, slot 
32768.
mdadm: /dev/mapper/disk2p5 is identified as a member of /dev/md99, slot 1.
mdadm: /dev/mapper/disk3p5 is identified as a member of /dev/md99, slot 2.
mdadm: ignoring /dev/mapper/disk2p5 as it reports /dev/mapper/disk1p5 as 
failed
mdadm: ignoring /dev/mapper/disk3p5 as it reports /dev/mapper/disk1p5 as 
failed
mdadm: No suitable drives found for /dev/md99

OK. http://permalink.gmane.org/gmane.linux.raid/45064 says I should use 
mdadm 3.3+, and luckily I had v3.3.2 - 21st August lying around, so 
there we go:

~# ./mdadm --verbose --assemble --force /dev/md99 /dev/mapper/disk1p5 
/dev/mapper/disk2p5 /dev/mapper/disk3p5
mdadm: looking for devices for /dev/md99
mdadm: /dev/mapper/disk1p5 is identified as a member of /dev/md99, slot 
32768.
mdadm: /dev/mapper/disk2p5 is identified as a member of /dev/md99, slot 1.
mdadm: /dev/mapper/disk3p5 is identified as a member of /dev/md99, slot 2.
mdadm: no uptodate device for slot 0 of /dev/md99
mdadm: added /dev/mapper/disk3p5 to /dev/md99 as 2
mdadm: no uptodate device for slot 6 of /dev/md99
mdadm: added /dev/mapper/disk2p5 to /dev/md99 as 1
mdadm: /dev/md99 assembled from 2 drives - not enough to start the array.

Hmm, that doesn't help us either. (Slight difference between the two 
versions, 3.2.5 deploys a broken array named md99 - which you can stop 
afterwards - and 3.3.2 seems to auto-remove the array after trying to 
start it - not sure if I describe the inner workings correctly)

Disk1 reports:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8ad57063:cf592975:9fabcc2b:13922e19
            Name : 2
   Creation Time : Sun May 13 08:23:21 2012
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 1944057456 (927.00 GiB 995.36 GB)
      Array Size : 2916086016 (2781.00 GiB 2986.07 GB)
   Used Dev Size : 1944057344 (927.00 GiB 995.36 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4ae571dc:3c458e25:d219b536:c8b9a50e

     Update Time : Sun Dec 28 10:41:55 2014
        Checksum : 9a35a9ae - correct
          Events : 744446

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 32768
    Array State : .AA. ('A' == active, '.' == missing)

Disk2:
               [...]
           State : clean
     Device UUID : b381cfd4:d2474cc4:e4c0ad21:8565b2a5

     Update Time : Sun Dec 28 10:41:55 2014
        Checksum : b3569b7e - correct
          Events : 744446

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 1
    Array State : .AA. ('A' == active, '.' == missing)

Disk3:
               [...]
           State : clean
     Device UUID : c00d4418:c8313607:fb3a2018:d267a693

     Update Time : Sun Dec 28 10:41:55 2014
        Checksum : 1e1b8de5 - correct
          Events : 744446

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 2
    Array State : .AA. ('A' == active, '.' == missing)

So the "Active device 32768" seems to be the culprit here, is that correct?

What would be the correct way to reassemble this array?

I managed to get it *working* again by recreating it with:
./mdadm --create --assume-clean --data-offset=136 -e 1.2 --level=5 
--bitmap=none --raid-devices=4 --chunk=64 /dev/md99 /dev/mapper/disk1p5 
/dev/mapper/disk2p5 /dev/mapper/disk3p5 missing

... but that feels a bit rude.

So, is there a "proper" way to reassemble this array?

For the record: the original array was most likely created on the 
Synology disk station itself, which currently contains mdadm - v2.6.7 (I 
don't know if that is the version that created the array). Also, I'm not 
sure about the kernel version that's running there, but /lib/modules 
contains modules that have a string "vermagic=2.6.15 ARMv5 gcc-3.4" 
inside, so that might be the kernel version that was running when things 
went wrong.

Best regards,

Valentijn
