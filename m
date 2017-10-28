From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Sat, 28 Oct 2017 12:03:41 -0700
Message-ID: <CAA4aoFY=AK5SMasoRGJEzK=kAVuyJjqQeDu0Fm2mk28juCVXVw@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <CAK2H+efGBYmnPUL2gKqAQ=RRkFBZmBUw8fBcr0efgyb+L7YORA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efGBYmnPUL2gKqAQ=RRkFBZmBUw8fBcr0efgyb+L7YORA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=688 sectors
          State : clean
    Device UUID : 9c14bcb8:be8310f5:5b50c3a7:e6e57423

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Jan 15 08:09:15 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 13425c44 - correct
         Events : 5667

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 15d85573:6e78f040:8c028ef3:d1301f9d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e568d9d9 - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 64d5961e:230e558c:3748b561:a7c6ab8c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 39c2485b - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 2df0b319:bdb18eee:27b318ec:da55d53d

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d2a600e7 - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f1a790a9:98e01257:d9ab257d:95c8f1fc

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1b3052f2 - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 6f44eba1:29d246a4:c5e8312e:bac00a7b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 8fe4160e - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x47
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
Recovery Offset : 11264816 sectors
          State : active
    Device UUID : 109b7a2f:0529794c:2cf95cc1:d6c0bd6b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4a2fb746 - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
           Name : livingrm-server:2  (local to host livingrm-server)
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
     New Offset : 254976 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : deb04cea:d6530966:6c70ca90:bebb143e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
  Delta Devices : 1 (7->8)

    Update Time : Fri Oct 27 19:46:43 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bfaa86d9 - correct
         Events : 650554

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)


and mdadm -D

/dev/md126:
        Version :
     Raid Level : raid0
  Total Devices : 0

          State : inactive

    Number   Major   Minor   RaidDevice

On Sat, Oct 28, 2017 at 11:48 AM, Mark Knecht <markknecht@gmail.com> wrote:
> On Sat, Oct 28, 2017 at 11:36 AM, Jun-Kai Teoh <kai.teoh@gmail.com> wrote:
>> Hi all,
>>
>> Hope this email is going to the right place.
>>
>> I'll cut to the chase - I added a drive to my RAID 5 and was resyncing
>> when my machine was abruptly powered down. Upon booting it up again,
>> my RAID array is now missing.
>>
>> I've followed the instructions that I've found on the wiki, and it
>> hasn't solved my issues, but it's given me a sense of the things that
>> I'm hoping can help you guys help me troubleshoot.
>>
>> My array can't be assembled. It tells me that the superblock on
>> /dev/sda doesn't match the others.
>>
>> /dev/sda thinks the array has 7 drives
>> /dev/sd[bcefghi] thinks the array has 8 drives
>>
>> /dev/sda was not being reshaped
>> /dev/sd[bcefghi] has reshape position data in the raid.status file
>>
>> both /dev/sda and /dev/sdh think their device role is Active device 2
>>
>> I can't bring /dev/md126 back up with sd[bcefghi] as it'll tell me
>> that there are 6 drives and 1 rebuilding, not enough to start the
>> array
>>
>> My mdadm.conf shows a /dev/dev/127 with very minimal info in it - does
>> not look right to me.
>>
>> I haven't zeroed the superblock, nor have I tried a clean-assemble
>> either. I saw the wiki say I should email the group if I've gotten
>> that far and I'm panicking and nothing's working. So...
>>
>> Help me out, pretty please?
>
> I wonder if you know for certain that the RAID was scrubbed and clean
> before you made the changes?
>
> Maybe sda got kicked before you added the new drive?
>
> The number one thing you'll want to supply is the 'Examine' results
> for all drives:
>
> mdadm -E /dev/sd[abcdefghi]
>
> and
>
> mdadm -D for the array if it rill run.
>
> I would also run smartctl on the drives and post those results back also.
>
> I won't be able to solve your problems but those items are pretty much
> required for others to get started in a meaningful way.
>
> Good luck,
> Mark
