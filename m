From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 19:52:14 +1000
Message-ID: <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57971D3C.8040602@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 26/07/2016 18:20, David C. Rankin wrote:
> On 07/26/2016 12:28 AM, David C. Rankin wrote:
>> On 07/25/2016 11:18 PM, Adam Goryachev wrote:
>>> It sounds/looks like you partitioned the two drives with GPT, and then used the
>>> entire drive for the RAID, which probably overwrote at least one of the GPT
>>> entries. Now gparted has overwritten part of the disk where mdadm keeps it's data.
>>>
>>> So, good news, assuming you really haven't touched sdc, then it should still be
>>> fine. Try the following:
>>> mdadm --manage --stop /dev/md4
>>>
>>> Check it has stopped cat /proc/mdstat and md4 should not appear at all.
>>>
>>> Now re-assemble with only the one working member:
>>> mdadm --assemble --force /dev/md4 /dev/sdc
>>>
>>> If you are lucky, you will then be able to mount /dev/md4 as needed.
>>>
>>> If not, please provide:
>>> Output of the above mdadm --assemble
>>> Logs from syslog/dmesg in relation to the assembly attempt
>>> mdadm --query /dev/sdc
>>> mdadm --query /dev/sdc1
>>> mdadm --query /dev/sdd
>>> mdadm --query /dev/sdd1
>>> mdadm --detail /dev/md4 (after the assemble above).
>>>
>>> Being RAID1, it shouldn't be too hard to recover your data, just need to get
>>> some more information about the current state.
>>>
>>> Once you have the array started, your next step is to avoid the problem in
>>> future. So send through the above details, and then additional advice can be
>>> provided. Generally I've seen most people create the partition and then use the
>>> partition for RAID, that way the partition is marked as in-use by the array. The
>>> alternative is to wipe the beginning and end of the drive (/dev/zero) and then
>>> re-add to the array. Once synced, you can repeat with the other drive. The
>>> problem is if something (eg your BIOS) decides to "initialise" the drive for
>>> you, then it will overwrite your data/mdadm data.
>>>
>>> Hope the above helps.
>>>
>>> Regards,
>>> Adam
>> Adam,
>>
>>    Thank you! There are a lot of things in life I'm good at, speaking mdadm
>> fluently, when I deal with it once every 2 years -- isn't one of them.
>>
>>    /dev/sdc was still OK and did assemble in degraded mode just fine:
>>
>> # mdadm --manage --stop /dev/md4
>> mdadm: stopped /dev/md4
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md1 : active raid1 sdb6[1] sda6[0]
>>        52396032 blocks super 1.2 [2/2] [UU]
>>
>> md0 : active raid1 sdb5[1] sda5[0]
>>        511680 blocks super 1.2 [2/2] [UU]
>>
>> md3 : active raid1 sdb8[1] sda8[0]
>>        2115584 blocks super 1.2 [2/2] [UU]
>>
>> md2 : active raid1 sdb7[1] sda7[0]
>>        921030656 blocks super 1.2 [2/2] [UU]
>>        bitmap: 0/7 pages [0KB], 65536KB chunk
>>
>> # mdadm --assemble --force /dev/md4 /dev/sdc
>> mdadm: /dev/md4 has been started with 1 drive (out of 2).
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md4 : active raid1 sdc[0]
>>        2930135488 blocks super 1.2 [2/1] [U_]
>>        bitmap: 0/22 pages [0KB], 65536KB chunk
>>
>> Up and running, mounted with all data in tact (well, at least until I hit the
>> address in the partition table where the mdadm data overwrote part of the
>> partition table -- I see a Segmentation Fault coming)
I don't think you will have any problem here. Please let us know if you do.
>>
>> So I take it having one large raid1 filesystem created out of a primary
>> partition on a disk is a bad idea? My goal in doing so was to create the largest
>> block of storage out of the two drives I could (saving 100M unpartitioned at the
>> end in case of drive failure and disk size variance)
No, I'm saying that is an excellent idea, and it is exactly what I 
always do. The problem is that you created the single large primary 
partition, and then used the raw drive for the raid array instead of 
using the partition.
>> I take it adding sdd back into md4 is not a good idea at this point.
Remember the difference between the drive and the partition. sdd is the 
entire drive, that is what you will create partitions on. sdd1 is the 
first partition that you will use for RAID. So, you can add sdd1 to md4 
once you are sure the partitions are configured correctly. You might 
also zero out the beginning/end of the partition just to ensure there is 
no old mdadm data there.
>> Do I implement a new partition scheme on sdd, and then "create" a new single
>> disk raid1 array (say md5), mount it on some temporary mount point, copy the
>> data, then stop both, assemble what was sdd/md5 as md4 then nuke the partitions
>> on sdc, repartition sdc (as I did sdd) and then add sdc to the new array with
>> sdd? (or I could dump the data to some temp location, nuke both sdc and sdd,
>> repartition, recreate, assemble and then copy back to the new fully functional
>> array -- that sounds better)
>>
>> What are your thoughts on the partition scheme and the approach outlined above?
>> And thank you again for steering me straight and saving the data.
The main problem you will have is that the size of sdd1 will be smaller 
than sdc, because the partition table (GPT) will take up some space. So 
you may indeed need to either reduce the size of the FS, reduce the size 
of md4, before you can add sdd1 as the other half of the mirror.
The other option is to do as you say, create a new RAID1 mirror between 
sdd1 and missing, format, mount, copy data, then stop md4, clear mdadm 
data from sdc, partition sdc properly, add sdc1 to md5, wait for resync. 
When done, if you want you can umount, stop md5, assemble as md4, and 
then mount.
Remember to update mdadm.conf afterwards.

>>
>>
> Adam,
>
>    Here is the detail on md4, if is makes any difference on your words of wisdom.
>
> # mdadm --query /dev/md4
> /dev/md4: 2794.39GiB raid1 2 devices, 0 spares. Use mdadm --detail for more detail.
>
> # mdadm --detail /dev/md4
> /dev/md4:
>          Version : 1.2
>    Creation Time : Mon Mar 21 02:27:21 2016
>       Raid Level : raid1
>       Array Size : 2930135488 (2794.39 GiB 3000.46 GB)
>    Used Dev Size : 2930135488 (2794.39 GiB 3000.46 GB)
>     Raid Devices : 2
>    Total Devices : 1
>      Persistence : Superblock is persistent
>
>    Intent Bitmap : Internal
>
>      Update Time : Tue Jul 26 01:12:27 2016
>            State : clean, degraded
>   Active Devices : 1
> Working Devices : 1
>   Failed Devices : 0
>    Spare Devices : 0
>
>             Name : valkyrie:4  (local to host valkyrie)
>             UUID : 6e520607:f152d8b9:dd2a3bec:5f9dc875
>           Events : 4240
>
>      Number   Major   Minor   RaidDevice State
>         0       8       32        0      active sync   /dev/sdc
>         -       0        0        1      removed
>
> And the last entry in mdadm.conf assembling/activating the array:
>
> # tail -n 2 /etc/mdadm.conf
> ARRAY /dev/md3 metadata=1.2 name=archiso:3 UUID=8b37af66:b34403aa:fa4ce6f1:5eb4b7c8
> ARRAY /dev/md4 metadata=1.2 name=valkyrie:4 UUID=6e520607:f152d8b9:dd2a3bec:5f9dc875
>
> Thanks again!
>
>
All that just confirms that you used the entire drive instead of the 
partition. So one more time, please be careful to notice the difference, 
sdc is the full drive, sdc1 is the first partition on the drive, sdc2 
would be the second, etc...

Regards,
Adam

