From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: {Possible Spam} RE: stripe_cache_active always 0
Date: Thu, 07 Jan 2016 17:53:47 +0000
Message-ID: <568EA62B.80103@mpstor.com>
References: <568DD6E6.6070107@websitemanagers.com.au> <F7761B9B1D11B64BBB666019E9378117FE848B@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE848B@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Adam Goryachev <adam@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/01/16 16:34, Robert Kierski wrote:
> Adam,
>
> stripe_cache_active is the value to indicate how many pages are curre=
ntly in use in the stripe cache.  I could be wrong about this... but I =
don=E2=80=99t think you can disable the stripe cache.  You can shrink i=
t to an unreasonable size, but the minimum you can set stripe_cache_siz=
e to is 17 (pages).
>
> Having said that, it may be that your RAID isn't using the stripe cac=
he or that you're not checking the value frequently enough to see strip=
e cache activity.
>
> A file system that is properly tuned, and doing buffered IO will like=
ly reduce the stripe cache usage.  The stripe cache is basically where =
data gets put when the RAID is doing partial stripe IO's, calculating p=
arity, or waiting for slow devices to complete their IO's.  It's not in=
tended to be yet another level of cache, so it gets purged when the RAI=
D is done with it.  So, unlike other caches that will hold onto data un=
til there is memory pressure, the stripe cache is more likely to be emp=
ty.
>
> As far as adjusting stripe_cache_size... The stripe cache is dynamica=
lly allocated.  It won't save any RAM by decreasing stripe_cache_size. =
 Decreasing it too much will negatively impact performance as it's more=
 likely you'll do Read-Modify-Write's when doing partial stripe writes.
>
I find that tuning it a bit higher (but not too high) has a very=20
positive impact on rebuild times (where we are therefore building=20
stripes). I can't remember exactly the values but we were setting it to=
=20
256 or 512 or even 1024 while building RAID5 or 6 with positive results=
=2E

Regards,
Ben.

> Bob Kierski
> Senior Storage Performance Engineer
> Cray Inc.
> 380 Jackson Street
> Suite 210
> St. Paul, MN 55101
> Tele: 651-967-9590
> Fax:  651-605-9001
> Cell: 651-890-7461
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD=
,j=07=EF=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=
=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ=
+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD=
!tml=3D
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
