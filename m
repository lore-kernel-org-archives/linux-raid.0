From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Fri, 21 Jul 2017 13:37:30 +0200
Message-ID: <cc2ff16e-5368-b828-6acc-6698d6e0b521@gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
 <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
 <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
 <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
 <87o9sn232n.fsf@notabene.neil.brown.name>
 <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
 <87shhyzhg5.fsf@notabene.neil.brown.name>
 <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com>
 <87d18uydir.fsf@notabene.neil.brown.name>
 <be3ba727-2456-3507-e6d8-5b46d8b64339@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <be3ba727-2456-3507-e6d8-5b46d8b64339@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On 07/21/2017 11:15 AM, Veljko wrote:
>> On 07/21/2017 12:00 AM, NeilBrown wrote:
>> Bother.
>>  mdadm uses "parse_size()" to parse the offset, and this rejects
>>  "0", which makes sense for a size, but not for an offset.
>>
>>  Just leave the "--data-offset=0" out. I checked and that is defintely
>>  the default for 1.0.
>
> Yes, now it works. I was able to create new linear device, restored the
> saved 3M file and grown xfs. It was really fast and indeed, I'm happy.
>
> Thank you very much, Neil!


Well, not without problems, it seams.

I was having problem with root partition that was mounted read-only 
because of some problem with ext4. After fixing that on reboot, I still 
have extra space that was added with 4 new drives, but there are no md3 
or md4. I'm mounting this device in fstab with UUID. I noticed that UUID 
for md4 was the same as md2 before rebooting. But if I use array UUID 
from examine of md2 (first member of linear raid), I get:

    mount: can't find UUID="24843a41:8f84ee37:869fbe7b:bc953b58"

The one that works and that is in fstab is that one for md2 in by-uuid 
below.


# cat /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sda4[4] sdd3[5] sdc3[7] sdb4[6]
       5761631232 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

md1 : active raid10 sda3[4] sdd2[5] sdc2[7] sdb3[6]
       97590272 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

md0 : active raid1 sda2[2] sdb2[3]
       488128 blocks super 1.2 [2/2] [UU]


No md3 or md4.

Also, no mention of them in mdadm.conf

# definitions of existing MD arrays
  ARRAY /dev/md/0 metadata=1.2 UUID=e5a17766:b4df544d:c2770d6e:214113ec 
name=backup1:0
  ARRAY /dev/md/1 metadata=1.2 UUID=91560d5a:245bbc56:cc08b0ce:9c78fea1 
name=backup1:1
  ARRAY /dev/md/2 metadata=1.2 UUID=f6eeaa57:a55f36ff:6980a62a:d4781e44 
name=backup1:2

or in dev:

# ls /dev/md/
0  1  2

or in /dev/disk/by-uuid:

  ls -al /dev/disk/by-uuid/
  total 0
  drwxr-xr-x 2 root root 120 Jul 21 12:11 .
  drwxr-xr-x 7 root root 140 Jul 21 12:11 ..
  lrwxrwxrwx 1 root root  10 Jul 21 12:15 
64f194a4-7a3f-4cff-b167-ff6d8e70adff -> ../../dm-1
  lrwxrwxrwx 1 root root   9 Jul 21 12:15 
81060b25-b698-4cbd-b67f-d35c42c9482c -> ../../md2
  lrwxrwxrwx 1 root root  10 Jul 21 12:15 
b0285993-75db-48fd-bcd7-10d870e6069f -> ../../dm-0
  lrwxrwxrwx 1 root root   9 Jul 21 12:15 
dcfde992-2fe2-4da2-bb66-8c541a4bd473 -> ../../md0



--examine of md2 shows that this is a member of newly created linear md4 
array:

# mdadm --examine /dev/md2
/dev/md2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x0
      Array UUID : 24843a41:8f84ee37:869fbe7b:bc953b58
            Name : backup2:4  (local to host backup2)
   Creation Time : Fri Jul 21 10:58:07 2017
      Raid Level : linear
    Raid Devices : 2

  Avail Dev Size : 11523262440 (5494.72 GiB 5899.91 GB)
   Used Dev Size : 0
    Super Offset : 11523262448 sectors
           State : clean
     Device UUID : d8931222:30af893e:9e0d2fe3:b18274ef

     Update Time : Fri Jul 21 10:58:07 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : eff10ec - correct
          Events : 0

        Rounding : 1024K

    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)


This device and array has different UUID than one used for mounting the 
device in fstab.

--detail on md2 still works.

mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Fri Sep 14 12:40:13 2012
      Raid Level : raid10
      Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
   Used Dev Size : 2880815616 (2747.36 GiB 2949.96 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Fri Jul 21 12:28:07 2017
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 512K

            Name : backup1:2
            UUID : f6eeaa57:a55f36ff:6980a62a:d4781e44
          Events : 2689052

     Number   Major   Minor   RaidDevice State
        4       8        4        0      active sync set-A   /dev/sda4
        6       8       20        1      active sync set-B   /dev/sdb4
        7       8       35        2      active sync set-A   /dev/sdc3
        5       8       51        3      active sync set-B   /dev/sdd3


--examine switch on partitions that are members of md2 or md3 shows that 
they know where they belong.

Is there a procedure for finding the missing devices? I'm not really 
comfortable with this confusing situation.

Regards,
Veljko
