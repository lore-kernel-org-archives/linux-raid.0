From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 03:13:43 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021113021343.GC22407@unthought.net>
References: <aqou9k$ou5$1@cesium.transmeta.com> <20021112162205.GB22407@unthought.net> <15825.22660.685310.237185@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15825.22660.685310.237185@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 13, 2002 at 06:37:40AM +1100, Neil Brown wrote:
> On Tuesday November 12, jakob@unthought.net wrote:
> >=20
> > You might want to consider using huge chunk-sizes when reading, but
> > making sure that writes can be made on "sub-chunks" - so that one c=
ould
> > run a RAID-6 with a 128k chunk size, yet have writes performed on 4=
k
> > chunks.  This is important for performance on both read and write, =
but
> > it is an optimization the current RAID-5 code lacks.
>=20
> Either I misunderstand your point, or you misunderstand the code.
>=20
> A 4k write request will cause a 4k write to a data block and a 4k
> write to a parity block, no matter what the chunk size is. (There may
> also be pre-reading, and possibly several 4k writes will share a
> parity block update).

Writes on a 128k chunk array are significantly slower than writes on a
4k chunk array, according to someone else on this list   -  I wanted to
look into this myself, but now is just a bad time for me (nothing new
on that front).

The benchmark goes:

| some tests on raid5 with 4k and 128k chunk size. The results are as f=
ollows:
| Access Spec     4K(MBps)        4K-deg(MBps)    128K(MBps) 128K-deg(M=
Bps)
| 2K Seq Read     23.015089       33.293993       25.415035  32.669278
| 2K Seq Write    27.363041       30.555328       14.185889  16.087862
| 64K Seq Read    22.952559       44.414774       26.02711   44.036993
| 64K Seq Write   25.171833       32.67759        13.97861   15.618126

So down from 27MB/sec to 14MB/sec running 2k-block sequential writes on
a 128k chunk array versus a 4k chunk array (non-degraded).

In degraded mode, the writes degenerate from 30MB/sec to 16MB/sec as th=
e
chunk-size increases.

Something's fishy.

>=20
> I see no lacking optimisation, but if you do, I would be keen to hear
> a more detailed explanation.

Well if a 4k write really only causes a 4k write to disk, even with a
128k chunk-size array, then something else is happening...

I didn't do the benchmark, and I didn't get to investigate it further
here, so I can't really say much else productive  :)


 / Jakob "linux-raid message multiplexer" =D8stergaard

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
