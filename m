From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Growing raid 5: Failed to reshape
Date: Sat, 22 Aug 2009 08:11:13 +0530
Message-ID: <121580D1-2950-43FB-AD1F-B235D1160932@gmail.com>
References: <5c45fce80908211231v9238a12i3829ad5d1b107df5@mail.gmail.com> <2735df411d9ed83a9d11664f595d6dfc.squirrel@neil.brown.name>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2735df411d9ed83a9d11664f595d6dfc.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,
  Thanks for your input. Its great to have some hand holding when your  
heart is stuck in your mouth.

Here is some more explanation:

I have another raid array on the same disks in different partitions   
and there was a grow operation happening on those also at time (which  
has completed splendidly after the power outage). From what I have  
observed so far, when there is heavy activity on the disk due to 1  
array, the kernel delays puts the other tasks in a DELAYED status. ( I  
have done it this way because I have 4 different sized disks purchased  
over time)

I had given the grow command before I realized that the other grow  
operation had not completed on the other partitions.

* The critical section status from mdam was stuck (apparently waiting  
for the grow on the other partitions to complete). Hence it did not  
complete as quickly as it should have.
* Because it kept waiting for the other md operations on the disk to  
complete, the critical section didn't get written (my guess, its also  
possible that the disk was so busy that it took more than an hour but  
unlikely)

Please tell me if you this additional info changes our approach to try  
and fix this?

I do have a UPS with an hour of backup but recently moved back to my  
home country, India where power supply will probably *NEVER* ever be  
continuos  enough for a long md operation :). Hence, I'm definitely  
one to vote for recoverable moves (which mdadm and the kernal have  
been pretty good at so far)

Thanks,
Anshuman

On 22-Aug-09, at 3:00 AM, NeilBrown wrote:

> On Sat, August 22, 2009 5:31 am, Anshuman Aggarwal wrote:
>> Hi all,
>>
>> Here is my problem and configuration. :
>>
>> I had a 3 partition raid5 cluster to which I added  a 4th disk and
>> tried to grow the raid5 by adding the partition on the 4th disk and
>> then growing it. Unfortunately since another sync task was happening
>> on the same disks, the operation to move the critical section did not
>> complete before the machine was shutdown by the UPS (in control not a
>> crash) due to low battery.
>>
>> Kernel: 2.6.30.4; mdadm (tried 2.6.7 and 3.0)
>>
>> Now, only 1 of my 3 partitions has the superblock and the other 2 and
>> the 4th new one does not have anything.
>
> It is very strange that only one partition has a superblock.
> I cannot imagine any way that could have happened short of changing
> the partition tables or deliberately destroying them.
> I feel the need to ask "are you sure" though presumably you are or
> you wouldn't have said so...


I am positive (at least from the output of mdadm that no superblock  
exists on the other partitions). I am also sure that I am not fumbling  
on the partition device names.

>
>>
>> Here is the output of a few mdadm commands.
>>
>> $mdadm --misc --examine /dev/sdd5
>> /dev/sdd5:
>>          Magic : a92b4efc
>>        Version : 1.2
>>    Feature Map : 0x4
>>     Array UUID : 495f6668:f1e12d10:99520f92:7619b487
>>           Name : GATEWAY:raid5_280G  (local to host GATEWAY)
>>  Creation Time : Fri Jul 31 23:05:48 2009
>>     Raid Level : raid5
>>   Raid Devices : 4
>>
>> Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
>>     Array Size : 1758296832 (838.42 GiB 900.25 GB)
>>  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
>>    Data Offset : 272 sectors
>>   Super Offset : 8 sectors
>>          State : active
>>    Device UUID : 754ae1cf:bbee0582:f660ec89:a88800d3
>>
>>  Reshape pos'n : 0
>>  Delta Devices : 1 (3->4)
>
> It certainly looks like it didn't get very far.  We cannot
> know from this for certain.
> mdadm should have copied the first 4 chunks (256K) to somewhere
> near the end of the new device, then allowed the reshape to continue.
> It is possible that the reshape had written to some of these early
> blocks.  If it did we need to recover that backed-up data.  I should
> probably add functionality to mdadm to find and recover such a  
> backup....
>
> For now your best bet is to simply try to recreate the array.
> i.e something like
>
>  mdadm -C /dev/md0 -l5 -n3 -e 1.2 --name "raid5_280G" --assume-clean \
>        /dev/sdc5 /dev/sdd5 /dev/sde5
>
> You need to make sure that you get the right devices in the right
> order.  From the information you gave I only know for certain that
> /dev/sdd5 is the middle of the three.
>
> This will write new superblocks and assemble the array but will not
> change any of the data.  You can then access the array read-only
> and see if the data looks like it is all there.  If it isn't, stop
> the array and try to work out why.
> If it is, you can try to grow the array again, this time with a more
> reliable power supply ;-)
>
> Speaking of which... just how long was it before when you started the
> grow and when the power shut off.  It really shouldn't be more than
> a few seconds, even if other things are happening on the system.
> (normally it would be a few hundred milliseconds at most).
>
> Good luck,
> NeilBrown
>
>
>>
>>    Update Time : Fri Aug 21 09:55:38 2009
>>       Checksum : e18481fb - correct
>>         Events : 13581
>>
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>>
>>    Array Slot : 4 (0, failed, failed, 2, 1, 3)
>>   Array State : uUuu 2 failed
>>
>> $mdadm --assemble --scan
>> mdadm: Failed to restore critical section for reshape, sorry.
>>
>> I am positive that none of the actual growing steps even started so  
>> my
>> data 'should' be safe as long as I can recreate the superblocks,
>> right?
>>
>> As always, appreciate the help of the open source community. Thanks!!
>>
>> Thanks,
>> Anshuman
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

