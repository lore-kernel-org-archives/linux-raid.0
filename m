From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 15:38:14 -0700
Message-ID: <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
	 <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
	 <4BAD20A2.20606@kieser.ca>
	 <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
	 <5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>
	 <4BAD24EB.4020606@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAD24EB.4020606@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Peter Kieser <peter@kieser.ca>, Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 2:19 PM, Richard Scobie <richard@sauce.co.nz> w=
rote:
> Mark Knecht wrote:
>
>> 193 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 191 =C2=
=A0 191 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 27557
>
>>
>> Is it currently at 191 with a fail level of 27557?
>
> No, its item 193 Load_Cycle_Count (LCC) and it's at 27557.
>
> Regards,
>
> Richard
>

Thanks. I don't know if that's high or low. To me it's just a number.

=46ollowing along from Matt Garman's reply I went back and looked at
when I built this machine for my dad. (How many here have 85 year old
fathers who have run Linux for 7 years instead of windows? Give him a
cheer!) ;-) I agree with Matt about trying to save power.

This machine is 40 days old today, at least counting since he first
booted it at home. It's been up and running since then.

40 Days is 3,456,000 seconds.

3,456,000 / 27557 is 125 seconds/count increase on average. So about 2 =
minutes.

I wonder if I'm seeing something like Matt is seeing with the drive
continually being woken up. I know most of the time it just sits idle
from a user's perspective, but I've done nothing to stop daemons or
anything like that. It runs screen savers, gets used every day for an
hour or two, but is always powered up so that I can administer it from
350 miles away.

Interesting. I'll watch it every so often and see if it's increasing
in a linear fashion, as I might guess Matt's data would suggest, or
doing something different. Since I sent data a while ago it's
increased to 27594. (+37) That was roughly an hour ago and my dad
hasn't been logged on during this time.

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
