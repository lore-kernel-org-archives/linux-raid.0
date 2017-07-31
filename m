From: Paul Tonelli <paul@tonel.li>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Mon, 31 Jul 2017 21:57:32 +0200
Message-ID: <e0c059b0-2d68-92bf-3eb9-e2827602061c@tonel.li>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
 <20170605235619.GA8478@metamorpher.de>
 <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
 <20170610204105.GA19409@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170610204105.GA19409@metamorpher.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello (again)

Sorry to resuscitate this topic back from the dead, but I have again the 
same issue.

TL;DR

The difference compared to last time:
- I created a clean raid a few days back
- the data is completely backed up and available
- I can actually access the data

but I still have no clue about what went wrong.

1) I created the raid:

sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 
/dev/sdb /dev/sdc /dev/sdd

without lvm this time, juste a single ext4 partition

mkfs.ext4 /dev/md0
mount /dev/md0 /srv/data

I copied 3Tb on it

I just rebooted the machine

2) and (again) no md0 assembled at boot:

mdadm -E /dev/sd[bcd]
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


This time, I am able to get my data back. I first create the overlays and:

mdadm --create --verbose /dev/md0 --assume-clean --level=5 
--raid-devices=3 /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd
mount /dev/md0 /srv/data

# mdadm --detail --scan /dev/md0
ARRAY /dev/md0 metadata=1.2 name=smic:0 
UUID=2ebab32e:82283ac5:4232d2ee:92abf170

and it mounts, so I did exactly the same using the real disks and 
(again) got my data back. The raid is now running:

# mdadm -E /dev/sdb
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 2ebab32e:82283ac5:4232d2ee:92abf170
            Name : smic:0  (local to host smic)
   Creation Time : Mon Jul 31 21:36:12 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : 2d1daf78:1e085799:6f1799b2:e88e60d1

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Jul 31 21:36:19 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 63abce91 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdc
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 2ebab32e:82283ac5:4232d2ee:92abf170
            Name : smic:0  (local to host smic)
   Creation Time : Mon Jul 31 21:36:12 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : db6d0696:072c5166:1491157d:6ddf34cf

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Jul 31 21:36:19 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 164e0d53 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 2ebab32e:82283ac5:4232d2ee:92abf170
            Name : smic:0  (local to host smic)
   Creation Time : Mon Jul 31 21:36:12 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=944 sectors
           State : clean
     Device UUID : 0c52bea6:a0cbf060:fe5edff0:4ee71d21

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Jul 31 21:36:19 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : e75866e8 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

but a reboot always brings me back to step 2), with the need to press 
ctrl-D at boot time.

What am I missing? Am I using a bad version of the mdadm or kernel 
(mdadm:amd64 3.3.2-5+deb8u2, kernel 4.8.0-0.bpo.2-amd64) or am I doing 
it wrong in another way ?

best regards,

On 06/10/2017 10:41 PM, Andreas Klauer wrote:
> On Sat, Jun 10, 2017 at 10:04:16PM +0200, Paul Tonelli wrote:
>> I believe the offset we manually specify is after the default one on a
>> raid assembly with 3 disks, so it should have rebuilt the previous LVM
>> superblock, or am I missing something (again).
> It should be the reverse. When you grow the raid, the offset shrinks.
>
> Not able to provide further insights. You have a LVM2 header which,
> given the correct offset, should appear on the /dev/md device and
> in that case everything else should appear too.
>
> If that is not the case then things will be a lot more complicated.
>
> Regards
> Andreas Klauer


