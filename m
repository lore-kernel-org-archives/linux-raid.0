From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Thu, 19 Apr 2012 11:16:48 -0700
Message-ID: <4F905690.3060301@zytor.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy> <4F8DD02F.1060504@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8DD02F.1060504@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/17/2012 01:18 PM, David Brown wrote:
>=20
> For quad parity, we can try g3 =3D 8 as the obvious next choice in th=
e
> pattern.  Unfortunately, we start hitting conflicts.  To recover miss=
ing
> data, we have to solve multiple simultaneous equations over G(2=E2=81=
=B8), whose
> coefficients depend on the index numbers of the missing disks.  With
> parity generators (1, 2, 4, 8), some of these combinations of missing
> disk indexes lead to insoluble equations when you have more that 21 d=
isks.
>=20

That is because 255 =3D 3*5*17... this means {02}^3 =3D {08} is not a g=
enerator.

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
