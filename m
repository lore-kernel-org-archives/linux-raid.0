From: NeilBrown <neilb@suse.de>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Mon, 28 May 2012 11:31:45 +1000
Message-ID: <20120528113145.1b8ac4ab@notabene.brown>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TscLpAqKetOtv2mR5BeFuk4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TscLpAqKetOtv2mR5BeFuk4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 24 May 2012 14:37:28 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> On Thu, May 24, 2012 at 6:48 AM, NeilBrown <neilb@suse.de> wrote:

> > Firstly, degraded RAID6 with a left-symmetric layout is quite different=
 from
> > an optimal RAID5 because there are Q blocks sprinkled around and some D
> > blocks missing. =A0So there will always be more work to do.
> >
> > Degraded left-symmetric-6 is quite similar to optimal RAID5 as the same=
 data
> > is stored in the same place - so reading should be exactly the same.
> > However writing is generally different and the code doesn't make any at=
tempt
> > to notice and optimise cases that happen to be similar to RAID5.
>=20
> Actually I have left-symmetric-6 without one of the "regular" drives
> not the one with only Qs on it, so it should be similar to degraded
> RAID6 with a left-symmetric in this regard.

Yes, it should - I had assumed wrongly ;-)

>=20
> > A particular issue is that while RAID5 does read-modify-write when upda=
ting a
> > single block in an array with 5 or more devices (i.e. it reads the old =
data
> > block and the parity block, subtracts the old from parity and adds the =
new,
> > then writes both back), RAID6 does not. It always does a reconstruct-wr=
ite,
> > so on a 6-device RAID6 it will read the other 4 data blocks, compute P =
and Q,
> > and write them out with the new data.
> > If it did read-modify-write it might be able to get away with reading j=
ust P,
> > Q, and the old data block - 3 reads instead of 4. =A0However subtractin=
g from
> > the Q block is more complicated that subtracting from the P block and h=
as not
> > been implemented.
>=20
> OK, I did not know that. In my case I have 8 drives RAID6 degraded to
> 7 drives, so it would be plus to have it implemented the RAID5 way.
> But anyway I was thinking the whole-stripe detection should work in
> this case.
>=20
> > But that might not be the issue you are hitting - it simply shows that =
RAID6
> > is different from RAID5 in important but non-obvious ways.
> >
> > Yes, RAID5 and RAID6 do try to detect whole-stripe write and write them=
 out
> > without reading. =A0This is not always possible though.
> > Maybe if you told us how many devices were in your arrays (which may be
> > import to understand exactly what is happening), what the chunk size is=
, and
> > exactly what command you use to write "lots of data". =A0That might help
> > understand what is happening.
>=20
> The RAID5 is 5 drives, the RAID6 arrays are 7 of 8 drives, chunk size
> is 64K. I am using command dd if=3D/dev/zero of=3Dfile bs=3DX count=3DY, =
it
> behaves the same for bs between 64K to 1 MB. Actually internal read
> speed from every drive is slightly higher that write speed, about cca
> 10%. The ratio between write speed to the array and write speed to
> individual drive is cca 5.5 - 5.7.

I cannot really picture how the read speed can be higher than the write
speed.  The spindle doesn't speed up for reads and slow down for writes does
it?  But that's not really relevant.

A 'dd' with large block size should be a good test.  I just did a simple
experiment.  With a 4-drive non-degraded RAID6 I get about a 1:100 ratio for
reads to writes for an extended write to the filesystem.
If I fail one device it becomes 1:1.  Something certainly seems wrong there.

RAID5 behaves more as you would expect - many more writes than reads.

I've made a note to look into this when I get a chance.

Thanks for the report.

NeilBrown

--Sig_/TscLpAqKetOtv2mR5BeFuk4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8LVgTnsnt1WYoG5AQKd2hAAtfr6bYUxct3BrNcLvvI0hVQnB9wyPDB0
OQjG9HekHiORovVVSqm1fGJKn2i3K5aDD78iAAHHDzhhJ1ja+SKON2NVLq+hycf1
CPk9xsw/HXg2lbq2F0M30Jhn9538KitLHeznL5jjgk5CWJ/n+7DC2tdEdGa0Yv/9
Dol1VGiJUc4fChZrCnx8OClLT9UBqoN5xxwhnbMCr1bIS/JE/Frh3RdQ3TgzzRyN
idF9+5PPKNUAnaZaNvKwocENH/Se0NSx/d1TXhb+2sIn1xCpsBqry3eLJ3HJqWzK
tLDFZrbop5jMIJjhOMxj9dhx+xAQ7DKalVwLajeOsqZtYwUs5PaXW+peZfD/JDfK
46Hsq/zG3sLEh755qCe9dZdNgeOQRdv26xTbqDRg3MJ82D1Drp5H195NdoQbnt2+
c+/u512WQEr5dOwbf/eK5G+tzQusk9sqqlaMndzOiiWE1CI3Ojfpcc9uFahSCD5U
ejXeKyHZUHRt66Q87PL5et8sGD4rvzgBVo1UYhw0R7q3a7RDHHBj889vXrHN3/NF
LLovSOEH57/tpU+RnsaGOjTO+v4l9hGWFuL6XzROaJpK5EbTr4vZzJghzMR6hbo6
xppYWWslYTWvK6Xtzr9ibRwp4EuuSNK/xIfS2kmfouU/gvDX2EQY5KiZPK8HV71u
/bqmd5y+RkI=
=uaT8
-----END PGP SIGNATURE-----

--Sig_/TscLpAqKetOtv2mR5BeFuk4--
