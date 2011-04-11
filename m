From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 01:32:34 -0700
Message-ID: <BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
	<BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
	<20110409085044.GB417@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110409085044.GB417@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robin,

Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numbers in
the iostat output are ok...is that correct?

Thanks.

On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.uk> wrot=
e:
> On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:
>
>> What I'm not sure of is if the device is newly formatted, would raid
>> recovery happen? What else could explain difference in the first run
>> of IO benchmark?
>>
> When an array is first created, it's created in a degraded state - th=
is
> is the simplest way to make it available to the user instantly. The
> final drive(s) are then automatically rebuilt, calculating the
> parity/data information as normal for recovering a drive.
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
