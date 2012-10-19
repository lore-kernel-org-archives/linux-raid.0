From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: raid device gone underneath array
Date: Fri, 19 Oct 2012 09:45:24 -0600
Message-ID: <CALFpzo6uyyLmS3dCkyqTGEv-Ro4hMYpkfo+xDeQnuUPUToFvmA@mail.gmail.com>
References: <CALFpzo4gLGzGWLRdVK7bZnYr3hbR7xOgn402UTP2_7UpRE8j6g@mail.gmail.com>
	<50809DC5.60106@websitemanagers.com.au>
	<slrnk81k84.am0.chris@chris.onthe.net.au>
	<D1C1909A-24CD-48C1-8C6F-2EEA81C50459@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D1C1909A-24CD-48C1-8C6F-2EEA81C50459@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So in my history I also have:

mdadm --manage /dev/md1 --remove detached
mdadm --manage /dev/md1 --remove failed

Note that also the device is already marked as failed. I think the
speculation is that the disk was removed from the system and
references cleaned up without md realizing it. Therefore any
subsequent code that tries to act upon /dev/sdc gets an ENOENT or
similar, and md assumes the device is busy. Or it was currently doing
something at the time the disk was removed, which is now going to
block indefinitely.

On Thu, Oct 18, 2012 at 10:29 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 18, 2012, at 10:03 PM, Chris Dunlop wrote:
>
>> On 2012-10-19, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
>>> On 19/10/12 11:01, Marcus Sorensen wrote:
>>>> I've been using software raid to mirror two devices, and recently one
>>>> of the drives went AWOL.
>>>>
>>>> md1 : active raid1 sdm[0] sdc[1](F)
>>>>      12884900728 blocks super 1.2 [2/1] [U_]
>>>>      bitmap: 1/96 pages [4KB], 65536KB chunk
>>>>
>>>> However, md1 froze, and in looking at the logs I saw this:
>>>>
>>>> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
>>>> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
>>>>
>>>> [root(marcus)@sanmirror3-01 ~]# mdadm --manage /dev/md1 --remove /dev/sdc
>>>> mdadm: cannot find /dev/sdc: No such file or directory
>>>>
>>>> /dev/sdc was already gone! The /sys/block was already removed, no
>>>> reference to it in /proc/scsi/scsi. So md1 was destined to sit there
>>>> forever. So I rebooted and started up the degraded array.
>>>>
>>>> Using kernel 3.6.2 from kernel.org
>>>
>>> I've also had this problem, I think the kernel notices the device is
>>> gone, and removes it before MD notices the problem and removes it from
>>> the array. I managed to resolve this without a reboot by manually
>>> creating the device in /dev/sdc1 or whatever, and then doing mdadm
>>> --manage /dev/md0 --remove /dev/sdc1
>>
>> Or you could simply do:
>>
>> mdadm --manage /dev/md1 -r failed
>
> That's if md knows it's failed. If the speculation is correct, that the kernel bounced the disk before md determined it was failed, then I think the commands are:
>
> mdadm --manage /dev/md1 -f detached
> mdadm --manage /dev/md1 -r detached
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
