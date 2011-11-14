From: linbloke <linbloke@fastmail.fm>
Subject: Re: possible bug - bitmap dirty pages status
Date: Tue, 15 Nov 2011 10:11:51 +1100
Message-ID: <4EC1A037.4080406@fastmail.fm>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com> <CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com> <CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com> <4E5E2F7D.1010306@anonymous.org.uk> <CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com> <CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com> <CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com> <20110901154022.45f54657@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901154022.45f54657@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: CoolCold <coolthecold@gmail.com>, Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/09/11 3:40 PM, NeilBrown wrote:
> On Thu, 1 Sep 2011 00:16:36 +0400 CoolCold<coolthecold@gmail.com>  wrote:
>
>> On Wed, Aug 31, 2011 at 6:08 PM, Paul Clements
>> <paul.clements@us.sios.com>  wrote:
>>> On Wed, Aug 31, 2011 at 9:16 AM, CoolCold<coolthecold@gmail.com>  wrote:
>>>
>>>>           Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
>>>>
>>>> And 16/22 lasts for 4 days.
>>> So if you force another resync, does it change/clear up?
>>>
>>> If you unmount/stop all activity does it change?
>> Well, this server is in production now, may be i'll be able to do
>> array stop/start later..right now i've set "cat /proc/mdstat" every
>> minute, and bitmap examine every minute, will see later is it changing
>> or not.
>>
> I spent altogether too long staring at the code and I can see various things
> that could be usefully tidied but but nothing that really explains what you
> have.
>
> If there was no write activity to the array at all I can just see how that
> last bits to be set might not get cleared, but as soon as another write
> happened all those old bits would get cleared pretty quickly.  And it seems
> unlikely that there have been no writes for over 4 days (???).
>
> I don't think having these bits here is harmful and it would be easy to get
> rid of them by using "mdadm --grow" to remove and then re-add the bitmap,
> but I wish I knew what caused it...
>
> I clean up the little issues I found in mainline and hope there isn't a
> larger problem luking behind all this..
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
Hello,

Sorry for bumping this thread but I couldn't find any resolution 
post-dated. I'm seeing the same thing with SLES11 SP1. No matter how 
long I wait or how often I sync(8), the number of dirty bitmap pages 
does not reduce to zero - 52 has become the new zero for this array 
(md101). I've tried writing more data to prod the sync  - the result was 
an increase in the dirty page count (53/465) and then return to the base 
count (52/465) after 5seconds. I haven't tried removing the bitmaps and 
am a little reluctant to unless this would help to diagnose the bug.

This array is part of a nested array set as mentioned in another mail 
list thread with the Subject: Rotating RAID 1. Another thing happening 
with this array is that the top array (md106), the one with the 
filesystem on it, has the file system exported via NFS to a dozen or so 
other systems. There has been no activity on this array for at least a 
couple of minutes.

I certainly don't feel comfortable that I have created a mirror of the 
component devices. Can I expect the devices to actually be in sync at 
this point?

Thanks,

Josh

wynyard:~ # mdadm -V
mdadm - v3.0.3 - 22nd October 2009
wynyard:~ # uname -a
Linux wynyard 2.6.32.36-0.5-xen #1 SMP 2011-04-14 10:12:31 +0200 x86_64 
x86_64 x86_64 GNU/Linux
wynyard:~ #



Info with disks A and B connected:
======================

wynyard:~ # cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4] [linear]
md106 : active raid1 md105[0]
       1948836134 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md105 : active raid1 md104[0]
       1948836270 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md104 : active raid1 md103[0]
       1948836406 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md103 : active raid1 md102[0]
       1948836542 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md102 : active raid1 md101[0]
       1948836678 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md101 : active raid1 md100[0]
       1948836814 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md100 : active raid1 sdm1[0] sdl1[1]
       1948836950 blocks super 1.2 [2/2] [UU]
       bitmap: 2/465 pages [8KB], 2048KB chunk

wynyard:~ # mdadm -Dvv /dev/md100
/dev/md100:
         Version : 1.02
   Creation Time : Thu Oct 27 13:38:09 2011
      Raid Level : raid1
      Array Size : 1948836950 (1858.56 GiB 1995.61 GB)
   Used Dev Size : 1948836950 (1858.56 GiB 1995.61 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Nov 14 16:39:56 2011
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : wynyard:h001r006  (local to host wynyard)
            UUID : 0996cae3:fc585bc5:64443402:bf1bef33
          Events : 8694

     Number   Major   Minor   RaidDevice State
        0       8      193        0      active sync   /dev/sdm1
        1       8      177        1      active sync   /dev/sdl1

wynyard:~ # mdadm -Evv /dev/sd[ml]1
/dev/sdl1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0996cae3:fc585bc5:64443402:bf1bef33
            Name : wynyard:h001r006  (local to host wynyard)
   Creation Time : Thu Oct 27 13:38:09 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 3897673900 (1858.56 GiB 1995.61 GB)
      Array Size : 3897673900 (1858.56 GiB 1995.61 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 5d5bf5ef:e17923ec:0e6e683a:e27f4470

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov 14 16:52:12 2011
        Checksum : 987bd49d - correct
          Events : 8694


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing)
/dev/sdm1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 0996cae3:fc585bc5:64443402:bf1bef33
            Name : wynyard:h001r006  (local to host wynyard)
   Creation Time : Thu Oct 27 13:38:09 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 3897673900 (1858.56 GiB 1995.61 GB)
      Array Size : 3897673900 (1858.56 GiB 1995.61 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 59bc1fed:426ef5e6:cf840334:4e95eb5b

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov 14 16:52:12 2011
        Checksum : 75ba5626 - correct
          Events : 8694


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing)

Disk B failed and removed with mdadm and physically. Disk C inserted, 
partition table written and then added to array:
======================================
Nov 14 17:08:50 wynyard kernel: [1122597.943932] raid1: Disk failure on 
sdl1, disabling device.
Nov 14 17:08:50 wynyard kernel: [1122597.943934] raid1: Operation 
continuing on 1 devices.
Nov 14 17:08:50 wynyard kernel: [1122597.989996] RAID1 conf printout:
Nov 14 17:08:50 wynyard kernel: [1122597.989999]  --- wd:1 rd:2
Nov 14 17:08:50 wynyard kernel: [1122597.990002]  disk 0, wo:0, o:1, 
dev:sdm1
Nov 14 17:08:50 wynyard kernel: [1122597.990005]  disk 1, wo:1, o:0, 
dev:sdl1
Nov 14 17:08:50 wynyard kernel: [1122598.008913] RAID1 conf printout:
Nov 14 17:08:50 wynyard kernel: [1122598.008917]  --- wd:1 rd:2
Nov 14 17:08:50 wynyard kernel: [1122598.008921]  disk 0, wo:0, o:1, 
dev:sdm1
Nov 14 17:08:50 wynyard kernel: [1122598.008949] md: unbind<sdl1>
Nov 14 17:08:50 wynyard kernel: [1122598.056909] md: export_rdev(sdl1)
Nov 14 17:09:43 wynyard kernel: [1122651.587010] 3w-9xxx: scsi6: AEN: 
WARNING (0x04:0x0019): Drive removed:port=8.
Nov 14 17:10:03 wynyard kernel: [1122671.723726] 3w-9xxx: scsi6: AEN: 
ERROR (0x04:0x001E): Unit inoperable:unit=8.
Nov 14 17:11:33 wynyard kernel: [1122761.729297] 3w-9xxx: scsi6: AEN: 
INFO (0x04:0x001A): Drive inserted:port=8.
Nov 14 17:13:44 wynyard kernel: [1122892.474990] 3w-9xxx: scsi6: AEN: 
INFO (0x04:0x001F): Unit operational:unit=8.
Nov 14 17:19:36 wynyard kernel: [1123244.535530]  sdl: unknown partition 
table
Nov 14 17:19:40 wynyard kernel: [1123248.384154]  sdl: sdl1
Nov 14 17:24:18 wynyard kernel: [1123526.292861] md: bind<sdl1>
Nov 14 17:24:19 wynyard kernel: [1123526.904213] RAID1 conf printout:
Nov 14 17:24:19 wynyard kernel: [1123526.904217]  --- wd:1 rd:2
Nov 14 17:24:19 wynyard kernel: [1123526.904221]  disk 0, wo:0, o:1, 
dev:md100
Nov 14 17:24:19 wynyard kernel: [1123526.904224]  disk 1, wo:1, o:1, 
dev:sdl1
Nov 14 17:24:19 wynyard kernel: [1123526.904362] md: recovery of RAID 
array md101
Nov 14 17:24:19 wynyard kernel: [1123526.904367] md: minimum 
_guaranteed_  speed: 1000 KB/sec/disk.
Nov 14 17:24:19 wynyard kernel: [1123526.904370] md: using maximum 
available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Nov 14 17:24:19 wynyard kernel: [1123526.904376] md: using 128k window, 
over a total of 1948836814 blocks.
Nov 15 00:32:07 wynyard kernel: [1149195.478735] md: md101: recovery done.
Nov 15 00:32:07 wynyard kernel: [1149195.599964] RAID1 conf printout:
Nov 15 00:32:07 wynyard kernel: [1149195.599967]  --- wd:2 rd:2
Nov 15 00:32:07 wynyard kernel: [1149195.599971]  disk 0, wo:0, o:1, 
dev:md100
Nov 15 00:32:07 wynyard kernel: [1149195.599975]  disk 1, wo:0, o:1, 
dev:sdl1

Write data to filesystem on md106. Then idle:

wynyard:~ # iostat 5 /dev/md106 | grep md106
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
md106           156.35         0.05      1249.25      54878 1473980720
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0
md106             0.00         0.00         0.00          0          0


Info with disks A and C connected:
======================
wynyard:~ # cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4] [linear]
md106 : active raid1 md105[0]
       1948836134 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md105 : active raid1 md104[0]
       1948836270 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md104 : active raid1 md103[0]
       1948836406 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md103 : active raid1 md102[0]
       1948836542 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md102 : active raid1 md101[0]
       1948836678 blocks super 1.2 [2/1] [U_]
       bitmap: 465/465 pages [1860KB], 2048KB chunk

md101 : active raid1 sdl1[2] md100[0]
       1948836814 blocks super 1.2 [2/2] [UU]
       bitmap: 52/465 pages [208KB], 2048KB chunk

md100 : active raid1 sdm1[0]
       1948836950 blocks super 1.2 [2/1] [U_]
       bitmap: 26/465 pages [104KB], 2048KB chunk


wynyard:~ # mdadm -Dvv /dev/md101
/dev/md101:
         Version : 1.02
   Creation Time : Thu Oct 27 13:39:18 2011
      Raid Level : raid1
      Array Size : 1948836814 (1858.56 GiB 1995.61 GB)
   Used Dev Size : 1948836814 (1858.56 GiB 1995.61 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Nov 15 09:07:25 2011
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : wynyard:h001r007  (local to host wynyard)
            UUID : 8846dfde:ab7e2902:4a37165d:c7269466
          Events : 53486

     Number   Major   Minor   RaidDevice State
        0       9      100        0      active sync   /dev/md100
        2       8      177        1      active sync   /dev/sdl1

wynyard:~ # mdadm -Evv /dev/md100 /dev/sdl1
/dev/md100:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 8846dfde:ab7e2902:4a37165d:c7269466
            Name : wynyard:h001r007  (local to host wynyard)
   Creation Time : Thu Oct 27 13:39:18 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 3897673628 (1858.56 GiB 1995.61 GB)
      Array Size : 3897673628 (1858.56 GiB 1995.61 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d806cfd5:d641043e:70b32b6b:082c730b

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Nov 15 09:07:48 2011
        Checksum : 628f9f77 - correct
          Events : 53486


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing)
/dev/sdl1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 8846dfde:ab7e2902:4a37165d:c7269466
            Name : wynyard:h001r007  (local to host wynyard)
   Creation Time : Thu Oct 27 13:39:18 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 3897673900 (1858.56 GiB 1995.61 GB)
      Array Size : 3897673628 (1858.56 GiB 1995.61 GB)
   Used Dev Size : 3897673628 (1858.56 GiB 1995.61 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4689d883:19bbaa1f:584c89fc:7fafd176

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Nov 15 09:07:48 2011
        Checksum : eefbb899 - correct
          Events : 53486


    Device Role : spare
    Array State : AA ('A' == active, '.' == missing)

wynyard:~ # mdadm -vv --examine-bitmap /dev/md100 /dev/sdl1
         Filename : /dev/md100
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 53486
   Events Cleared : 0
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 29902 dirty (3.1%)
         Filename : /dev/sdl1
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 53486
   Events Cleared : 0
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 29902 dirty (3.1%)


