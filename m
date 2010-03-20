From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID Class Drives`
Date: Sat, 20 Mar 2010 13:26:21 -0400
Message-ID: <4BA5053D.1040607@tmr.com>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com> <4BA258AD.5020605@gmx.net> <4BA33284.7000304@anonymous.org.uk> <4BA3BA1D.50206@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA3BA1D.50206@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Joachim Otahal <Jou@gmx.net>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joachim Otahal wrote:
> John Robinson schrieb:
>> On 18/03/2010 16:45, Joachim Otahal wrote:
>>> [...]  You should take care of the temperature of the drives,
>>> 30=B0C to 35=B0C is preferred, above 35=B0C the lifespan goes down,=
 over=20
>>> 40=B0C rapidly down.
>>
>> Do you have a reference for this? Most drives' operating temperature=
=20
>> range is specified up to 55=B0C, sometimes higher for enterprise=20
>> drives, without any indication (apart from common sense perhaps) tha=
t=20
>> running them this hot reduces lifespan.
>>
>> Cheers,
>>
>> John.
>>
> About a half year ago the german publisher c't did this testing (or=20
> reported from a big testing, cannot remember) what the best=20
> temperature of desktop drives is. The statistic varied from drive to=20
> drive since some are less than 5=B0C over room temperature, others ar=
e=20
> 15=B0C or more over room temperature (of course mounted behind a sile=
nt=20
> fan which keeps the air moving, no turbine mode).
> The result was that 10=B0C and 15=B0C are not good for the drives. Th=
e=20
> "perfect sweet spot" changes from drive to drive (even within on=20
> manufacturer), but all of them had their sweet spot somewhere around=20
> 20=B0C to to 35=B0C with variation in the range of measurement error.
> Some drives has a higher failure rate at 40=B0C, for some 55=B0C was =
no=20
> problem at all and showed no real change in the failure rate. The las=
t=20
> two examples were the extreme cases.
>
> Some of my drives are 2=B0C above room temperature, others are 12=B0C=
 over=20
> room temperature. Sine I really take care that non reaches 40=B0C eve=
n=20
> in summer the failure rate got down from "every few month" to once in=
=20
> the 3 years which is the time I really take care of the drive=20
> temperatures. There are 6 drives currently in use from 750GB (the=20
> hottest of all my drives) up to 1.5 TB in my private machines, only=20
> one of them shows a gradual change in the SMART values (reallocated=20
> sector count), which mean it will probably fail in about 1.5 years if=
=20
> the error rate stays constant. At work (at least the two machines 100=
%=20
> under my control) I had the same effect, keep the HD's cool and they=20
> will live long, let them get over 40=B0C and be ready to replace them=
 soon.

40=B0C is a good target, readily available to people in the Arctic. It=20
requires a lot of cooling to do it in normal climates where the ambient=
=20
may be mid to high 40s. Fortunately my experience looks more like=20
Google's, as long as you move enough air over the drive to avoid hot=20
spots they seem to do well, hitting 43-46 much of the time. If I replac=
e=20
them because they're obsolete and working, they lasted long enough.=20
Perhaps being "always on" is part of longevity, the ones I have on for=20
5-6 years seldom fail, the desktop cycled daily maybe half that.

I do note that the WD drives run about 8=B0C cooler than Seagate. That'=
s=20
the "black" drive, I guess, the "green" drives would run cooler, based=20
on power use. I will switch to them next build.

--=20
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
