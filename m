From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID Class Drives`
Date: Fri, 19 Mar 2010 18:53:33 +0100
Message-ID: <4BA3BA1D.50206@gmx.net>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com> <4BA258AD.5020605@gmx.net> <4BA33284.7000304@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA33284.7000304@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson schrieb:
> On 18/03/2010 16:45, Joachim Otahal wrote:
>> [...]  You should take care of the temperature of the drives,
>> 30=B0C to 35=B0C is preferred, above 35=B0C the lifespan goes down, =
over=20
>> 40=B0C rapidly down.
>
> Do you have a reference for this? Most drives' operating temperature=20
> range is specified up to 55=B0C, sometimes higher for enterprise driv=
es,=20
> without any indication (apart from common sense perhaps) that running=
=20
> them this hot reduces lifespan.
>
> Cheers,
>
> John.
>
About a half year ago the german publisher c't did this testing (or=20
reported from a big testing, cannot remember) what the best temperature=
=20
of desktop drives is. The statistic varied from drive to drive since=20
some are less than 5=B0C over room temperature, others are 15=B0C or mo=
re=20
over room temperature (of course mounted behind a silent fan which keep=
s=20
the air moving, no turbine mode).
The result was that 10=B0C and 15=B0C are not good for the drives. The=20
"perfect sweet spot" changes from drive to drive (even within on=20
manufacturer), but all of them had their sweet spot somewhere around=20
20=B0C to to 35=B0C with variation in the range of measurement error.
Some drives has a higher failure rate at 40=B0C, for some 55=B0C was no=
=20
problem at all and showed no real change in the failure rate. The last=20
two examples were the extreme cases.

Some of my drives are 2=B0C above room temperature, others are 12=B0C o=
ver=20
room temperature. Sine I really take care that non reaches 40=B0C even =
in=20
summer the failure rate got down from "every few month" to once in the =
3=20
years which is the time I really take care of the drive temperatures.=20
There are 6 drives currently in use from 750GB (the hottest of all my=20
drives) up to 1.5 TB in my private machines, only one of them shows a=20
gradual change in the SMART values (reallocated sector count), which=20
mean it will probably fail in about 1.5 years if the error rate stays=20
constant. At work (at least the two machines 100% under my control) I=20
had the same effect, keep the HD's cool and they will live long, let=20
them get over 40=B0C and be ready to replace them soon.

Joachim Otahal
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
