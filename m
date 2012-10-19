From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: raid device gone underneath array
Date: Fri, 19 Oct 2012 04:03:15 +0000 (UTC)
Message-ID: <slrnk81k84.am0.chris@chris.onthe.net.au>
References: <CALFpzo4gLGzGWLRdVK7bZnYr3hbR7xOgn402UTP2_7UpRE8j6g@mail.gmail.com>
 <50809DC5.60106@websitemanagers.com.au>
Reply-To: chris@onthe.net.au
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-10-19, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> On 19/10/12 11:01, Marcus Sorensen wrote:
>> I've been using software raid to mirror two devices, and recently one
>> of the drives went AWOL.
>>
>> md1 : active raid1 sdm[0] sdc[1](F)
>>       12884900728 blocks super 1.2 [2/1] [U_]
>>       bitmap: 1/96 pages [4KB], 65536KB chunk
>>
>> However, md1 froze, and in looking at the logs I saw this:
>>
>> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
>> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
>>
>> [root(marcus)@sanmirror3-01 ~]# mdadm --manage /dev/md1 --remove /dev/sdc
>> mdadm: cannot find /dev/sdc: No such file or directory
>>
>> /dev/sdc was already gone! The /sys/block was already removed, no
>> reference to it in /proc/scsi/scsi. So md1 was destined to sit there
>> forever. So I rebooted and started up the degraded array.
>>
>> Using kernel 3.6.2 from kernel.org
>
> I've also had this problem, I think the kernel notices the device is
> gone, and removes it before MD notices the problem and removes it from
> the array. I managed to resolve this without a reboot by manually
> creating the device in /dev/sdc1 or whatever, and then doing mdadm
> --manage /dev/md0 --remove /dev/sdc1

Or you could simply do:

mdadm --manage /dev/md1 -r failed

