From: linbloke <linbloke@fastmail.fm>
Subject: Re: possible bug - bitmap dirty pages status
Date: Tue, 22 Nov 2011 08:50:22 +1100
Message-ID: <4ECAC79E.8020006@fastmail.fm>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com> <CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com> <CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com> <4E5E2F7D.1010306@anonymous.org.uk> <CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com> <CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com> <CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com> <20110901154022.45f54657@notabene.brown> <4EC1A037.4080406@fastmail.fm> <20111116133045.2528310b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111116133045.2528310b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: CoolCold <coolthecold@gmail.com>, Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/11/11 1:30 PM, NeilBrown wrote:
> On Tue, 15 Nov 2011 10:11:51 +1100 linbloke<linbloke@fastmail.fm>  wrote:
>> Hello,
>>
>> Sorry for bumping this thread but I couldn't find any resolution
>> post-dated. I'm seeing the same thing with SLES11 SP1. No matter how
>> long I wait or how often I sync(8), the number of dirty bitmap pages
>> does not reduce to zero - 52 has become the new zero for this array
>> (md101). I've tried writing more data to prod the sync  - the result was
>> an increase in the dirty page count (53/465) and then return to the base
>> count (52/465) after 5seconds. I haven't tried removing the bitmaps and
>> am a little reluctant to unless this would help to diagnose the bug.
>>
>> This array is part of a nested array set as mentioned in another mail
>> list thread with the Subject: Rotating RAID 1. Another thing happening
>> with this array is that the top array (md106), the one with the
>> filesystem on it, has the file system exported via NFS to a dozen or so
>> other systems. There has been no activity on this array for at least a
>> couple of minutes.
>>
>> I certainly don't feel comfortable that I have created a mirror of the
>> component devices. Can I expect the devices to actually be in sync at
>> this point?
> Hi,
>   thanks for the report.
>   I can understand your discomfort.  Unfortunately I haven't been able to
>   discover with any confidence what the problem is, so I cannot completely
>   relieve that discomfort.  I have found another possible issue - a race that
>   could cause md to forget that it needs to clean out a page of the bitmap.
>   I could imagine that causing 1 or maybe 2 pages to be stuck, but I don't
>   think it can explain 52.
>
>   Can can check if you actually have a mirror by:
>      echo check>  /sys/block/md101/md/sync_action
>   then wait for that to finish and check ..../mismatch_cnt.
>   I'm quite confident that will report 0.  I strongly suspect the problem is
>   that we forget to clear pages or bits, not that we forget to use them during
>   recovery.
>
>   So don't think that keeping the bitmaps will help in diagnosing the
>   problem.   We I need is a sequence of events that is likely to produce the
>   problem, and I realise that is hard to come by.
>
>   Sorry that I cannot be more helpful yet.
>
> NeilBrown

G'day Neil,

Thanks again for looking at this. I have performed the check as 
suggested and indeed we have a mirror (mismatch_cnt=0). I'm about to 
fail+remove the disk sdl1 from md101 and re-add the missing disk to 
md100. I'll run a check on that array once resync'd. When I'm done with 
that I'll look to test creating a new array from one of the offline 
components and run some md5sums on the contents to further validate data 
integrity. Are there any other tests I can include to help you identify 
the dirty bitmap cause?


Cheers,
Josh


Here is the state before and after check:


Before:
=====

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
       bitmap: 45/465 pages [180KB], 2048KB chunk

md100 : active raid1 sdm1[0]
       1948836950 blocks super 1.2 [2/1] [U_]
       bitmap: 152/465 pages [608KB], 2048KB chunk

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
     Update Time : Mon Nov 21 13:27:05 2011
        Checksum : 6297c5ea - correct
          Events : 53660


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
     Update Time : Mon Nov 21 13:27:05 2011
        Checksum : ef03df0c - correct
          Events : 53660


    Device Role : spare
    Array State : AA ('A' == active, '.' == missing)


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

     Update Time : Mon Nov 21 13:27:05 2011
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : wynyard:h001r007  (local to host wynyard)
            UUID : 8846dfde:ab7e2902:4a37165d:c7269466
          Events : 53660

     Number   Major   Minor   RaidDevice State
        0       9      100        0      active sync   /dev/md100
        2       8      177        1      active sync   /dev/sdl1

wynyard:~ # mdadm -vv --examine-bitmap /dev/md100 /dev/sdl1
         Filename : /dev/md100
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 53660
   Events Cleared : 53660
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 23276 dirty (2.4%)
         Filename : /dev/sdl1
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 53660
   Events Cleared : 53660
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 23276 dirty (2.4%)

wynyard:~ # cat /sys/block/md101/md/sync_{tabtab}
sync_action          sync_force_parallel  sync_min             
sync_speed_max
sync_completed       sync_max             sync_speed           
sync_speed_min
wynyard:~ # cat /sys/block/md101/md/sync_*
idle
none
0
max
0
none
200000 (system)
50000 (system)

wynyard:~ # echo check > /sys/block/md101/md/sync_action



After:
====

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
       bitmap: 22/465 pages [88KB], 2048KB chunk

md100 : active raid1 sdm1[0]
       1948836950 blocks super 1.2 [2/1] [U_]
       bitmap: 152/465 pages [608KB], 2048KB chunk

unused devices:<none>


wynyard:~ # cat /sys/block/md101/md/mismatch_cnt
0


wynyard:~ # mdadm -vv --examine-bitmap /dev/md100 /dev/sdl1
         Filename : /dev/md100
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 60976
   Events Cleared : 53660
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 10527 dirty (1.1%)
         Filename : /dev/sdl1
            Magic : 6d746962
          Version : 4
             UUID : 8846dfde:ab7e2902:4a37165d:c7269466
           Events : 60976
   Events Cleared : 53660
            State : OK
        Chunksize : 2 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 1948836814 (1858.56 GiB 1995.61 GB)
           Bitmap : 951581 bits (chunks), 10527 dirty (1.1%)
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
     Update Time : Mon Nov 21 18:57:13 2011
        Checksum : 62982fde - correct
          Events : 60976


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
     Update Time : Mon Nov 21 18:57:13 2011
        Checksum : ef044900 - correct
          Events : 60976


    Device Role : spare
    Array State : AA ('A' == active, '.' == missing)
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

     Update Time : Mon Nov 21 18:57:13 2011
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : wynyard:h001r007  (local to host wynyard)
            UUID : 8846dfde:ab7e2902:4a37165d:c7269466
          Events : 60976

     Number   Major   Minor   RaidDevice State
        0       9      100        0      active sync   /dev/md100
        2       8      177        1      active sync   /dev/sdl1









