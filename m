From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 14 Sep 2013 22:43:22 +0200
Message-ID: <5234CA6A.3070305@arcor.de>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>	<20130914064305.0baadc69@notabene.brown>	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>	<20130914203800.385466b2@notabene.brown>	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com> <CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/14/2013 05:06 PM, Francis Moreau wrote:
> Martin,
> 
> On Sat, Sep 14, 2013 at 4:33 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> On Sat, Sep 14, 2013 at 12:38 PM, NeilBrown <neilb@suse.de> wrote:
>>> On Sat, 14 Sep 2013 00:35:47 +0200 Francis Moreau <francis.moro@gmail.com>
>>> wrote:
> 
> [...]
> 
>>>
>>> BTW I think I've fixed the issue with mdadm -R /dev/md125 for DDF.
>>> Try the latest git.
>>
>> It seems it fixes the issue: mdmon is now correctly started with a
>> degraded DDF array.
>>
>> However, after using the system with only one disk (sda), sdb is now
>> outdated. I rebooted the system with 2 disks but mdadm doesn't seem to
>> notice that sdb is outdated:
>>
>> # mdadm -I /dev/sda
>> mdadm: container /dev/md/ddf0 now has 1 device
>> mdadm: /dev/md/array1_0 assembled with 1 device but not started
>> # mdadm -I /dev/sdb
>> mdadm: container /dev/md/ddf0 now has 2 devices
>> mdadm: Started /dev/md/array1_0 with 2 devices (1 new)
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md126 : active (auto-read-only) raid1 sdb[1] sda[0]
>>       2064384 blocks super external:/md127/0 [2/2] [UU]
>>
>> md127 : inactive sdb[1](S) sda[0](S)
>>       65536 blocks super external:ddf
>>
>> So this time mdadm fails to kick out non fresh disk (when using '-I')
>> but with DDF.
>>
> 
> Maybe you have an idea on why mdadm doesn't notice that sdb is
> outdated in that case (DDF) ?

It's a bug. I am sending a patch soon. Thanks a lot.

Martin


> 
> Thanks

