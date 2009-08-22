From: "NeilBrown" <neilb@suse.de>
Subject: Re: Growing raid 5: Failed to reshape
Date: Sat, 22 Aug 2009 14:55:11 +1000 (EST)
Message-ID: <adb28910a2821e3532ac48f500e48aa6.squirrel@neil.brown.name>
References: <5c45fce80908211231v9238a12i3829ad5d1b107df5@mail.gmail.com>
    <2735df411d9ed83a9d11664f595d6dfc.squirrel@neil.brown.name>
    <121580D1-2950-43FB-AD1F-B235D1160932@gmail.com>
    <f136a4dd531edb8f5786e2592d033682.squirrel@neil.brown.name>
    <112F4A08-5E5C-4132-A233-6898D24B1D74@gmail.com>
    <cad055848e80fe2cffebf8bffdfe94f0.squirrel@neil.brown.name>
    <3FA7DE88-932D-4194-9195-E7CBA93D5432@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FA7DE88-932D-4194-9195-E7CBA93D5432@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, August 22, 2009 2:35 pm, Anshuman Aggarwal wrote:
> Well, I was so relieved on seeing what looked like my data, that I
> didn't wait for this last mail....and already started the grow
> operation again!
>
> What is the best way I can have the array check itself out now? to
> make sure there are no data inconsistencies? I guess I'll should wait
> for the grow operation to complete first?

The reshape operation recalculates all the parity blocks, so you
cannot check those for consistency any more.  All you can do is
fsck and look at the filesystem.

>
> Will a controlled system shutdown hurt the grow operation (I have an
> APC UPS which shuts down my machine well in time when there is an
> outage)? I am hoping it will resume from where it left off? since the
> critical section has passed?

A shutdown, whether controlled or not, should be safe.  mdadm will
make sure the reshape resumes from where it got up to.


>
> Also, one interesting observation about mdadm you may be especially
> interested in:
>
> I have tried using both 2.6.7 and 3.0 (final june version) of mdadm
> with the kernel 2.6.30.4...
>
> * mdadm 3.0 wouldn't grow the array :
> /Src/mdadm-3.0# ./mdadm --grow /dev/md127 -n 4
> mdadm: Need to backup 384K of critical section..
> mdadm: /dev/md127: failed to save critical region
>
> I resorted to using the mdadm 2.6.7 that came with Ubuntu...

Thanks for that.  I'll make sure it gets fixed in mdadm-3.0.1.


Thanks,
NeilBrown

>
> Thanks,
> Anshuman
>
> On 22-Aug-09, at 9:44 AM, NeilBrown wrote:
>
>> On Sat, August 22, 2009 1:55 pm, Anshuman Aggarwal wrote:
>>>  I have just sent in another mail with the mdadm examine details from
>>> the 3 + 1(grown) partitions. I am sure of the device names, but not
>>> sure of the order (which examine does tell me)
>>> Here are the devices, in order (I think):  /dev/sdb, /dev/sdd5, /dev/
>>> sdc5 + /dev/sda2 with the dd output you requested:
>>
>> Thanks.
>> /dev/sdb and /dev/sdd5 definitely look correct.
>> I am very suspicious of the others though.  If the metadata has been
>> destroyed, it is entirely possible that some of the data has been
>> corrupted as well.
>>
>> As you only need two drives to recover your data, and you have two
>> drives that look good, I suggest that you just use those.
>> So:
>>
>> mdadm --create /dev/md0 -l5 -n3 -e1.2 --name raid5_280G  \
>>         /dev/sdb /dev/sdd5 missing
>>
>> The first thing to do is --examine sdb and sdd5 and make sure that
>> "Data Offset" is 272.  It probably will be, but some different
>> versions
>> of mdadm used different offsets and you need to be sure.
>> Assuming it is 272 your data should be safe and you an "fsck" and
>> "mount"
>> just to confirm that.
>>
>> Then add sdc5 and sda2 and let the array recover the missing device.
>> Once that is done you can try the --grow again.
>>
>> NeilBrown
>>
>>
>>
>>
>>>
>>> ----------------------------------
>>>  dd if=/dev/sdb skip=8 count=2 | od -x
>>>
>>> 2+0 records in
>>> 2+0 records out
>>> 1024 bytes (1.0 kB) copied, 5.6394e-05 s, 18.2 MB/s
>>> 0000000 4efc a92b 0001 0000 0000 0000 0000 0000
>>> 0000020 5f49 6866 e1f1 102d 5299 920f 1976 87b4
>>> 0000040 4147 4554 4157 3a59 6172 6469 5f35 3832
>>> 0000060 4730 0000 0000 0000 0000 0000 0000 0000
>>> 0000100 2b74 4a73 0000 0000 0005 0000 0002 0000
>>> 0000120 2900 22ef 0000 0000 0080 0000 0003 0000
>>> 0000140 0002 0000 0000 0000 0300 0000 0000 0000
>>> 0000160 0000 0000 0000 0000 0000 0000 0000 0000
>>> 0000200 0110 0000 0000 0000 6580 22ef 0000 0000
>>> 0000220 0008 0000 0000 0000 0000 0000 0000 0000
>>> 0000240 0000 0000 0000 0000 a272 abb3 8be3 62a6
>>> 0000260 c0bd c0a0 990e 583b 0000 0000 0000 0000
>>> 0000300 209f 4a8e 0000 0000 3508 0000 0000 0000
>>> 0000320 ffff ffff ffff ffff 24a1 59e3 0180 0000
>>> 0000340 0000 0000 0000 0000 0000 0000 0000 0000
>>> *
>>> 0000400 0000 fffe fffe 0002 0001 ffff ffff ffff
>>> 0000420 ffff ffff ffff ffff ffff ffff ffff ffff
>>> *
>>> 0002000
>>> ------------------------------------
>>>  dd if=/dev/sdd5 skip=8 count=2 | od -x
>>> 2+0 records in
>>> 2+0 records out
>>> 1024 bytes (1.0 kB) copied, 0.0104253 s, 98.2 kB/s
>>> 0000000 4efc a92b 0001 0000 0004 0000 0000 0000
>>> 0000020 5f49 6866 e1f1 102d 5299 920f 1976 87b4
>>> 0000040 4147 4554 4157 3a59 6172 6469 5f35 3832
>>> 0000060 4730 0000 0000 0000 0000 0000 0000 0000
>>> 0000100 2b74 4a73 0000 0000 0005 0000 0002 0000
>>> 0000120 2900 22ef 0000 0000 0080 0000 0004 0000
>>> 0000140 0002 0000 0005 0000 0000 0000 0000 0000
>>> 0000160 0001 0000 0002 0000 0080 0000 0000 0000
>>> 0000200 0110 0000 0000 0000 2974 22ef 0000 0000
>>> 0000220 0008 0000 0000 0000 0000 0000 0000 0000
>>> 0000240 0004 0000 0000 0000 4a75 cfe1 eebb 8205
>>> 0000260 60f6 89ec 88a8 d300 0000 0000 0000 0000
>>> 0000300 21c2 4a8e 0000 0000 350d 0000 0000 0000
>>> 0000320 0000 0000 0000 0000 81fb e184 0180 0000
>>> 0000340 0000 0000 0000 0000 0000 0000 0000 0000
>>> *
>>> 0000400 0000 fffe fffe 0002 0001 0003 ffff ffff
>>> 0000420 ffff ffff ffff ffff ffff ffff ffff ffff
>>> *
>>> 0002000
>>> ------------------------------------
>>> dd if=/dev/sdc5 skip=8 count=2 | od -x
>>> 2+0 records in
>>> 2+0 records out
>>> 1024 bytes (1.0 kB) copied, 0.0102071 s, 100 kB/s
>>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>>> *
>>> 0002000
>>> --------------------------------------
>>> This following is probably just junk since it is not even initialized
>>>
>>> dd if=/dev/sda1 skip=8 count=2 | od -x
>>> 2+0 records in
>>> 2+0 records out
>>> 1024 bytes (1.0 kB) copied, 0.0127419 s, 80.4 kB/s
>>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>>> *
>>> 0000200 0000 0000 0000 0000 4cf4 0000 0000 0000
>>> 0000220 0000 0000 0000 0000 0000 0000 0000 0000
>>> 0000240 0004 0000 0000 0000 e807 6452 6558 e0a3
>>> 0000260 a04b 494c 11a6 8b3b 0000 0000 0000 0000
>>> 0000300 0000 0000 0000 0000 0002 0000 0000 0000
>>> 0000320 0000 0000 0000 0000 a1e8 b863 0000 0000
>>> 0000340 0000 0000 0000 0000 0000 0000 0000 0000
>>> *
>>> 0002000
>>>
>>>
>>> Thanks,
>>> Anshuman
>>>
>>>
>>> On 22-Aug-09, at 8:58 AM, NeilBrown wrote:
>>>
>>>> On Sat, August 22, 2009 12:41 pm, Anshuman Aggarwal wrote:
>>>>> Neil,
>>>>> Thanks for your input. Its great to have some hand holding when
>>>>> your
>>>>> heart is stuck in your mouth.
>>>>>
>>>>> Here is some more explanation:
>>>>>
>>>>> I have another raid array on the same disks in different partitions
>>>>> and there was a grow operation happening on those also at time
>>>>> (which
>>>>> has completed splendidly after the power outage). From what I have
>>>>> observed so far, when there is heavy activity on the disk due to 1
>>>>> array, the kernel delays puts the other tasks in a DELAYED status.
>>>>> ( I
>>>>> have done it this way because I have 4 different sized disks
>>>>> purchased
>>>>> over time)
>>>>>
>>>>> I had given the grow command before I realized that the other grow
>>>>> operation had not completed on the other partitions.
>>>>>
>>>>> * The critical section status from mdam was stuck (apparently
>>>>> waiting
>>>>> for the grow on the other partitions to complete). Hence it did not
>>>>> complete as quickly as it should have.
>>>>> * Because it kept waiting for the other md operations on the disk
>>>>> to
>>>>> complete, the critical section didn't get written (my guess, its
>>>>> also
>>>>> possible that the disk was so busy that it took more than an hour
>>>>> but
>>>>> unlikely)
>>>>>
>>>>> Please tell me if you this additional info changes our approach to
>>>>> try
>>>>> and fix this?
>>>>
>>>> I understand now (and on reflection, your original email had enough
>>>> information that I should have been able to pick up on).  When
>>>> there is a resync happening on one partition of a drive, md will
>>>> not start a resync on any other partition of that drive and that
>>>> would result in significantly reduced performance and reduced total
>>>> time to completion.
>>>> This applies equally to recovery and reshape.
>>>>
>>>> So while the first reshape has happening, the second would not
>>>> have started at all.  This confirms that no data will have been
>>>> relocated at all, so a correct '--create' will get your data back
>>>> correctly.
>>>>
>>>> I should change mdadm to not try starting a reshape if it won't
>>>> proceed as it could cause real problems if the start of the reshape
>>>> blocks for too long.
>>>>
>>>> This still doesn't explain why you lost some metadata though.
>>>> If it updated one of the devices, it should have updated all of them
>>>> as it does the update in parallel.
>>>>
>>>> Would you be able to:
>>>>
>>>> dd if=/dev/WHATEVER skip=8 count=2 | od -x
>>>>
>>>> where 'WHATEVER' is each of the different devices that you think it
>>>> in the array.  That might give me some clue.
>>>>
>>>> My recommendation for how to fix it remains the same.  I now have
>>>> more confidence that it will work.  You need to be sure which device
>>>> is
>>>> which though.
>>>>
>>>> NeilBrown
>>>>
>>>>
>>>>>
>>>>> I do have a UPS with an hour of backup but recently moved back to
>>>>> my
>>>>> home country, India where power supply will probably *NEVER* ever
>>>>> be
>>>>> continuos  enough for a long md operation :). Hence, I'm definitely
>>>>> one to vote for recoverable moves (which mdadm and the kernal have
>>>>> been pretty good at so far)
>>>>>
>>>>> Thanks,
>>>>> Anshuman
>>>>>
>>>>> On 22-Aug-09, at 3:00 AM, NeilBrown wrote:
>>>>>
>>>>>> On Sat, August 22, 2009 5:31 am, Anshuman Aggarwal wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Here is my problem and configuration. :
>>>>>>>
>>>>>>> I had a 3 partition raid5 cluster to which I added  a 4th disk
>>>>>>> and
>>>>>>> tried to grow the raid5 by adding the partition on the 4th disk
>>>>>>> and
>>>>>>> then growing it. Unfortunately since another sync task was
>>>>>>> happening
>>>>>>> on the same disks, the operation to move the critical section did
>>>>>>> not
>>>>>>> complete before the machine was shutdown by the UPS (in control
>>>>>>> not a
>>>>>>> crash) due to low battery.
>>>>>>>
>>>>>>> Kernel: 2.6.30.4; mdadm (tried 2.6.7 and 3.0)
>>>>>>>
>>>>>>> Now, only 1 of my 3 partitions has the superblock and the other 2
>>>>>>> and
>>>>>>> the 4th new one does not have anything.
>>>>>>
>>>>>> It is very strange that only one partition has a superblock.
>>>>>> I cannot imagine any way that could have happened short of
>>>>>> changing
>>>>>> the partition tables or deliberately destroying them.
>>>>>> I feel the need to ask "are you sure" though presumably you are or
>>>>>> you wouldn't have said so...
>>>>>
>>>>>
>>>>> I am positive (at least from the output of mdadm that no superblock
>>>>> exists on the other partitions). I am also sure that I am not
>>>>> fumbling
>>>>> on the partition device names.
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Here is the output of a few mdadm commands.
>>>>>>>
>>>>>>> $mdadm --misc --examine /dev/sdd5
>>>>>>> /dev/sdd5:
>>>>>>>        Magic : a92b4efc
>>>>>>>      Version : 1.2
>>>>>>>  Feature Map : 0x4
>>>>>>>   Array UUID : 495f6668:f1e12d10:99520f92:7619b487
>>>>>>>         Name : GATEWAY:raid5_280G  (local to host GATEWAY)
>>>>>>> Creation Time : Fri Jul 31 23:05:48 2009
>>>>>>>   Raid Level : raid5
>>>>>>> Raid Devices : 4
>>>>>>>
>>>>>>> Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
>>>>>>>   Array Size : 1758296832 (838.42 GiB 900.25 GB)
>>>>>>> Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
>>>>>>>  Data Offset : 272 sectors
>>>>>>> Super Offset : 8 sectors
>>>>>>>        State : active
>>>>>>>  Device UUID : 754ae1cf:bbee0582:f660ec89:a88800d3
>>>>>>>
>>>>>>> Reshape pos'n : 0
>>>>>>> Delta Devices : 1 (3->4)
>>>>>>
>>>>>> It certainly looks like it didn't get very far.  We cannot
>>>>>> know from this for certain.
>>>>>> mdadm should have copied the first 4 chunks (256K) to somewhere
>>>>>> near the end of the new device, then allowed the reshape to
>>>>>> continue.
>>>>>> It is possible that the reshape had written to some of these early
>>>>>> blocks.  If it did we need to recover that backed-up data.  I
>>>>>> should
>>>>>> probably add functionality to mdadm to find and recover such a
>>>>>> backup....
>>>>>>
>>>>>> For now your best bet is to simply try to recreate the array.
>>>>>> i.e something like
>>>>>>
>>>>>> mdadm -C /dev/md0 -l5 -n3 -e 1.2 --name "raid5_280G" --assume-
>>>>>> clean \
>>>>>>      /dev/sdc5 /dev/sdd5 /dev/sde5
>>>>>>
>>>>>> You need to make sure that you get the right devices in the right
>>>>>> order.  From the information you gave I only know for certain that
>>>>>> /dev/sdd5 is the middle of the three.
>>>>>>
>>>>>> This will write new superblocks and assemble the array but will
>>>>>> not
>>>>>> change any of the data.  You can then access the array read-only
>>>>>> and see if the data looks like it is all there.  If it isn't, stop
>>>>>> the array and try to work out why.
>>>>>> If it is, you can try to grow the array again, this time with a
>>>>>> more
>>>>>> reliable power supply ;-)
>>>>>>
>>>>>> Speaking of which... just how long was it before when you started
>>>>>> the
>>>>>> grow and when the power shut off.  It really shouldn't be more
>>>>>> than
>>>>>> a few seconds, even if other things are happening on the system.
>>>>>> (normally it would be a few hundred milliseconds at most).
>>>>>>
>>>>>> Good luck,
>>>>>> NeilBrown
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>  Update Time : Fri Aug 21 09:55:38 2009
>>>>>>>     Checksum : e18481fb - correct
>>>>>>>       Events : 13581
>>>>>>>
>>>>>>>       Layout : left-symmetric
>>>>>>>   Chunk Size : 64K
>>>>>>>
>>>>>>>  Array Slot : 4 (0, failed, failed, 2, 1, 3)
>>>>>>> Array State : uUuu 2 failed
>>>>>>>
>>>>>>> $mdadm --assemble --scan
>>>>>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>>>>>
>>>>>>> I am positive that none of the actual growing steps even
>>>>>>> started so
>>>>>>> my
>>>>>>> data 'should' be safe as long as I can recreate the superblocks,
>>>>>>> right?
>>>>>>>
>>>>>>> As always, appreciate the help of the open source community.
>>>>>>> Thanks!!
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Anshuman
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>>>>>> raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-
>>>>>>> info.html
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

