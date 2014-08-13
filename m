From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Wed, 13 Aug 2014 09:07:46 -0700
Message-ID: <CAH_2Ghc+M2dCQBs3iRXYPZwKAsvY-TbS852VxhReT4k8HBQkQQ@mail.gmail.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
	<53E96C21.2050309@nuclearwinter.com>
	<53E9AC63.1020809@gmail.com>
	<BLU436-SMTP2487F2FA5F4B1A1A1B1E87B98EA0@phx.gbl>
	<CAH_2GhfBKiJAT=+zCFH0_xkmyTfWFi=c-F+z8rwL1x++UwU+KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2GhfBKiJAT=+zCFH0_xkmyTfWFi=c-F+z8rwL1x++UwU+KA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org, rm@romanrm.net
List-Id: linux-raid.ids

Arg!!  Am I hitting some kind of blocking at the Linux kernel?? No
matter what I do, I can't seem to get the drives to spin up in
parallel.  Any ideas?

A simple test case trying to get two drives to spin up at once.
root@nas:~# hdparm -C /dev/sdh /dev/sdg
/dev/sdh:
 drive state is:  standby

/dev/sdg:
 drive state is:  standby

#Two terminal windows dd'ing sdg and sdh at the same time.
root@nas:~/dm_drive_sleeper# time dd if=/dev/sdh of=/dev/null bs=4096
count=1 iflag=direct
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 14.371 s, 0.3 kB/s

real   0m28.139s ############# WHY?! ################
user   0m0.000s
sys   0m0.000s

#A single drive spin-up
root@nas:~/dm_drive_sleeper# time dd if=/dev/sdh of=/dev/null bs=4096
count=1 iflag=direct
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 14.4212 s, 0.3 kB/s

real   0m14.424s
user   0m0.000s
sys   0m0.000s

On Tue, Aug 12, 2014 at 8:23 AM, Adam Talbot <ajtalbot1@gmail.com> wrote:
> Thank you all for the input.  At this point I think I am going to write a
> simple daemon to do dm power management. I still think this would be a good
> feature set to roll into the driver stack, or madam-tools.
>
> As far as wear and tear on the disks. Yes, starting and stopping the drives
> shortens their life span. I don't trust my disks, regardless of
> starting/stopping, that is why I run RAID 6. Lets say I use my NAS with it's
> 7 disks for 2 hours a day, 7 days a week @ 10 watts per drive.  The current
> price for power in my area is $0.11 per kilowatt-hour. That comes out to be
> $5.62 per year to run my drives for 2 hours, daily.  But if I run my drives
> 24/7 it would cost me $67.45/year.  Basically it would cost me an extra
> $61.83/year to run the drives 24/7.  The 2TB 5400RPM SATA drives I have been
> picking up from local surplus, or auction websites are costing me $40~$50,
> including shipping and tax.  In other words I could buy a new disk every
> 8~10 months to replace failures and it would be the same cost. Drives don't
> fail that fast, even if I was start/stopping them 10 times daily. This is
> also completely ignoring the fact that drive prices are failing.  Sorry to
> disappoint, but I am going to spin down my array and save some money.
>
>
>
>
> On Tue, Aug 12, 2014 at 2:46 AM, Wilson, Jonathan
> <piercing_male@hotmail.com> wrote:
>>
>> On Tue, 2014-08-12 at 07:55 +0200, Can Jeuleers wrote:
>> > On 08/12/2014 03:21 AM, Larkin Lowrey wrote:
>> > > Also, leaving spin-up to the controller is
>> > > also not so hot since some controllers spin-up the drives sequentially
>> > > rather than in parallel.
>> >
>> > Sequential spin-up is a feature to some, because it avoids large power
>> > spikes.
>>
>> I vaguely recall older drives had a jumper to set a delayed spin up so
>> they stayed in a low power (possibly un-spun up) mode when power was
>> applied and only woke up when a command was received (I think any
>> command, not a specific "wake up" one).
>>
>> Also as mentioned some controllers may also only wake drives one after
>> the other, likewise mdriad does not care about the underlying
>> hardware/driver stack, only that it eventually responds, and even then I
>> believe it will happily wait till the end of time if no response or
>> error is propagated up the stack; hence the time out in scsi_device
>> stack not in the mdraid.
>>
>>
>>
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
