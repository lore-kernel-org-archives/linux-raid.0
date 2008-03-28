From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: component growing in raid5
Date: Fri, 28 Mar 2008 09:07:09 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0803280900160.15900@montezuma.acc.umu.se>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us>
 <47E7C609.9000501@bteam.hu> <18408.63715.481333.26215@tree.ty.sabi.co.uk>
 <Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se>
 <18409.23124.77027.214361@tree.ty.sabi.co.uk> <Pine.GSO.4.64.0803261016550.15900@montezuma.acc.umu.se>
 <47EC1B04.7040006@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EC1B04.7040006@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 28 Mar 2008, Richard Scobie wrote:

> Mattias Wadenstein wrote:
>
>>> A day or two? That's quite risky. Never mind that you get awful
>>> performance for that day or two and/or a risk of data corruption.
>>> Neil Brown some weeks on this mailing list expressed a very
>>> cautionary thought:
>>>=20
>>> =ABIt is really best to avoid degraded raid4/5/6 arrays when at all
>>>  possible. NeilBrown=BB
>>=20
>>=20
>> Yes, I read that mail. I've been meaning to do some real-world testi=
ng of=20
>> restarting degraded/rebuilding raid6es from various vendors, includi=
ng MD,=20
>> but haven't gotten around to it.
>
> You may be interested in these results - throughput results on an 8 S=
ATA=20
> drive RAID6 showed average write speed went from 348MB/s to 354MB/s a=
nd read=20
> speed 349MB/s to 196MB/s, while rebuilding with 2 failed drives. This=
 was=20
> with an Areca 1680x RAID controller.
>
> http://www.amug.org/amug-web/html/amug/reviews/articles/areca/1680x/

That's only performance though. I was interested in seeing if you could=
=20
provoke actual data corruption by doing unkind resets while doing vario=
us=20
things like writing, flipping bits/bytes inside files, or some other=20
access/update pattern.

That performance is good enough in the "easy" cases I'm well aware of,=20
I've done some poking at earlier areca controllers. They had really wei=
rd=20
performance issues in (for me) way too common corner cases though. I ju=
st=20
got a couple of newer ones delivered though, so I'll start pushing thos=
e=20
soon. I'm not sure I'll get the time for trying to provoke data corrupt=
ion=20
in degraded raidsets though.

/Mattias Wadenstein
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
