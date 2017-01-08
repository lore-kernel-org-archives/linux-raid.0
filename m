From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Sun, 8 Jan 2017 14:31:15 +0100
Message-ID: <2717981a-4308-3f7b-15c6-f384a41fd445@gmail.com>
References: <585D6C34.2020908@gmail.com>
 <20170104223015.cr6vtyhxuwxrg76g@kernel.org>
 <e56edc2b-f2ad-2ab1-4184-5d7cad80085a@gmail.com>
 <20170105193745.qnmqsussxy7nasdn@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170105193745.qnmqsussxy7nasdn@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xen.org, linux-raid@vger.kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

Hello,

Replies below + :
- I don't know if this can help but after the crash, when the system 
reboots, the Raid 5 stack is re-synchronizing
[   37.028239] md10: Warning: Device sdc1 is misaligned
[   37.028541] created bitmap (15 pages) for device md10
[   37.030433] md10: bitmap initialized from disk: read 1 pages, set 59 
of 29807 bits

- Sometimes the kernel completely crash (lost serial + network 
connection), sometimes only got the "BUG" dump, but still have network 
access (but a reboot is impossible, need to reset the system).

- You can find blktrace here (while running fio), I hope it's complete 
since the end of the file is when the kernel crashed : 
https://goo.gl/X9jZ50

Thanks,
MasterPrenium

Le 05/01/2017 à 20:37, Shaohua Li a écrit :
> On Thu, Jan 05, 2017 at 03:16:53PM +0100, MasterPrenium wrote:
>> Hi Shaohua,
>>
>> Thanks for your reply.
>>
>> Let me explain my "huge". For example, if I'm making a low rate i/o stream,
>> I don't get a crash (<1MB written / sec) with random i/o, but if I'm making
>> a random I/O of about 20MB/sec, the kernel crashes in a few minutes (for
>> example, making an rsync, or even synchronising my DRBD stack is causing the
>> crash).
>> I don't know if this can help, but in most of case, when the kernel crashes,
>> after a reboot, my raid 5 stack is re-synchronizing.
>>
>> I'm not able to reproduce the crash with a raw RAID5 stack (with dd/fio
>> ...).
>>
>> It seems I need to stack filesystems to help reproduce it:
>>
>> Here is a configuration test, command lines to explain (the way I'm able to
>> reproduce the crash). Everything is done in dom0.
>> - mdadm --create /dev/md10 --raid-devices=3 --level=5 /dev/sdc1 /dev/sdd1
>> /dev/sde1
>> - mkfs.btrfs /dev/md10
>> - mkdir /tmp/btrfs /mnt/XenVM /tmp/ext4
>> - mount /dev/md10 /tmp/btrfs
>> - btrfs subvolume create /tmp/btrfs/XenVM
>> - umount /tmp/btrfs
>> - mount /dev/md10 /mnt/XenVM -osubvol=XenVM
>> - truncate /mnt/XenVM/VMTestFile.dat -s 800G
>> - mkfs.ext4 /mnt/XenVM/VMTestFile.dat
>> - mount /mnt/XenVM/VMTestFile.dat /tmp/ext4
>>
>> -> Doing this, doesn't seem to crash the kernel :
>> fio --name=randwrite --ioengine=libaio --iodepth=1 --rw=randwrite
>> --rwmixwrite=95 --bs=1M --direct=1 --size=80G --numjobs=8 --runtime=600
>> --group_reporting --filename=/mnt/XenVM/Fio.dat
>>
>> -> Doing this, is crashing the kernel in a few minutes :
>> fio --name=randwrite --ioengine=libaio --iodepth=1 --rw=randwrite
>> --rwmixwrite=95 --bs=1M --direct=1 --size=80G --numjobs=8 --runtime=600
>> --group_reporting --filename=/tmp/ext4/ext4.dat
>>
>> Note : --direct=1 or --direct=0 doesn't seem to change the behaviour. Also
>> having the raid 5 stack re-synchronizing or already synchronized, doesn't
>> change the behaviour.
>>
>> Here another "crash" : http://pastebin.com/uqLzL4fn
> I'm trying to reproduce, but no success. So
> ext4->btrfs->raid5, crash
> btrfs->raid5, no crash
> right? does subvolume matter? When you create the raid5 array, does adding
> '--assume-clean' option change the behavior? I'd like to narrow down the issue.
> If you can capture the blktrace to the raid5 array, it would be great to hint
> us what kind of IO it is.
>   
Yes Correct.
The subvolume doesn't matter.
-- assume-clean doesn't change the behaviour.
Don't forget that the system needs to be running on xen to crash, 
without (on native kernel) it doesn't crash (or at least, I was not able 
to make it crash).
>> Regarding your patch, I can't find it. Is it the one sent by Konstantin
>> Khlebnikov ?
> Right.
It doesn't help :(. Maybe the crash is happening a little bit later.
>
>> Do you want the "ext4.dat" fio file ? It will be really difficult for me to
>> provide it to you as I've only a poor ADSL network connection.
> Not necessary.
>
> Thanks,
> Shaohua
>
>> Thanks for your help,
>>
>> MasterPrenium
>>
>> Le 04/01/2017 à 23:30, Shaohua Li a écrit :
>>> On Fri, Dec 23, 2016 at 07:25:56PM +0100, MasterPrenium wrote:
>>>> Hello Guys,
>>>>
>>>> I've having some trouble on a new system I'm setting up. I'm getting a kernel BUG message, seems to be related with the use of Xen (when I boot the system _without_ Xen, I don't get any crash).
>>>> Here is configuration :
>>>> - 3x Hard Drives running on RAID 5 Software raid created by mdadm
>>>> - On top of it, DRBD for replication over another node (Active/passive cluster)
>>>> - On top of it, a BTRFS FileSystem with a few subvolumes
>>>> - On top of it, XEN VMs running.
>>>>
>>>> The BUG is happening when I'm making "huge" I/O (20MB/s with a rsync for example) on the RAID5 stack.
>>>> I've to reset system to make it work again.
>>> what did you mean 'huge' I/O (20M/s)? Is it possible you can reproduce the
>>> issue with a raw raid5 raid? It would be even better if you can give me a fio
>>> job file with the issue, so I can easily debug it.
>>>
>>> also please check if upstream patch (e8d7c33 md/raid5: limit request size
>>> according to implementation limits) helps.
>>>
>>> Thanks,
>>> Shaohua

