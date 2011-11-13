From: Travis Brown <teb@jetcom.org>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Sun, 13 Nov 2011 08:50:44 -0500
Message-ID: <E40EAF06-9565-4235-AF38-4FDF399DEB23@jetcom.org>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org> <20111113143504.7b1f75b1@notabene.brown> <CBA73993-A81B-4BD5-B631-F384C91F6382@jetcom.org>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CBA73993-A81B-4BD5-B631-F384C91F6382@jetcom.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was able to unmount /home by logging in as 'root' so I could stop the RAID, so that's a moot point for my immediate needs.

Thanks,
Travis

On Nov 13, 2011, at 8:11 AM, Travis Brown wrote:

> Thanks Neil.
> 
> Luckily, this array isn't /root, but it doesn't have /home. That means that only way I can effectively stop is is probably going to be to reboot the machine.  Since the kernel auto assembles the RAID, I think I'll have to boot from a rescue disk to do this? Is there any way to have mdadm/the kernel look for a backup file on startup? If I have to do it from a rescue disk, the machine will effectively be unusable until the raid finishes it's reshaping.
> 
> Thanks, 
> Travis
> 
> On Nov 12, 2011, at 10:35 PM, NeilBrown wrote:
> 
>> On Sat, 12 Nov 2011 21:56:56 -0500 Travis Brown <teb@jetcom.org> wrote:
>> 
>>> I was reshaping my 5 drive raid 5 with spare to a raid 6 array when the drive I was using for my backup went offline.  If that's not murphy's law, I don't know what is.  The array is still up and usable, but I'm afraid to reboot or doing anything to it, really.  Suggestions on getting this thing back to usable are very welcome. 
>>> 
>>> Thanks,
>>> Travis
>>> 
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
>>> md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
>>>     5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5/4] [UUUU_]
>>>     [>....................]  reshape =  0.9% (19267584/1952242688) finish=623878.3min speed=51K/sec
>> 
>> 1/ Don't Panic.  
>>  You seem to have achieved this step quite effectively - congratulations.
>> 
>> 2/ Stop the array cleanly.  Not having a backup will only cause possible
>>  corruption if the machine crashes while the reshape is happening.  The
>>  reshape has stopped so there is no chance for corruption.  But you still
>>  need to cleanly stop the array.
>>  (A subsequent version of mdadm may allow you to continue the reshape
>>  without the stop/restart step, but we aren't there yet).
>> 
>> 3/ Make sure you have a version of mdadm which is at least 3.2.   I would
>>  suggest the latest:3.2.2.  You particularly need the --invalid-backup
>>  flag.
>> 
>> 4/ Reassemble the array with e.g.
>> 
>>   mdadm --assemble /dev/md126 --backup=/some/file  \
>>   --invalid-backup /dev/sd[bcdef]3
>> 
>> 
>>  The  backup file does not need to exist (I think).  Maybe create an empty
>>  file and use that just to be safe.
>>  The "--invalid-backup" flag says to mdadm "Yes, I know the backup file is
>>  currently invalid and you cannot restore anything from it.  I happen to
>>  know that there is no need to restore anything because I did a clean
>>  shutdown.  Just use the backup file for making new backups as you continue
>>  the reshape".
>> 
>> NeilBrown
>> 
>> 
>>> 
>>> /dev/md126:
>>>       Version : 0.91
>>> Creation Time : Wed Nov 10 20:19:03 2010
>>>    Raid Level : raid6
>>>    Array Size : 5856728064 (5585.41 GiB 5997.29 GB)
>>> Used Dev Size : 1952242688 (1861.80 GiB 1999.10 GB)
>>>  Raid Devices : 5
>>> Total Devices : 5
>>> Preferred Minor : 126
>>>   Persistence : Superblock is persistent
>>> 
>>>   Update Time : Sat Nov 12 21:55:46 2011
>>>         State : clean, degraded, recovering
>>> Active Devices : 4
>>> Working Devices : 5
>>> Failed Devices : 0
>>> Spare Devices : 1
>>> 
>>>        Layout : left-symmetric-6
>>>    Chunk Size : 512K
>>> 
>>> Reshape Status : 0% complete
>>>    New Layout : left-symmetric
>>> 
>>>          UUID : 3fd8b303:7727aa3b:c5d110f2:f9137e1d
>>>        Events : 0.124051
>>> 
>>>   Number   Major   Minor   RaidDevice State
>>>      0       8       67        0      active sync   /dev/sde3
>>>      1       8       19        1      active sync   /dev/sdb3
>>>      2       8       35        2      active sync   /dev/sdc3
>>>      3       8       83        3      active sync   /dev/sdf3
>>>      4       8       51        4      spare rebuilding   /dev/sdd3--
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 

