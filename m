From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 13:29:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021113122957.GE22407@unthought.net>
References: <aqou9k$ou5$1@cesium.transmeta.com> <20021112162205.GB22407@unthought.net> <15825.22660.685310.237185@notabene.cse.unsw.edu.au> <20021113021343.GC22407@unthought.net> <15825.51226.122496.604304@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15825.51226.122496.604304@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 13, 2002 at 02:33:46PM +1100, Neil Brown wrote:
=2E..
> > The benchmark goes:
> >=20
> > | some tests on raid5 with 4k and 128k chunk size. The results are =
as follows:
> > | Access Spec     4K(MBps)        4K-deg(MBps)    128K(MBps) 128K-d=
eg(MBps)
> > | 2K Seq Read     23.015089       33.293993       25.415035  32.669=
278
> > | 2K Seq Write    27.363041       30.555328       14.185889  16.087=
862
> > | 64K Seq Read    22.952559       44.414774       26.02711   44.036=
993
> > | 64K Seq Write   25.171833       32.67759        13.97861   15.618=
126
> >=20
> > So down from 27MB/sec to 14MB/sec running 2k-block sequential write=
s on
> > a 128k chunk array versus a 4k chunk array (non-degraded).
>=20
> When doing sequential writes, a small chunk size means you are more
> likely to fill up a whole stripe before data is flushed to disk, so i=
t
> is very possible that you wont need to pre-read parity at all.  With =
a
> larger chunksize, it is more likely that you will have to write, and
> possibly read, the parity block several times.

Except if one worked on 4k sub-chunks - right  ?   :)

>=20
> So if you are doing single threaded sequential accesses, a smaller
> chunk size is definately better.

Definitely not so for reads - the seeking past the parity blocks ruin
sequential read performance when we do many such seeks (eg. when we hav=
e
small chunks) - as witnessed by the benchmark data above.

> If you are doing lots of parallel accesses (typical multi-user work
> load), small chunk sizes tends to mean that every access goes to all
> drives so there is lots of contention.  In theory a larger chunk size
> means that more accesses will be entirely satisfied from just one dis=
k,
> so there it more opportunity for concurrency between the different
> users.
>=20
> As always, the best way to choose a chunk size is develop a realistic
> work load and test it against several different chunk sizes.   There
> is no rule like "bigger is better" or "smaller is better".

=46or a single reader/writer, it was pretty obvious from the above that
"big is good" for reads (because of the fewer parity block skip seeks),
and "small is good" for writes.

So, by making a big chunk-sized array, and having it work on 4k
sub-chunks for writes, was some idea I had which I felt would just give
the best scenario in both cases.

Am I smoking crack, or ?  ;)

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
