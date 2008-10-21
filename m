From: Raz <raziebe@gmail.com>
Subject: Re: HELP! my raid5 ate my data!
Date: Tue, 21 Oct 2008 18:54:59 +0200
Message-ID: <5d96567b0810210954o668ff66eg75b7ab30254980cc@mail.gmail.com>
References: <9512192b0810210915xa27061bkdc37e212f17c944b@mail.gmail.com>
	 <5d96567b0810210930r5bc4d068mef57dcfb4a237603@mail.gmail.com>
	 <9512192b0810210940v77675287od420f7ea36fbf2de@mail.gmail.com>
	 <5d96567b0810210944v4e50a52csfbde7df00f1fcd9e@mail.gmail.com>
	 <9512192b0810210946o31a451a5i91aa3f03e3b919a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9512192b0810210946o31a451a5i91aa3f03e3b919a9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Morgan Wahl <morgy.wahl@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I these problems I :
1. remove the hard drive from the computer.
2. boot.
3. if raid assembles I mount it. if is is not assembled i mount manually.
I never use ro. only rw.

On Tue, Oct 21, 2008 at 6:46 PM, Morgan Wahl <morgy.wahl@gmail.com> wrote:
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>      58604736 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>
> unused devices: <none>
>
> the raid seems to still activate whenever i start my computer, that
> why it's active right now.
>
> On Tue, Oct 21, 2008 at 12:44 PM, Raz <raziebe@gmail.com> wrote:
>> cat /proc/mdstats.
>>
>> On Tue, Oct 21, 2008 at 6:40 PM, Morgan Wahl <morgy.wahl@gmail.com> wrote:
>>> these lines are the only uncommented ones in mdadm.conf:
>>> DEVICE /dev/sd[abcd]1
>>> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
>>>
>>> mdadm -Q /dev/md0
>>> mdadm --examine /dev/sda1
>>> mdadm --examine /dev/sdb1
>>> mdadm --examine /dev/sdc1
>>> mdadm --examine /dev/sdd1
>>>
>>> mdadm /dev/md0 --remove /dev/sdc1
>>>
>>> mdadm -A /dev/md0
>>>
>>> mdadm --readonly /dev/md0
>>>
>>> mount /dev/md0 /mnt/temp
>>> (this return an error)
>>> e2fsck -n /dev/md0
>>> (lots of errors)
>>>
>>> On Tue, Oct 21, 2008 at 12:31 PM, Raz <raziebe@gmail.com> wrote:
>>>> Please provide the exact sequence of operations. what mdadm command
>>>> did you use at each phase ? Did you try to mount it rw ?
>>>>
>>>> On Tue, Oct 21, 2008 at 6:15 PM, Morgan Wahl <morgy.wahl@gmail.com> wrote:
>>>>> yesterday I had a problem with the SATA bus one of my drives is on,
>>>>> which i've since fixed. I have a raid5 on four 20GB partitions (each
>>>>> on it's own drive, of course). The one that failed was sdc1. when i
>>>>> rebooted, the raid was no longer active (according to `mdadm -Q
>>>>> /dev/md0`).  I ran `mdadm --examine ` on each drive. For sdc1 it said
>>>>> everything was fine, but for the other three drives sdc1 was marked as
>>>>> failed. I've never recovered from a drive failure before and I don't
>>>>> think I did it correctly. I removed sdc1 from the raid and then
>>>>> incrementally added it again. (I now realize I should've started the
>>>>> raid with it removed and done a backup.) I started the raid again with
>>>>> all four drives, and put it in readonly mode and tried to mount it,
>>>>> but it presumably still isn't set up right since it refuses to mount
>>>>> and `e2fsck -n` returns myriad errors.
>>>>>
>>>>> Did starting the raid with the bad disk destroy everything? did it
>>>>> only destory a little (assuming fsck can get the filesystem back into
>>>>> a useable state)? How can I even find out what's wrong? I do have a
>>>>> separate terabyte disk that i've copied images of the disks to, so I
>>>>> can perform experiment on them, but I'm not sure what to do.
>>>>>
>>>>> Help! Please!
>>>>>
>>>>>   -Morgan
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
