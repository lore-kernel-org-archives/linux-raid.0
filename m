From: "Majed B." <majedb@gmail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 14:09:40 +0300
Message-ID: <70ed7c3e0910130409r1e1350b6yabfdc3d4f5c51edf@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	<20091013013352.GA24869@infradead.org> <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Out of curiosity, why are you upgrading the kernel? Are you after a
certain feature offered by the new kernel?

If not, roll back to a kernel version where you don't face performance =
drops.

On Tue, Oct 13, 2009 at 2:06 PM, mark delfman
<markdelfman@googlemail.com> wrote:
> A little more information which I =E2=80=98think=E2=80=99 seems to po=
int at MD.....
>
> Creating an EXT3 FS on an MD RAID also shows a circa 50% performance =
drop.
> We have tried a multitude of RAID options (raid6/0 various chunks etc=
).
>
> Using a hardware based raid XFS / EXT3 shows no performance drop
> (although the hardware raid is significantly slower than MD in the
> first place)
>
> We are happy to keep testing and offering anything that could be
> useful, we are just a little stuck thinking of anything else to do...=
=2E
>
>
>
>
> On Tue, Oct 13, 2009 at 2:33 AM, Christoph Hellwig <hch@infradead.org=
> wrote:
>> On Mon, Oct 12, 2009 at 05:58:20PM +0100, mark delfman wrote:
>>> Hi... in recent tests we are seeing a 50% drop in performance from
>>> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)
>>>
>>> In short: =C2=A0Performance to MD0 direct =3D circa 1.7GBsec (see b=
elow), via
>>> xfs circa 850MBsec. =C2=A0On previous system (2.6.28) there was no =
drop in
>>> performance (in fact often an increase).
>>>
>>> I am hopefully that this is simply a matter of barriers etc on the
>>> newer kernel and MD, but we have tried many options and nothing see=
ms
>>> to change this so would very much appreciate advice.
>>
>> Did barrier support for RAID0 got introduced in 2.6.30?
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
