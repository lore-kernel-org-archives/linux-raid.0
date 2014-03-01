From: Denis Golovan <denis.golovan@gmail.com>
Subject: Re: RAID5 hard freeze
Date: Sat, 1 Mar 2014 16:54:01 +0200
Message-ID: <CAF8FvyxaXNHEAqdsfGfF-j_di9W=a5Mx3GwOFyoA_NHea-x+5g@mail.gmail.com>
References: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>
	<20140225135809.0b1afc69@notabene.brown>
	<CAF8Fvyy3DqXZPx83Bk1bTgws5W0Z9Zm-XkE86En9uJk886zERg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF8Fvyy3DqXZPx83Bk1bTgws5W0Z9Zm-XkE86En9uJk886zERg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again

I was contacted by a person who suggested to double-check
vfs_cache_pressure setting.
And it appeared that I had this setting set to 10000. That was a
left-over from previously debugging OOM-killer case.

When I removed this setting from sysctl.conf, I was able to greatly
increase the time to crash/freeze.
My server was able to withstand about a day of continuous write test.

Nevertheless, it froze after that.

Still it looks like something is wrong with RAID/filesystem co-operation.

I would still like to debug the problem.
Please help.

BR,
Denis

2014-02-26 22:52 GMT+02:00 Denis Golovan <denis.golovan@gmail.com>:
> Ok.
>
> I've tried using alt-sysrq-T to produce a log in netconsole after
> hang, but could not.
> It just didn't respond.
> When operating normally it worked fine (see attached file).
>
> One new interesting observation though.
>
> After RAID hang and server reboot, the reconstruction process started.
> Everything was as usual. However one interesting thing happened - I
> could not reproduce the crash/hang while array was constructing! I
> even created an extra pressure for array (I ran extra an process
> writing to it).
>
> At first I could not understand that. But then I realized that my
> reconstruction process uses too much bandwidth to trigger the
> crash/hang. I used following commands to force quicker reconstruction:
>
>    echo 100000 > /proc/sys/dev/raid/speed_limit_max
>    echo 50000 > /proc/sys/dev/raid/speed_limit_min
>    echo "idle" > /sys/block/md127/md/sync_action
>
> Thus the reconstruction worked at 100Mb/s.
>
> Then I decided to check this assumption and while intensively writing
> to the array and reconstructing simultaneously, I tried issuing
> following commands:
>
>   echo 10000 > /proc/sys/dev/raid/speed_limit_max
>   echo 10000 > /proc/sys/dev/raid/speed_limit_min
>   echo "idle" > /sys/block/md127/md/sync_action
>
>
> Guess what? After those executed (see the last lines in attached log),
> just several seconds later - the crash happened.
>
> So, I think there is something wrong with filesystem/RAID co-operation.
> You can see that while reconstructing, the pressure for filesystem is
> not enough to reproduce the crash.
>
> Could you provide something to move further into debugging the issue?
>
> BR,
> Denis
>
> 2014-02-25 4:58 GMT+02:00 NeilBrown <neilb@suse.de>:
>> On Tue, 25 Feb 2014 00:01:42 +0200 Denis Golovan <denis.golovan@gmail.com>
>> wrote:
>>
>>> Hi all
>>>
>>> I am struggling to diagnose a strange freeze of software RAID5 array.
>>> My RAID5 consists of 4 Toshiba SATA drives and has ext4 filesystem on top of it.
>>>
>>> It works fine unless I start several process writing intensively to it.
>>> At first, it looks like the system is under high pressure, then the
>>> system starts lagging a lot and a hard freeze always follows after
>>> several minutes.
>>>
>>> No errors in system log, nothing is emitted to console. Just hard
>>> freeze with HDD light always on. I tried enabling kernel network
>>> logging to another machine and again no information when hanging.
>>> After reboot, my array starts reconstruction and finishes without
>>> errors.
>>>
>>> I tried disabling quotas and barriers for ext4.
>>> After disabling barriers, it almost seemed to work, but after some
>>> time the same hard freeze happens.
>>>
>>> I tested the same hardware configuration under Linux v3.10, 3.11, 3.12
>>> and now 3.13.5 (all x86 arch) behaves the same way. The same issue can
>>> be reproduced easily.
>>>
>>> So now I tested everything Google suggests on the matter.
>>> Could you give a hint on how to debug this issue?
>>>
>>
>> The most useful thing for debugging a hard freeze is the alt-sysrq-T output
>> when it is frozen.  typing that magic sequence should always produce some
>> output unless it is hard-frozen with interrupts disabled.
>>
>> So make sure you can produce the output when the system is working properly
>> (to a log file file the network console would be ideal), then when it hangs,
>> produce the output again.
>> To probably need to have a text console rather than a graphic console for it
>> to work.
>>
>>
>> If it is hard-hanging with interrupts disabled, then it gets tricky.  I
>> thought there was some NMI-based lockup detector which would warn if that
>> happened, but I cannot find it just now.
>>
>> NeilBrown
