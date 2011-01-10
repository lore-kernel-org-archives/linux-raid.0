From: Christian Schmidt <charlie@digadd.de>
Subject: Re: What exactly does echo check > /sys/block/mdX/md/sync_action
 do?
Date: Mon, 10 Jan 2011 01:28:07 +0100
Message-ID: <4D2A5297.6000601@digadd.de>
References: <4D2A3B25.6050504@digadd.de> <20110110102613.692fa2e3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110102613.692fa2e3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/10/2011 12:26 AM, NeilBrown wrote:
> On Sun, 09 Jan 2011 23:48:05 +0100 Christian Schmidt <charlie@digadd.de>
> wrote:
> 
>> Hi all,
>>
>> As the subject says, I'm wondering what issuing the "check" command to a
>> raid array does.
> 
> May I suggest
>    man 4 md
> 
> Does that answer your question?

Yes, indeed. Thanks.

>> A possibly related question is: why did this member turn into "spare"
>> role? The system was fully functional and in daily use for about a year.
>> It was declared to be a four drive raid 5 with no spares. If I remember
>> level 5 correctly there is no single drive for the redundancy data to
>> avoid bottlenecks, right?
> 
> One would need to see the history of the whole array, not just the current
> state of a single device, to be able to guess the reason for the current
> state.
> 
> And yes:  RAID5 distributes the parity blocks to avoid bottlenecks.
> 
>>
>> alpha md # mdadm --examine --verbose /dev/sdh2
>> /dev/sdh2:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
>>            Name : sysresccd:1
>>   Creation Time : Sat Jul 17 02:57:27 2010
>>      Raid Level : raid5
>>    Raid Devices : 4
>>
>>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>>      Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
>>   Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
>>     Data Offset : 2048 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 172eb49b:03e62242:614d7ed3:1fb25f65
>>
>>     Update Time : Sun Jan  9 19:55:09 2011
>>        Checksum : a991f168 - correct
>>          Events : 34
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : spare
>>    Array State : AAAA ('A' == active, '.' == missing)
>>
>> Too bad that 1.2 superblocks don't contain the full array information
>> like 0.90 did.
> 
> The extra information that 0.90 stored was not (and could not be) reliable.
> 
> This device thinks that that the array is functioning correctly with no
> failed devices, and that this device is a spare - presumably a 5th device?
> It doesn't know the names of the other devices (and if it thought it did, it
> could easily be wrong as names changed).  What do the other devices think of
> the state of the array?

[~]>mdadm -Q --detail /dev/md3
/dev/md3:
        Version : 1.02
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
     Array Size : 5857390080 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 1952463360 (1862.01 GiB 1999.32 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Mon Jan 10 00:38:00 2011
          State : clean, recovering
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 68% complete

           Name : sysresccd:1
           UUID : fa8fb033:6312742f:0524501d:5aa24a28
         Events : 34

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       50        1      active sync   /dev/sdd2
       2       8       82        2      active sync   /dev/sdf2
       4       8      114        3      active sync   /dev/sdh2

So just "check" turns the array into rebuild mode and one of the drives
into a spare? That's unexpected.

Thanks,
Christian
