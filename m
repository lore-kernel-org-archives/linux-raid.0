From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 05 Dec 2013 17:48:16 +0100
Message-ID: <52A0AE50.2040506@fastmail.fm>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>	 <52A08162.3080706@fastmail.fm>	 <BLU0-SMTP2081DE3677BA1FD887C35BC98D70@phx.gbl>	 <52A08E50.30609@fastmail.fm>	 <BLU0-SMTP3325A7BDB48F7600841601398D70@phx.gbl>	 <52A0A306.9070401@fastmail.fm> <BLU0-SMTP2166AD61B636049F4A8A8798D70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP2166AD61B636049F4A8A8798D70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/05/2013 05:36 PM, Wilson Jonathan wrote:
> On Thu, 2013-12-05 at 17:00 +0100, Bernd Schubert wrote:
>> On 12/05/2013 04:48 PM, Wilson Jonathan wrote:
>>> Still the same problem, lists non partitioned space, unknown, unknown,
>>> un partitioned.
>>>
>>> I wonder if the problem is because i'm not re-creating it with bitmap
>>> file, which is listed as starting 8 sectors from superblock, so with it
>>> not being there the partition table is being read from this space and
>>> not further along the space.
>>
>> The bitmap is supposed to be in the gap between data and superblock.
>>
>>>
>>> Infact, looking at the re-created superblock there is a change...
>>>
>>> /dev/sde6:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x0
>>>        Array UUID : 1c413162:25c7b4af:7b305603:1ce49fed
>>>              Name : BorgCUBE:5  (local to host BorgCUBE)
>>>     Creation Time : Thu Dec  5 00:28:11 2013
>>>        Raid Level : raid6
>>>      Raid Devices : 6
>>>
>>>    Avail Dev Size : 1833309583 (874.19 GiB 938.65 GB)
>>>        Array Size : 3666617344 (3496.76 GiB 3754.62 GB)
>>>     Used Dev Size : 1833308672 (874.19 GiB 938.65 GB)
>>>       Data Offset : 262144 sectors
>>>      Super Offset : 8 sectors
>>>             State : clean
>>>       Device UUID : de841586:f82b22ed:1a234ae7:57fbb36a
>>>
>>>       Update Time : Thu Dec  5 00:28:11 2013
>>>          Checksum : 9dcbeec1 - correct
>>>            Events : 0
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 64K
>>>
>>> The "data offset" is 262144 where as the sdc (original) is 2048
>>
>> Seems to be a new mdadm version with different default values. Another
>> reason not to use '--create' unless there is really no other way. Try to
>> add --data-offset=1M.
>
> My version of mdadm does not have --data-offset...
>
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --create
> --assume-clean --level=6 --raid-devices=6 --chunk=64
> --data-offset=1M /dev/md5 /dev/sdd6 /dev/sde6 /dev/sdf6 /dev/sda6
> missing missing
> mdadm: unrecognized option '--data-offset=1M'
>
> I also double checked the original, pre-corrupted, examine and found
> that /dev/sdb6 had 1928 sectors (was a new 3tb drive, using a partition
> on it, which had a slightly larger size, to replace the original
> partition on a 1tb disk)
>
> sda6:3, sdd6:0, sde6:1, sdf6:2 are all at 2048 sectors, so if I can
> somehow create md5 using just these 4 disks it should be ok even if it
> has no redundancy, assuming it works and I can get hold of a mdadm with

Sorry, I don't understand what you mean. sdb6 starts at 1928 sectors? 
Assuming you have either 4k or 512B hw-sector disks that shouldn't make 
a difference for alignment. If at all, I would correct it only once I 
would have full redundancy.

> offset (I have git, and have built from source before if it comes to
> that... but a binary would be more helpful, or perhaps a mdadm that had
> the original 2048 offset?) then clear the superblock from b and c and
> re-add them to re-build the redundancy.


Well, I could probably build mdadm for you (if I should have the chroot 
matching your distribution), but can't you just download an older or a 
recent version for your distribution?


Cheers,
Bernd

