From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: component growing in raid5
Date: Fri, 28 Mar 2008 11:09:08 +1300
Message-ID: <47EC1B04.7040006@sauce.co.nz>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us> <47E7C609.9000501@bteam.hu> <18408.63715.481333.26215@tree.ty.sabi.co.uk> <Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se> <18409.23124.77027.214361@tree.ty.sabi.co.uk> <Pine.GSO.4.64.0803261016550.15900@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0803261016550.15900@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mattias Wadenstein wrote:

>> A day or two? That's quite risky. Never mind that you get awful
>> performance for that day or two and/or a risk of data corruption.
>> Neil Brown some weeks on this mailing list expressed a very
>> cautionary thought:
>>
>> =ABIt is really best to avoid degraded raid4/5/6 arrays when at all
>>  possible. NeilBrown=BB
>=20
>=20
> Yes, I read that mail. I've been meaning to do some real-world testin=
g=20
> of restarting degraded/rebuilding raid6es from various vendors,=20
> including MD, but haven't gotten around to it.

You may be interested in these results - throughput results on an 8 SAT=
A=20
drive RAID6 showed average write speed went from 348MB/s to 354MB/s and=
=20
read speed 349MB/s to 196MB/s, while rebuilding with 2 failed drives.=20
This was with an Areca 1680x RAID controller.

http://www.amug.org/amug-web/html/amug/reviews/articles/areca/1680x/

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
