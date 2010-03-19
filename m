From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID Class Drives`
Date: Fri, 19 Mar 2010 19:14:50 +0100
Message-ID: <4BA3BF1A.2060905@gmx.net>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>	 <4BA258AD.5020605@gmx.net> <4BA33284.7000304@anonymous.org.uk> <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c2a12e21003190943t546ade49u2294310ed7d9921e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aryeh Gregor schrieb:
> On Fri, Mar 19, 2010 at 4:15 AM, John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
>   =20
>> Do you have a reference for this? Most drives' operating temperature=
 range
>> is specified up to 55=C2=B0C, sometimes higher for enterprise drives=
, without any
>> indication (apart from common sense perhaps) that running them this =
hot
>> reduces lifespan.
>>     =20
> Google's study of>100,000 disks over 9 months or so
> <http://labs.google.com/papers/disk_failures.html>  suggests that
> hotter drives don't fail much more often:
>   =20
Thanks for the link.
That study was referred to as a comparison to the current situation. Bu=
t=20
google only tested up to 400 GB in that statistic, and I DO remember=20
that my old 160GB to 500 GB drives were all a lot hotter than any of my=
=20
current drives. Those Samsung 1TB drives only reached 35=C2=B0C during =
last=20
hot summer, but I did let the fan rotate faster during the summer.

Current real world data of my drives (Windows main machine, room=20
temperature is 23=C2=B0C right now):
SAMSUNG 1 TB 27=C2=B0C (HD103UJ)
WD 1 TB 30=C2=B0C (WD10 EACS-00ZJBO)
WD 750 GB 34=C2=B0C (WD75 00AACS-00ZJBO)
SAMSUNG 1 TB 25=C2=B0C (HD103UJ)

Linux Server (mirrored drives):
SEAGATE 1,5 TB 34=C2=B0C (ST31500341AS)
SEAGATE 1,5 TB 34=C2=B0C (ST31500341AS) <- this one will probably fail =
in one=20
or one and a half year if the realloc-sector count continues to develop=
=20
this way.

Joachim Otahal

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
