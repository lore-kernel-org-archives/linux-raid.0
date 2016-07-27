From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: SOLVED [was Re: GPT corruption on Primary Header, backup OK, fixing
 primary nuked array -- help?]
Date: Wed, 27 Jul 2016 02:13:20 -0500
Message-ID: <57985F10.4070706@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 06:18 PM, Chris Murphy wrote:
> To get rid of the backup GPT you'll zero the last two sectors of the
> drive. So first get the total number of sectors from something like
> gdisk -l which gets you this information (in part):
> 
> Disk /dev/sda: 1953525168 sectors, 931.5 GiB
> 
> And do
> dd if=/dev/zero of=/dev/sda seek=1953525167
> 
> That'll erase ..67 and ..68, but the header is in ..67, one sector
> before the last one. Nothing should be in the last sector anyway but
> I'd check first! I don't know if ext4 put something there. And do not
> use the "last usable sector" because that's full 34 sectors from the
> end and there very well may be ext4 metadata in there that you do not
> want to step on with /dev/sdc.

Chris, Phil, All,

  Thank you. For anyone else that is faced with the problem where you are using
whole disks in your raid1 array over the top of unused sub-partitions, here is
the 5 minute fix.

  In my circumstance, I had partitioned a pair of 3T WD Black drives for use in
a raid1 array. I then created the array, but instead of using the partitions
(sdc1/sdd1), I used the whole disk for the array (sdc/sdd). The array worked
flawlessly for a year, and while collecting partition/geometry info to squirrel
away for disaster recovery, I noticed gdisk -l /dev/sdc complained that the
primary GPT header was corrupt, but the backup was fine. (examples of the gdisk
output can be found earlier in this thread). The robust and flexible mdadm came
through with flying colors. Had I done this correct to begin with, it could have
been completed without a resync (saving several hours)

How I solved the problem:

  (1) do NOT attempt to alter the disk in a partitioning package like fdisk,
sfdisk, gdisk, parted, etc.. A write after you delete the unused partitions with
adversely affect the md data and will require a long and painful resync
depending on the size of your drive.

  (2) simply --fail and --remove one drive from the array. My array was
/dev/md4, and failing and removing /dev/sdd from the array was as simple as:

# mdadm /dev/md4 --fail /dev/sdd
# mdadm /dev/md4 --remove /dev/sdd

  (3) To remove the inadvertent partition on the drive while keeping the raid
data in tact, you must remove the PMBR and primary Partition tables from the
drive. You can use `wipefs` or simply use `dd` to overwite the first 4096 bytes
on the drive with zeros and then the last 1024 bytes before the end of the disk
to remove the backup GPT header. (I overwote the last 4096 bytes on the disk,
just to make sure -- I had nothing in the last 100M of the disk, so that seemed
fine) You can look at the disk geometry reported by gdisk to find the end of the
disk (the number of logical sectors -- make sure the disk has 512-byte sectors,
or dd option adjustments will be needed) (then just subtract 8 from that number
(or 2 if you wish to limit the write to 1024 bytes) and use that as the 'seek'
offset with 'dd', so

  # dd of=/dev/sdd if=/dev/zero bs=4096 count=1
  # dd of=/dev/sdd if=/dev/zero bs=512 count=8 seek=5860533160

  I also wrote over the last 8 sectors at the reported end of sdd1 as well (not
sure if this had any relation to the problem, but I wanted to make sure if there
was any GPT header at the end of the partition, it was zeroed as well)

  # dd of=/dev/sdd if=/dev/zero bs=512 count=8 seek=5860328334

  (4) then simply --re-add the drive to the array (no resync will be required)

  # mdadm /dev/md4 --re-add /dev/sdd
  mdadm: re-added /dev/sdd


  (5) Now simply repeat the process with /dev/sdc

  When you are done, you will have two drives, using the whole disk for the
array without the unintended empty partitions on the drive. Now gdisk reports
correctly, e.g.

# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

and you array will be active and clean:

# mdadm -D /dev/md4
/dev/md4:
        Version : 1.2
  Creation Time : Mon Mar 21 02:27:21 2016
     Raid Level : raid1
     Array Size : 2930135488 (2794.39 GiB 3000.46 GB)
  Used Dev Size : 2930135488 (2794.39 GiB 3000.46 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Jul 27 01:36:56 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : valkyrie:4  (local to host valkyrie)
           UUID : 6e520607:f152d8b9:dd2a3bec:5f9dc875
         Events : 7984

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       2       8       48        1      active sync   /dev/sdd


  Thank you again to all that helped.

-- 
David C. Rankin, J.D.,P.E.
