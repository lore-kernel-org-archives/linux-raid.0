From: David Rees <drees76@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 16:01:30 -0700
Message-ID: <72dbd3151003261601w55bbc103w431e9582f1f13cae@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
	<5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
	<4BAD20A2.20606@kieser.ca> <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
	<5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>
	<4BAD24EB.4020606@sauce.co.nz> <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Peter Kieser <peter@kieser.ca>, Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 3:38 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Fri, Mar 26, 2010 at 2:19 PM, Richard Scobie <richard@sauce.co.nz> wrote:
>> No, its item 193 Load_Cycle_Count (LCC) and it's at 27557.
>
> Thanks. I don't know if that's high or low. To me it's just a number.
>
> Following along from Matt Garman's reply I went back and looked at
> when I built this machine for my dad. (How many here have 85 year old
> fathers who have run Linux for 7 years instead of windows? Give him a
> cheer!) ;-) I agree with Matt about trying to save power.
>
> This machine is 40 days old today, at least counting since he first
> booted it at home. It's been up and running since then.
>
> 40 Days is 3,456,000 seconds.
>
> 3,456,000 / 27557 is 125 seconds/count increase on average. So about 2 minutes.
>
> I wonder if I'm seeing something like Matt is seeing with the drive
> continually being woken up. I know most of the time it just sits idle
> from a user's perspective, but I've done nothing to stop daemons or
> anything like that. It runs screen savers, gets used every day for an
> hour or two, but is always powered up so that I can administer it from
> 350 miles away.

Why leave the thing on 24 hours a day if it's only used 1-2 of them?
Save wear on your drive and the rest of the machine, save your dad a
few bucks on his electricity bill and shut the thing down when it's
not used.  Then use WoL to wake it up if you need to admin it, or
heck, just use the BIOS/ACPI wakeup feature and put the thing to sleep
at night and wake up automatically in the morning - at least then
you'll cut it's run-time in half.

-Dave
