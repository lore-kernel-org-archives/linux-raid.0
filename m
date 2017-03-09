From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: interesting case of a hung 'recovery'
Date: Thu, 9 Mar 2017 10:13:01 +0100
Message-ID: <CA+res+SYTaCd77Nvdvn-gSe2qcJu5nXMdnV32nL0MKs9NOzqYg@mail.gmail.com>
References: <091a6513-1594-4a33-691a-cd1f7920d4a0@eyal.emu.id.au> <61a297da-de29-e471-7270-166b33ce18b9@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <61a297da-de29-e471-7270-166b33ce18b9@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-03-09 8:39 GMT+01:00 Eyal Lebedinsky <eyal@eyal.emu.id.au>:
> Bump.
>
> On 18/02/17 23:14, Eyal Lebedinsky wrote:
>>
>> I should start by saying that this is an old fedora 19 system
>>
>> Executive summary: after '--add'ing a new member a 'recovery' starts but
>> 'sync_max' is not reset.
>>
>> $ uname -a
>> Linux e7.eyal.emu.id.au 3.14.27-100.fc19.x86_64 #1 SMP Wed Dec 17 19:36:34
>> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>
> $ sudo mdadm --version
> mdadm - v4.0 - 2017-01-09
>
>> so the issue may have been fixed since.
>>
>> I had a disk fail in a raid6. After some 'pending' sectors were logged I
>> decided to do a 'check'
>> around that location (set sync_min/max and echo 'check'). Sure enough it
>> elicited disk errors,
>> but the disk did not recover and it was kicked out of the array. Moreover
>> it became unresponsive.
>> It needed a power cycle so I shutdown and rebooted the machine.
>>
>> Not one to give up easily I tried the check again, with the same result.
>> It was time to '--remove' this array member. I then '--add'ed a new disk
>> which started a recovery.
>>
>> A few hours later I noticed that it slowed down. A lot. It actually did
>> not progress at all for
>> a few hours (I was away from the machine).
>>
>> As I was staring at the screen (for a long while) I realised that it
>> stopped at 55.5%, and this
>> number is exactly where the original 'check' failed (I still do not
>> understand why with my bad
>> memory I remembered this number).
>>
>> I checked 'sync_completed' and it was proper.
>> I then examined 'sync_max' and it was wrong - it had the location where
>> the very early 'check'
>> failed earlier in the day. It was the same sector where it is now paused
>> at - looks related.
>>
>> I decided to take a (small) risk and do
>>     # echo 'max' >/sys/block/md127/md/sync_max
>> at which point the recovery moved on. It should be finished in about 5
>> hours.
>>
>> I do not think that it is correct for 'sync_max' to not be set to 'max'
>> when a new member is
>> added - it surely requires a full recovery.
>>
>> I really hope (and expect) that this was actually fixed, but this note may
>> help others facing
>> same predicament.
>>
>> cheers
>>
>
> --
> Eyal Lebedinsky (eyal@eyal.emu.id.au)

You'd better offer attach much detailed information, then people can help.

eg:
https://raid.wiki.kernel.org/index.php/Asking_for_help

For the problem you reported, better offer also kernel dmesg, output
of blocking tasks via "echo w >  /proc/sysrq-trigger" maybe also
"echo t > /proc/sysrq-trigger"

Cheers,
Jack
