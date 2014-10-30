From: Ian Young <ian@duffrecords.com>
Subject: Re: Fwd: I will pay money for the correct RAID recovery instructions
Date: Thu, 30 Oct 2014 16:03:39 -0700
Message-ID: <CANs+QMxQ0sEwtsmRpxdq-wKOZ3MFeCrufNuD1z+Pbk3-ADgbEg@mail.gmail.com>
References: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
	<20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
	<CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
	<21569.8756.823611.71332@quad.stoffel.home>
	<CAOS+5GGMGU2doP=v1LfeA5CDDmuMj4gxUcNtoK5-gJWHO9CMaw@mail.gmail.com>
	<CAOS+5GEbNPAWfBL_uPDOuhMb4LtN+_fJ07MD7igOQmVi04mWpA@mail.gmail.com>
	<21569.16459.69850.406372@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21569.16459.69850.406372@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Another Sillyname <anothersname@googlemail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin's solution worked.  I used ddrescue to copy sde to a new disk,
then put the new disk in place of sde, and started the array in
degraded mode.  Now I just need to get a replacement disk for sdf and
the array should be all set.

I believe I owe Robin a pint.  Got Paypal or Google Wallet?

On Fri, Oct 17, 2014 at 9:14 AM, John Stoffel <john@stoffel.org> wrote:
>
> Another> Sorry to state the obvious but......  To restore the degraded
> Another> array would (based on the info you've posted) likely take
> Another> longer then temporarily moving the data to a different set of
> Another> drives.
>
> How do you figure this?  He hasn't posted any useful data on his array
> at all.  We know it's six 3Tb disks in RAID10, so that's at most 9Tb
> of data.  Moving 3Tb (bad disk ddrescue'd onto new disk) is only 3Tb
> to move.  Then the resync will of course take time.
>
> But if he doesn't have the spare disk space, it's probably the only way.
>
> Another> As time seems to be a major consideration here (likely/possible
> Another> failure of sde) then surely the optimal strategy has to be to get the
> Another> data off first, then look at the rebuilding the degraded array?
>
> Another> Just my 2c
>
> Another> On 17 October 2014 15:05, John Stoffel <john@stoffel.org> wrote:
>>>
>>>
>>> Ian,
>>>
>>> It would also help if you posted the details of your setup using:
>>>
>>> cat /proc/partitions
>>> cat /proc/mdstat
>>>
>>> mdadm -D /dev/md#
>>> - for each of the devices above.
>>>
>>> mdadm -E /dev/sd<drive><#>
>>> - for each disk or partition in the array from above.
>>>
>>>
>>>
>>> But the suggestions to ddrescue the going bad drive onto a new disk is
>>> a good one.  On my debian system, I would do the following:
>>>
>>> sudo apt-get install gddrescue
>>> ddrescue /dev/sde /dev/sdf /var/tmp/ddrecue-sde.log
>>>
>>> and see how that goes.
>>>
>>> Good luck,
>>> John
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Another> --
> Another> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> Another> the body of a message to majordomo@vger.kernel.org
> Another> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
