From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Thu, 31 Oct 2002 12:56:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021031115608.GE30823@unthought.net>
References: <20021022104522.GC24075@unthought.net> <Pine.LNX.4.44.0210221248540.26127-100000@ddx.a2000.nu> <20021022112401.GA26549@unthought.net> <004e01c27eaf$b6c11940$707ba8c0@YQDING> <20021028210240.GB15779@unthought.net> <006501c27eca$3a1f0440$707ba8c0@YQDING> <20021029003046.GE15779@unthought.net> <008c01c27f8e$fb63a3d0$707ba8c0@YQDING>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <008c01c27f8e$fb63a3d0$707ba8c0@YQDING>
To: Yiqiang Ding <yqding@rasilient.com>
Cc: raid@ddx.a2000.nu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 29, 2002 at 01:05:59PM -0800, Yiqiang Ding wrote:
> Hi Jakob,
>=20

Hello Ding,

> Thanks for your kind explanation. Sounds pretty reasonable. I also ha=
ve done
> some tests on raid5 with 4k and 128k chunk size. The results are as f=
ollows:
> Access Spec     4K(MBps)        4K-deg(MBps)    128K(MBps)
> 128K-deg(MBps)
> 2K Seq Read     23.015089       33.293993       25.415035       32.66=
9278
> 2K Seq Write    27.363041       30.555328       14.185889       16.08=
7862
> 64K Seq Read    22.952559       44.414774       26.02711        44.03=
6993
> 64K Seq Write   25.171833       32.67759        13.97861        15.61=
8126

Very interesting !

>=20
> Some conclusions:
> 1. "Degraded" raid5 has better (sequential) read/write performances. =
The
> biggest difference is in 64k sequential read, almost doubled.
> 2. Bigger chunk size makes less difference between non-degraded and d=
egraded
> RAID5. This is due to less seek penalty for bigger chunksize raid5 ac=
cording
> to Jakob's theory.
> 3. Bigger chunk size makes worse write performance. Why? Maybe somebo=
dy can
> explain this.

I'm going wild-guessing on (3) here...

It could be, that while you are writing your file, a write smaller than
your chunk size is scheduled by the VM (or something - I'm not exactly =
a
block/VM interaction wizard) - so a 128k parity block is written out.
Some time later, the rest of the parity block is scheduled for writing,
and the same but recalculated 128k parity block is written out once
again.

Neil, or anyone else with more kernel understanding than me, please
comment on that   :)

A work-around for this, as I see it, would be to change the RAID-5
driver so that it - during *writing* only - internally works on 512 byt=
e
"sub-chunks" *no*matter* the actual chunk size on the array.

This does not break compatibility with existing RAIDs as I see it - no
additional information is needed in the superblock either. I think this
optimization could be done completely transparently.

I'd love to come up with a patch, but there's a zero likelihood of that
happening before the weekend.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
