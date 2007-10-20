From: Doug Ledford <dledford@redhat.com>
Subject: Re: chunk size (was Re: Time to deprecate old RAID formats?)
Date: Sat, 20 Oct 2007 09:29:04 -0400
Message-ID: <1192886944.1666.124.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
	 <18200.57042.989520.666476@stoffel.org>
	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
	 <1192813477.1666.74.camel@firewall.xsintricity.com>
	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
	 <1192814581.1666.87.camel@firewall.xsintricity.com>
	 <47193314.5010606@ziu.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Igb3LY9jZGA+T0GuZiVy"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47193314.5010606@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <nozo@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Igb3LY9jZGA+T0GuZiVy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 00:43 +0200, Michal Soltys wrote:
> Doug Ledford wrote:
> > course, this comes at the expense of peak throughput on the device.
> > Let's say you were building a mondo movie server, where you were
> > streaming out digital movie files.  In that case, you very well may car=
e
> > more about throughput than seek performance since I suspect you wouldn'=
t
> > have many small, random reads.  Then I would use a small chunk size,
> > sacrifice the seek performance, and get the throughput bonus of paralle=
l
> > reads from the same stripe on multiple disks.  On the other hand, if I
> >=20
>=20
> Out of curiosity though - why wouldn't large chunk work well here ? If yo=
u=20
> stream video (I assume large files, so like a good few MBs at least), the=
=20
> reads are parallel either way.

Well, first I was thinking of files in the few hundreds of megabytes
each to gigabytes each, and when they are streamed, they are streamed at
a rate much lower than the full speed of the array, but still at a fast
rate.  How parallel the reads are then would tend to be a function of
chunk size versus streaming rate.  I guess I should clarify what I'm
talking about anyway.  To me, a large chunk size is 1 to 2MB or so, a
small chunk size is in the 64k to 256k range.  If you have a 10 disk
raid5 array with a 2mb chunk size, and you aren't just copying files
around, then it's hard to ever get that to do full speed parallel reads
because you simply won't access the data fast enough.

> Yes, the amount of data read from each of the disks will be in less perfe=
ct=20
> proportion than in small chunk size scenario, but it's pretty neglible.=20
> Benchamrks I've seen (like Justin's one) seem not to care much about chun=
k=20
> size in sequential read/write scenarios (and often favors larger chunks).=
=20
> Some of my own tests I did few months ago confirmed that as well.

I'm not familiar with the benchmark you are referring to.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Igb3LY9jZGA+T0GuZiVy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGgKfTzP9PM7pjw8RArE5AJ0T54MxOnYcn9I6rSI5cBh+AKFnNgCfU3ZD
mGT6IAM94OtZ2wSArMTWmLY=
=StSI
-----END PGP SIGNATURE-----

--=-Igb3LY9jZGA+T0GuZiVy--

