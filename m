From: NeilBrown <neilb@suse.de>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Thu, 15 May 2014 17:18:53 +1000
Message-ID: <20140515171853.4cdfddd0@notabene.brown>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
	<20120528113145.1b8ac4ab@notabene.brown>
	<CAAOsTSmvGOwhmFW4PRfkmVnSApNKrsZfa6RAbjEhwQh-+ko1vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FruSW=9p0ouqBF+.m2hB_lS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmvGOwhmFW4PRfkmVnSApNKrsZfa6RAbjEhwQh-+ko1vQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FruSW=9p0ouqBF+.m2hB_lS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 May 2014 09:04:27 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> Hello Neil,
>=20
> did you make some progress on this issue by any chance?

No I haven't - sorry.
After 2 year, I guess I really should.

I'll make another note for first thing next week.

NeilBrown


>=20
> I am hitting the same problem again on degraded RAID 6 missing two
> drives, kernel Debian 3.13.10-1, mdadm v3.2.5.
>=20
> Thanks.
>=20
> Patrik
>=20
> 2012-05-28 3:31 GMT+02:00 NeilBrown <neilb@suse.de>:
> >
> > On Thu, 24 May 2012 14:37:28 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> w=
rote:
> >
> > > On Thu, May 24, 2012 at 6:48 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > > > Firstly, degraded RAID6 with a left-symmetric layout is quite diffe=
rent from
> > > > an optimal RAID5 because there are Q blocks sprinkled around and so=
me D
> > > > blocks missing.  So there will always be more work to do.
> > > >
> > > > Degraded left-symmetric-6 is quite similar to optimal RAID5 as the =
same data
> > > > is stored in the same place - so reading should be exactly the same.
> > > > However writing is generally different and the code doesn't make an=
y attempt
> > > > to notice and optimise cases that happen to be similar to RAID5.
> > >
> > > Actually I have left-symmetric-6 without one of the "regular" drives
> > > not the one with only Qs on it, so it should be similar to degraded
> > > RAID6 with a left-symmetric in this regard.
> >
> > Yes, it should - I had assumed wrongly ;-)
> >
> > >
> > > > A particular issue is that while RAID5 does read-modify-write when =
updating a
> > > > single block in an array with 5 or more devices (i.e. it reads the =
old data
> > > > block and the parity block, subtracts the old from parity and adds =
the new,
> > > > then writes both back), RAID6 does not. It always does a reconstruc=
t-write,
> > > > so on a 6-device RAID6 it will read the other 4 data blocks, comput=
e P and Q,
> > > > and write them out with the new data.
> > > > If it did read-modify-write it might be able to get away with readi=
ng just P,
> > > > Q, and the old data block - 3 reads instead of 4.  However subtract=
ing from
> > > > the Q block is more complicated that subtracting from the P block a=
nd has not
> > > > been implemented.
> > >
> > > OK, I did not know that. In my case I have 8 drives RAID6 degraded to
> > > 7 drives, so it would be plus to have it implemented the RAID5 way.
> > > But anyway I was thinking the whole-stripe detection should work in
> > > this case.
> > >
> > > > But that might not be the issue you are hitting - it simply shows t=
hat RAID6
> > > > is different from RAID5 in important but non-obvious ways.
> > > >
> > > > Yes, RAID5 and RAID6 do try to detect whole-stripe write and write =
them out
> > > > without reading.  This is not always possible though.
> > > > Maybe if you told us how many devices were in your arrays (which ma=
y be
> > > > import to understand exactly what is happening), what the chunk siz=
e is, and
> > > > exactly what command you use to write "lots of data".  That might h=
elp
> > > > understand what is happening.
> > >
> > > The RAID5 is 5 drives, the RAID6 arrays are 7 of 8 drives, chunk size
> > > is 64K. I am using command dd if=3D/dev/zero of=3Dfile bs=3DX count=
=3DY, it
> > > behaves the same for bs between 64K to 1 MB. Actually internal read
> > > speed from every drive is slightly higher that write speed, about cca
> > > 10%. The ratio between write speed to the array and write speed to
> > > individual drive is cca 5.5 - 5.7.
> >
> > I cannot really picture how the read speed can be higher than the write
> > speed.  The spindle doesn't speed up for reads and slow down for writes=
 does
> > it?  But that's not really relevant.
> >
> > A 'dd' with large block size should be a good test.  I just did a simple
> > experiment.  With a 4-drive non-degraded RAID6 I get about a 1:100 rati=
o for
> > reads to writes for an extended write to the filesystem.
> > If I fail one device it becomes 1:1.  Something certainly seems wrong t=
here.
> >
> > RAID5 behaves more as you would expect - many more writes than reads.
> >
> > I've made a note to look into this when I get a chance.
> >
> > Thanks for the report.
> >
> > NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/FruSW=9p0ouqBF+.m2hB_lS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3RqXTnsnt1WYoG5AQLRXQ//YXlUTaHBCungUBcg1YvmRpa0Wu8UajgI
YPn+ss7tHwCteo91UzjpGIe2XkGclneRAqurbNNaN5mn0qoi+0wYPn40exxisXfP
3LLsD89lpeppl+E/XRWbS9T0plTAkKfErSDNILd7tWE7f2Zk7xc3mPqu3jgT7QON
Om6SuDklbMWC376L2CLhY7P2ZaRnKUS94dmCqL427QmUyvL8G7R6NN2OucrnqDtM
giSzJeNQevmV6zPHJ3giiNDW0S6dtiaVqt7C4Ll5uQ9DbvmvdwnW5YYw5ZEUGvYl
Hd/56Sldb778xi0rODTTns9b/1QRrBIo/o5qoVjihpQ0dk6OljLLjK0b4t4kruT8
GAcRwMbjPgDrJbRJz8p25CyWXnlgUcISPRwu0cxa+WcAO/p6U7yooAQIu9m3YrzF
/lhZ3rXnVVxBneMJqGdfkG8bdklb6rUHEtJbLJ/4j6tIBaXd/dYJ+crsHQkGNxc4
2jJ4Jvl/aZ/BWve8p34tUCUIsEncC0arP1kjkPOchgdNWwDV7aFoSeFjD77N95OG
5NsVC2Q9fAJS+YE90s/mHj8lXmcLodmA14ZaxhLNXffWqHMBEeiyFUTmpoZwgq8W
rf5/YjhHMW4mI6r9K5u50tshp/hQ7UVBDKpp9b3BeiNEo41Cmnq0RZQlZcZm/c/v
FRJW41WCQtc=
=BfXM
-----END PGP SIGNATURE-----

--Sig_/FruSW=9p0ouqBF+.m2hB_lS--
