From: Hendrik Naumann <hn75@gmx.de>
Subject: Re: [Fwd: Re: recorvery from Raid5 multiple disk failture]
Date: Mon, 19 Dec 2005 15:34:52 +0100
Message-ID: <200512191534.53200.hn75@gmx.de>
References: <1134753999.6929.4.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2999826.aDE6xTcq0C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1134753999.6929.4.camel@star2.austin.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart2999826.aDE6xTcq0C
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

Our suggestion worked out nicely so I could recover the data from the=20
raid.

Thanks=20

Hendrik Naumann


Am Freitag, 16. Dezember 2005 18:26 schrieben Sie:
> On Fri, 2005-12-16 at 06:45, Hendrik Naumann wrote:
> > Hi
> >
> > I have a Linux-Software-Raid5 consisting of three partitions
> > (hda2, hde2 and hdf2). After a failure of hdf I replaced the disk
> > and added hdf2 into the raid again. During the resynchronization
> > process hda broke down.
> >
> > I am not completely shure how much of the synchronization
> > was already done, but I think it was quite at the end, because
> > the gzipped dd-image of hdf2 and hde2 have very similar sizes.
> >
> > mdadm shows hde2 as a active, clean disk within the raid and hdf2
> > as a clean spare disk. In the Software-Raid-Howto it was stated
> > that rewriting the superblocks (I suspect hdf2 to clean active)
> > could be a possibility to regain some data from the Raid.
> >
> > How is this possible with mdadm? Or is there some other tool for
> > manipulation the superblocks?
> >
> > Many thanks in advance
> >
> > Hendrik Naummann
> >
> > PS. Please add a CC hn75@gmx.de because up to now I am no
> > subscriber to this list.
>
> Since the recovery did not finish, I would do the followings:
>
> mdadm --examine /dev/hde2 to display the raid5 configuration and
> note the chunksize, parity layout, disks order,..
> Recreate the array using mdadm -C with "missing" keyword
> Mount the raid5 array read-only (hope that it will mount :)


=2D-=20
PGP ID 65C92061

--nextPart2999826.aDE6xTcq0C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDpsUNIfCsAmXJIGERApq+AJ9Ej3Fgqt2VLRuA4OObBMfUfrBfiACdGUZa
a6MHnJ/U3ZsVmBce3wG13hM=
=Lemw
-----END PGP SIGNATURE-----

--nextPart2999826.aDE6xTcq0C--
