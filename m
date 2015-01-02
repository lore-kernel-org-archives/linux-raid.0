From: Aryeh Leib Taurog <vim@aryehleib.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Fri, 2 Jan 2015 15:01:01 +0200
Message-ID: <20150102130101.GC6294@deb76.aryehleib.com>
References: <54A5B409.8040501@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54A5B409.8040501@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 01, 2015 at 8:54 PM, Robert L Mathews wrote:
>> I recently made a RAID1 array from a couple of extra usb drives:
>> $ mdadm --create --metadata 1.2 --verbose /dev/md/backup --level=mirror -n2 /dev/sd[cd]2
>
> These are sdc2 and sdd2. Okay.
>
>> Personalities : [raid1] md126 : active (auto-read-only) raid1 
>> sdc2[0]
>>       943587136 blocks super 1.2 [2/1] [U_]
>>       
>> md127 : active (auto-read-only) raid1 sdd2[1]
>>       943587136 blocks super 1.2 [2/1] [_U]
>
> Still sdc2 and sdd2, although now in two arrays.
>
>> AFAIK both drives are healthy, but since that happened, it refuses 
>> to assemble them both in the array:
>> $ mdadm --assemble --force /dev/md/backup /dev/sd[db]2
>> mdadm: ignoring /dev/sdb2 as it reports /dev/sdd2 as failed
>
> Now you're working on sdb2 and sdd2. Is that intentional? Did sdc2
> become sdb2 after a restart or something?

Yes.  They're just two of three external usb disks.  The lettering
depends on the order in which I power up the computer and the drives.
I believe I read that mdadm works even when the device names change.
It did seem to be working before this issue arose.

>> Is there any way to put the array back together without having to 
>> resync?
>
> You should collect more data about what array each partition thinks  
> it's a member of, etc., before you try anything else. People can  
> probably help more if you report the output of these to the list:
> 
> mdadm --detail /dev/md*

I had to assemble the array, but as above, it only includes one device.
While doing this I discovered one of the usb cables is flaky, which 
explains why the device (sdc below) wasn't always coming on line.

$ mdadm --assemble --force /dev/md/backup /dev/sd[cd]2
mdadm: ignoring /dev/sdc2 as it reports /dev/sdd2 as failed
mdadm: /dev/md/backup has been started with 1 drive (out of 2).
$ mdadm --detail /dev/md/*
/dev/md/backup:
        Version : 1.2
  Creation Time : Wed Dec 17 22:39:10 2014
     Raid Level : raid1
     Array Size : 943587136 (899.87 GiB 966.23 GB)
  Used Dev Size : 943587136 (899.87 GiB 966.23 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Dec 30 08:06:51 2014
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : deb76:backup  (local to host deb76)
           UUID : ee0bd35a:727132cc:b4230313:69d3cbd7
         Events : 382

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       50        1      active sync   /dev/sdd2

> mdadm --examine /dev/sd*

I won't bore you with sda and sdb, there's nothing raid-related
on them.

$ mdadm --examine /dev/sd[cd]{,2}
/dev/sdc:
   MBR Magic : aa55
Partition[0] :     16777216 sectors at        16384 (type 83)
Partition[1] :   1887436800 sectors at     16793600 (type da)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :     16777216 sectors at        16384 (type 83)
Partition[1] :   1887436800 sectors at     16793600 (type da)
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ee0bd35a:727132cc:b4230313:69d3cbd7
           Name : deb76:backup  (local to host deb76)
  Creation Time : Wed Dec 17 22:39:10 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1887174656 (899.88 GiB 966.23 GB)
     Array Size : 943587136 (899.87 GiB 966.23 GB)
  Used Dev Size : 1887174272 (899.87 GiB 966.23 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0347f019:c7911229:bde3bb2e:847aeebc

    Update Time : Sun Dec 28 21:20:46 2014
       Checksum : 7cd44677 - correct
         Events : 38


   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ee0bd35a:727132cc:b4230313:69d3cbd7
           Name : deb76:backup  (local to host deb76)
  Creation Time : Wed Dec 17 22:39:10 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1887174656 (899.88 GiB 966.23 GB)
     Array Size : 943587136 (899.87 GiB 966.23 GB)
  Used Dev Size : 1887174272 (899.87 GiB 966.23 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d2c29953:34be093c:00279411:674cd53e

    Update Time : Tue Dec 30 08:06:51 2014
       Checksum : 2e39ee1c - correct
         Events : 382


   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing)

