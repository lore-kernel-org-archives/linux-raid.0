From: David Brown <david.brown@hesbynett.no>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 20:58:12 +0200
Message-ID: <4F91B1C4.5080205@hesbynett.no>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy> <4F8DD02F.1060504@westcontrol.com> <4F905690.3060301@zytor.com> <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com> <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com> <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Yes, being a generator for GF(2^8) is a requirement for a parity=20
generator (sorry for the confusing terminology here - if anyone has a=20
better suggestion, please say) to be part of a 255 data disk system.=20
However, being a GF generator is necessary but not sufficient - using=20
parity generators (1, 2, 4, 16) will /not/ give quad parity for 255 dat=
a=20
disks, even though individually each of 1, 2, 4 and 16 are generators=20
for GF.

255 data disks is the theoretical limit for GF(2=E2=81=B8).  But it is =
a=20
theoretical limit of the algorithms - I don't know whether Linux md rai=
d=20
actually supports that many disks.  I certainly doubt if it is useful.

It might well be that a 21 data disk limit quad parity is useful - or a=
t=20
least, as useful as quad parity ever would be.  It would fit well withi=
n=20
a typical large chassis with 24 disk slots.  And then it doesn't matter=
=20
that 8 is not a generator for GF(2=E2=81=B8) - it becomes the best choi=
ce=20
because of the easiest implementation.

On 20/04/12 05:32, Alex wrote:
> I understand we need a generator to facilitate a 255 data disks
> array, but 255 sounds like a theoretic limit to me. ZFS now only
> supports an array of only 9 disks(6 of them are data disks), so
> having, say, a quad-parity array of 48 disks(theoretically) doesn't
> sound that bad, does it?
>
> Cheers, Alex
>
> On Fri, Apr 20, 2012 at 11:00 AM, H. Peter Anvin<hpa@zytor.com>
> wrote:
>> Being a generator is a requirement for that.
>>
>> Alex<creamyfish@gmail.com>  wrote:
>>
>>> I think when David says 'generator', he doesn't mean the
>>> generator of the order 8 Galois field, he means an arbitrary set
>>> of number in it which can render the system of equations solvable
>>> to up to a certain number of data disks(not necessarily 255). He
>>> uses a brute-force method with the help of a Python program to
>>> actually figure that out. It looks pretty cool to me since I have
>>> known the system of 4 equations generally fails to render a
>>> solution for a while, but now I know exactly how many ways it may
>>> fail...
>>>
>>> Cheers, Alex
>>>
>>>
>>> On Fri, Apr 20, 2012 at 2:16 AM, H. Peter Anvin<hpa@zytor.com>
>>> wrote:
>>>> On 04/17/2012 01:18 PM, David Brown wrote:
>>>>>
>>>>> For quad parity, we can try g3 =3D 8 as the obvious next choice
>>>>> in the pattern.  Unfortunately, we start hitting conflicts.
>>>>> To recover
>>> missing
>>>>> data, we have to solve multiple simultaneous equations over
>>>>> G(2=E2=81=B8),
>>> whose
>>>>> coefficients depend on the index numbers of the missing
>>>>> disks.  With parity generators (1, 2, 4, 8), some of these
>>>>> combinations of
>>> missing
>>>>> disk indexes lead to insoluble equations when you have more
>>>>> that 21
>>> disks.
>>>>>
>>>>
>>>> That is because 255 =3D 3*5*17... this means {02}^3 =3D {08} is no=
t
>>>> a
>>> generator.
>>>>
>>>> -hpa
>>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
