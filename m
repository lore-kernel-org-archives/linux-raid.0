From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Thu, 19 Apr 2012 20:00:09 -0700
Message-ID: <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy> <4F8DD02F.1060504@westcontrol.com> <4F905690.3060301@zytor.com> <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Being a generator is a requirement for that.

Alex <creamyfish@gmail.com> wrote:

>I think when David says 'generator', he doesn't mean the generator of
>the order
>8 Galois field, he means an arbitrary set  of number in it which can
>render the
>system of equations solvable to up to a certain number of data
>disks(not necessarily
>255). He uses a brute-force method with the help of a Python program t=
o
>actually
>figure that out. It looks pretty cool to me since I have known the
>system of 4 equations
>generally fails to render a solution for a while, but now I know
>exactly how many ways
>it may fail...
>
>Cheers,
>Alex
>
>
>On Fri, Apr 20, 2012 at 2:16 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/17/2012 01:18 PM, David Brown wrote:
>>>
>>> For quad parity, we can try g3 =3D 8 as the obvious next choice in =
the
>>> pattern. =C2=A0Unfortunately, we start hitting conflicts. =C2=A0To =
recover
>missing
>>> data, we have to solve multiple simultaneous equations over G(2=E2=81=
=B8),
>whose
>>> coefficients depend on the index numbers of the missing disks. =C2=A0=
With
>>> parity generators (1, 2, 4, 8), some of these combinations of
>missing
>>> disk indexes lead to insoluble equations when you have more that 21
>disks.
>>>
>>
>> That is because 255 =3D 3*5*17... this means {02}^3 =3D {08} is not =
a
>generator.
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
"
>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml

--=20
Sent from my mobile phone. Please excuse brevity and lack of formatting=
=2E
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
