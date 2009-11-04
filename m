From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Wed, 04 Nov 2009 09:05:45 -0500
Message-ID: <4AF18A39.6010404@tmr.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> Hi... I am wondering if anyone can offer some advice on MD performanc=
e
> related to CPU (speed and or cores).  The basic question (probably to=
o
> basic) is =93for more MD performance are you better with more cpu=92s=
 or a
> faster single cpu=94.  (in an ideal world we would have lots of very
> fast CPUs, but given we never have enough money....).
>
> Is there any grounding to the following logic:
>
> Presuming that a RAID0 will deliver 1.5GBsec and a RAID6 circa
> 700MBsec, I am guessing there are many complex reasons for the
> difference, but one of the more obvious being the need for the CPU to
> perform all the necessary R6 overheads.
>
> If we look at a single RAID 6 configuration, then I am guessing if we
> increase the speed of the CPU from eg 2.0GHz to 2.8GHz (quad core
> xeon) then the RAID6 calculations would be faster?  Would other
> overheads also be faster and if so is there any know relationship
> between CPU Hz and MD performance (maybe even rough rule of thumb eg
> double cpu Hz and increase R6 performance by 20% etc)
>
> If however I start to think of multiple RAID6 configurations maybe vi=
a
> iSCSI etc... then I wonder if MD would be better served with more CPU=
s
> instead... for example 2 x Quad core 2.0GHz xeons instead of 1 x 2.8.
>   This theory is dependent on linux / md effectively parallel
> processing the overheads and I have no knowledge in this area... henc=
e
> the question.
>
> Any thoughts anyone?
>  =20

Your logic is correct, but it implies that you expect "faster=20
calculation" to mean "faster write performance," and that is usually=20
true only at very low or very high write loads.

Very low, because you get the io queued a few ns faster. Since the disk=
=20
still has to do the write, this is essentially meaningless.

Very high, because with many drives and a huge write volume you could,=20
in theory, start having CPU issues.

I suggest that before you worry over much on that, you look at CPU usag=
e=20
at idle and then at gradually increasing write load, and look at system=
=20
time vs. GB/sec to see if you are actually getting anywhere near the=20
limit, or even up enough to notice. In my look at this a few years ago =
I=20
didn't see any issues, but that was with only eight drives in the array=
=2E=20
Measurement is always good, but in general drive performance is the=20
limiting factor rather than CPU.

You didn't ask: if you use ext[34] filesystems, there is a gain to be=20
had from tuning the stripe and stride parameters, at least for large=20
sequential io. My measurements were on 2.6.26, so are out of date, but=20
less head motion is always better.

Others may have more experience, other than load testing the array has=20
never been stressed, performance of backup servers is less important=20
than reliability.

--=20
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
