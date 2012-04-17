From: David Brown <david@westcontrol.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Tue, 17 Apr 2012 22:18:55 +0200
Message-ID: <4F8DD02F.1060504@westcontrol.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417171609.GA2859@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/04/12 19:16, Piergiorgio Sartor wrote:
> Hi David,
>
>> My current state is that I've got theory worked out and written up -
>> not just for triple parity, but for more parities as well.  For some
>> of it, I've got Python code to test and verify the maths.  It turns
>> out that triple parity can work well - but for quad parity the limit
>> is 21 data disks (using generators 2, 4, and 8), or up to 33 (using
>> for example 0x07, 0x35 and 0x8b as generators).  Realistically, I
>> think triple parity is the limit for practical implementations.
>
> Why is that? An RS code (255,251) should be possible, like
> it is a (255,223). What's the limitation?
> I'm sure there is even a "RAID-96", which is (96,64).
>
> My wild guess would be that the generators must be chosen
> in some way.
>
> Have you had a look at the "par2" code? That seems to be
> capable of doing a parametric RS, even if in 16bit words.
>
> bye,
>

It is certainly possible to make raid systems using as many disks as yo=
u=20
want, and as many parities as you want.  The trick is to do so in an=20
efficient manner.

The way raid6 is implemented is using simple polynomials over the Galoi=
s=20
field G(2=E2=81=B8):

Py =3D g_y^0 . D0 + g_y^1 . D1 + g_y^2 . D2 + ... + g_y^n . Dn

=46or raid5, you have one parity generators, and g0 is 1 (i.e., a simpl=
e=20
xor).  For raid6, you have two parity - 1 and 2.  For triple parity, we=
=20
would use g0 =3D 1, g1 =3D 2 and g2 =3D 4.  The whole thing is therefor=
e=20
simple (or relatively simple!) to implement, and should run fast -=20
calculating the third parity will only be slightly slower than=20
calculating the second parity in raid6 is today, and recovery will be a=
s=20
fast as raid6 unless you need to recover from 3 data disk failures.

=46or quad parity, we can try g3 =3D 8 as the obvious next choice in th=
e=20
pattern.  Unfortunately, we start hitting conflicts.  To recover missin=
g=20
data, we have to solve multiple simultaneous equations over G(2=E2=81=B8=
), whose=20
coefficients depend on the index numbers of the missing disks.  With=20
parity generators (1, 2, 4, 8), some of these combinations of missing=20
disk indexes lead to insoluble equations when you have more that 21 dis=
ks.

I didn't find any neat way to prove this, or prove that all combination=
s=20
of missing disks for parity generators (1, 2, 4) work out okay.  I wrot=
e=20
some brute-force checking code, and let my computer do the hard work.

There are other ways to make a raid system with quad parity or more.=20
The parities don't have to be calculated in such a neat form as above -=
=20
perhaps even something as simple as re-ordering the powers of the parit=
y=20
generators would help.  We could use a different operation rather than=20
the "G(2=E2=81=B8) multiply".  We could use different sized Galois fiel=
ds.  Or=20
we could try something completely different, such as RS codes.=20
Somewhere there we would get quad parity and more - for as many disks a=
s=20
we like.

However, I would be surprised if there were another method that had the=
=20
practicality of implementation that we get with this system.  There are=
=20
/huge/ benefits in having the triple-parity raid being the same as raid=
6=20
but with an extra parity, and being able to generate it in the same way=
=2E=20
  If quad parity is something that appeals to anyone, then it could be=20
implemented at the same time - and 21 data disks (25 disks total) would=
=20
be the limit.  Even though the same equations with different generators=
=20
can give up to 33 data disks, I expect that compatibility with raid6 an=
d=20
triple-parity would outweigh the benefits of supporting more disks.=20
After all, a 25 disk array is already pretty big for a single array.

mvh.,

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
