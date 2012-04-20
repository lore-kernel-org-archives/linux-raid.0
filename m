From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 02:45:48 -0500
Message-ID: <4F91142C.80305@hardwarefreak.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/17/2012 1:11 AM, Alex wrote:
> Thanks to Billy Crook who pointed out this is the right place for my =
post.
>=20
> Adam Leventhal integrated triple-parity RAID into ZFS in 2009. The
> necessity of triple-parity RAID is described in detail in Adam
> Leventhal's article(http://cacm.acm.org/magazines/2010/1/55741-triple=
-parity-raid-and-beyond/fulltext).

No mention of SSD.

> al.(http://www.nature.com/ncomms/journal/v3/n2/full/ncomms1666.html)

Pay wall.  No matter, as I'd already read of this research.

> established a revolutionary way of writing magnetic substrate using a
> heat pulse instead of a traditional magnetic field, which may increas=
e
> data throughput on a hard disk by 1000 times in the future.

Your statement is massively misleading.  The laser heating technology
doesn't independently increase throughput 1000x.  It will allow for
increased throughput only via enabling greater aerial density.  Thus th=
e
ratio of throughput to capacity stays the same.  Thus drive rebuild
times will still increase dramatically.

> facilitate another triple-parity RAID algorithm

CPU performance is increasing at a faster rate than any computer
technology.  Thus, if you're going to even bother with introducing
another parity RAID level, and the binary will run on host CPU cores,
skip triple parity and go straight to quad parity, RAID-P4=99.  Most sa=
vvy
folks doing RAID6 are using a 6+2 or 8+2 configuration as wide stripe
parity arrays tend to be problematic.  They then stripe them to create =
a
RAID60, or concatenate them if they're even more savvy and use XFS.

The most common JBOD chassis on the market today seems to be the 24x
2.5" drive layout.  This allows three 6+2 RAID6 arrays, losing 6 drives
to parity leaving 18 drives of capacity.  With RAID-P4=99  a wider stri=
pe
array becomes more attractive for some applications.  Thus our 24 drive
JBOD could yield a 20+4 RAID-P4=99 with two drives more capacity than t=
he
6+2 RAID6 configuration.  If one wished to stick with narrower stripes,
we'd get two 8+4 RAID-P4=99 arrays and 16 drives total capacity, 2 less
than the triple RAID6 setup, and still 4 drives more capacity than RAID=
10.

The really attractive option here for people who like parity RAID is th=
e
20+4 possibility.  With a RAID-P4=99 array that can withstand up to 4
drive failures, people will no longer be afraid of using wide stripes
for applications that typically benefit, where RAID50/60 would have bee=
n
employed previously.  They also no longer have to worry about secondary
and/or tertiary drive failures during a rebuild.

Yeah, definitely go straight to RAID-P4=99 and skip triple parity RAID
altogether.  You'll have to do it in 6-10 years anyway so may as well
prevent the extra work.  And people could definitely benefit from
RAID-P4=99 today.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
