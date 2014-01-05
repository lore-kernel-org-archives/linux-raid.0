From: Dylan Distasio <interzone@gmail.com>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Sun, 5 Jan 2014 12:01:25 -0500
Message-ID: <CAJrqPH_oj63UE6=n8OQZmM+mynjpUojy+0VLcvFXTmCO_JmmMQ@mail.gmail.com>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
 <CAK2H+ecnYpDbyqQrFZwmkL4F++iVwDvhfxNqxzWETbFtvXJqUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecnYpDbyqQrFZwmkL4F++iVwDvhfxNqxzWETbFtvXJqUg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> I'm reacting to nothing more than 20 drives, no documentation and beeping:
>
> 1) Are the beeps POST codes?
>
> http://www.computerhope.com/beep.htm

No, I woke up to it beeping, but it POSTs fine.  I think the beeping
was probably coming from the Highpoint card indicating array failure.
It no longer beeps, but it also won't pick up any drives.
>
> 2) Before making any physical changes I'd start by  drawing an
> accurate picture. Exactly what cables go to exactly what drives. Put a
> label on each drive & each cable (masking tape/black pen, etc.) so
> that if you do disassemble things you have a chance of getting it back
> together later in the same configuration.
>

Good idea.
> 3) If I thought it was the High Point I'd likely just remove it from
> its slot and try booting again. (Assuming it's not needed to boot.)
>
> 4) It's not clear to me from this email exactly what's required (if
> anything) in terms of RAID to make machine boot but if I could boot
> from nothing but what's attached to the MB then that what I'd be
> trying to do first. With 20 drives you could have a power supply
> failiing  and the system isn't getting enough power to run 20 drives,
> etc. Minimize as much as possible.
>
> 5) If you get to where you can boot then you should run smartctl on
> each drive looking for any info. However I would understand if 20
> drives over a bunch of years means not all drives support S.M.A.R.T.
>
> 6) Once you get it booting I'd run a check of any RAID that's included
> at that point to ensure it hadn't been damaged and then look to add
> things back in.
>
> Good luck!
>
> - Mark

The machine will boot fine from what I can see, but I am concerned
with disconnecting some drives and letting it boot because it might
result in a degraded array assembling simply because I did not
reconnect the drives it was looking for when I remove the highpoint
from the picture.
