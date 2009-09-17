From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Fri, 18 Sep 2009 00:26:41 +0300
Message-ID: <70ed7c3e0909171426y320f74f9x9901ad5b1420f829@mail.gmail.com>
References: <200909171620688.SM00612@trainer> <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This NAS from WD, does it use Linux's software RAID?
If not, you can't assemble it under Linux, because the RAID controller
is using proprietary methods.

On Fri, Sep 18, 2009 at 12:01 AM, Robin Hill <robin@robinhill.me.uk> wr=
ote:
> On Thu Sep 17, 2009 at 04:20:16PM -0400, Sunpyo Hong wrote:
>
>> I've contacted just about everyone that knows a thing about RAID5, b=
ut no
>> one is really able to help me. Anyhow I've read up a lot on RAID5 ar=
rays and
>> how to properly assemble them. However I've run into a problem with =
a NAS
>> system from WD that I just can't seem to figure out.
>>
>> I have a =C2=BE disks in the array, 1 went down and is out of commis=
sion. =C2=A0I've
>> been able to assemble my array through mdadm using --assemble --scan=
=2E However
>> I cannot access the array due to the fact that the array cannot read=
 a
>> filesystem. Everytime I try to mount I get mount: wrong fs type=E2=80=
=A6 etc. I
>> know that the FS is an ext3 FS. However I cannot seem to get this
>> thing going. I was wondering if anyone could point me in the right
>> direction with this. I can't seem to find anyone that is capable of
>> solving this. I would appreciate any help. Thanks!
>>
> What's the output of 'cat /proc/mdstat' after you assemble the array?
> And what exact error (and dmesg output) do you get when trying to mou=
nt
> it as ext3?
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



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
