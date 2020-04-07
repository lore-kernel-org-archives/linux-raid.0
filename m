From: Alexander Shenkin <al@shenkin.org>
Subject: Re: Raid-6 cannot reshape
Date: Tue, 7 Apr 2020 12:46:59 +0100
Message-ID: <618f5171-785f-09b0-8748-d2549d22c0ab@shenkin.org>
References: <24a0ef04-46a9-13ee-b8cb-d1a0a5b939fb@shenkin.org>
 <6b9b6d37-6325-6515-f693-0ff3b641a67a@shenkin.org>
 <3135fb29-cfaa-d8ac-264d-fd3110217370@shenkin.org>
 <CAAMCDecyr4R_z3-E8HYwYM4CyQtAY_nBmXdvvMkTgZCcCp7MjQ@mail.gmail.com>
 <5E8B5865.9060107@youngman.org.uk>
 <08d66411-5045-56e1-cbad-7edefa94a363@turmel.org>
 <945332b3-6a47-c2b3-7d1e-70a44f6fd370@shenkin.org>
 <b9bb796e-08cd-e10a-d345-992e5f3abea7@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b9bb796e-08cd-e10a-d345-992e5f3abea7@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Roger Heflin <rogerheflin@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 4/7/2020 12:28 PM, Phil Turmel wrote:
> Hi Allie,
> 
> On 4/7/20 6:25 AM, Alexander Shenkin wrote:
>>
>>
>> On 4/6/2020 9:34 PM, Phil Turmel wrote:
>>> On 4/6/20 12:27 PM, Wols Lists wrote:
>>>> On 06/04/20 17:12, Roger Heflin wrote:
>>>>> When I looked at your detailed files you sent a few days ago, all of
>>>>> the reshapes (on all disks) indicated that they were at position 0, so
>>>>> it kind of appears that the reshape never actually started at all and
>>>>> hung immediately which is probably why it cannot find the critical
>>>>> section, it hung prior to that getting done.   Not entirely sure how
>>>>> to undo a reshape that failed like this.
>>>>
>>>> This seems quite common. Search the archives - it's probably something
>>>> like --assemble --revert-reshape.
>>>
>>> Ah, yes.  I recall cases where mdmon wouldn't start or wouldn't open the
>>> array to start moving the stripes, so the kernel wouldn't advance.
>>> SystemD was one of the culprits, I believe, back then.
>>
>> Thanks all.
>>
>> So, is the following safe to run, and a good idea to try?
>>
>> mdadm --assemble --update=revert-reshape /dev/md127 /dev/sd[a-g]3
> 
> Yes.
> 
>> And if that doesn't work, add a force? >
>> mdadm --assemble --force --update=revert-reshape /dev/md127 /dev/sd[a-g]3
> 
> Yes.
> 
>> And adding --invalid-backup if it complains about backup files?
> 
> Yes.
> 
>> Thanks,
>> Allie
> 
> Phil
> 

Thanks Phil,

The --invalid-backup parameter was necessary to get this up and running.
 It's now up with the 7th disk as a spare.  Shall I run fsck now, or can
I just try to grow again?

proposed grow operation:
> mdadm --grow -raid-devices=7 --backup-file=/dev/usb/grow_md127.bak
/dev/md127
> mdadm --stop /dev/md127
> umount /dev/md127 # not sure if this is necessary
> resize2fs /dev/md127

Thanks,
Allie

assemble operation results:

root@ubuntu-server:/home/ubuntu-server# mdadm --assemble
--invalid-backup --update=revert-reshape /dev/md127 /dev/sd[a-g]3
mdadm: device 12 in /dev/md127 has wrong state in superblock, but
/dev/sdg3 seems ok
mdadm: /dev/md127 has been started with 6 drives and 1 spare.

root@ubuntu-server:/home/ubuntu-server# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md127 : active raid6 sda3[6] sdg3[9](S) sde3[7] sdf3[8] sdd3[5] sdc3[2]
sdb3[4]
      11680755712 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/6] [UUUUUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

md126 : active (auto-read-only) raid1 sdf1[8] sde1[7] sdg1[9] sda1[6]
sdd1[5] sdc1[2] sdb1[4]
      1950656 blocks super 1.2 [7/7] [UUUUUUU]

unused devices: <none>
