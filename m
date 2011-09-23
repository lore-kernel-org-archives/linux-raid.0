From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 15:11:08 +1000
Message-ID: <20110923151108.08c1199f@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923143210.583e11ec@notabene.brown>
	<201109222249.12892.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/euMt5CNEm3x96Gecwmj9ZaC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109222249.12892.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/euMt5CNEm3x96Gecwmj9ZaC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 22:49:12 -0600 Thomas Fjellstrom <tfjellstrom@shaw.ca>
wrote:

> On September 22, 2011, NeilBrown wrote:
> > On Thu, 22 Sep 2011 19:50:36 -0600 Thomas Fjellstrom <tfjellstrom@shaw.=
ca>
> >=20
> > wrote:
> > > Hi,
> > >=20
> > > I've been struggling with a SAS card recently that has had poor driver
> > > support for a long time, and tonight its decided to kick every drive =
in
> > > the array one after the other. Now mdstat shows:
> > >=20
> > > md1 : active raid5 sdf[0](F) sdh[7](F) sdi[6](F) sdj[5](F) sde[3](F)
> > > sdd[2](F) sdg[1](F)
> > >=20
> > >       5860574208 blocks super 1.1 level 5, 512k chunk, algorithm 2 [7=
/0]
> > >=20
> > > [_______]
> > >=20
> > >       bitmap: 3/8 pages [12KB], 65536KB chunk
> > >=20
> > > Does the fact that I'm using a bitmap save my rear here? Or am I hose=
d?
> > > If I'm not hosed, is there a way I can recover the array without
> > > rebooting? maybe just a --stop and a --assemble ? If that won't work,
> > > will a reboot be ok?
> > >=20
> > > I'd really prefer not to have lost all of my data. Please tell me
> > > (please) that it is possible to recover the array. All but sdi are st=
ill
> > > visible in /dev (I may be able to get it back via hotplug maybe, but
> > > it'd get sdk or something).
> >=20
> > mdadm --stop /dev/md1
> >=20
> > mdadm --examine /dev/sd[fhijedg]
> > mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
> >=20
> > Report all output.
> >=20
> > NeilBrown
>=20
> Hi, thanks for the help. Seems the SAS card/driver is in a funky state at=
 the=20
> moment. the --stop worked*. but --examine just gives "no md superblock=20
> detected", and dmesg reports io errors for all drives.
>=20
> I've just reloaded the driver, and things seem to have come back:

That's good!!


>=20
> root@boris:~# mdadm --examine /dev/sd[fhijedg]
....

sd1 has a slightly older event count than the others - Update time is 1:13
older.  So it presumably died first.

>=20
> root@boris:~# mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdd is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sdf is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdg is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdh is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sdi is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdj is identified as a member of /dev/md1, slot 4.
> mdadm: added /dev/sdg to /dev/md1 as 1
> mdadm: added /dev/sdd to /dev/md1 as 2
> mdadm: added /dev/sde to /dev/md1 as 3
> mdadm: added /dev/sdj to /dev/md1 as 4
> mdadm: added /dev/sdi to /dev/md1 as 5
> mdadm: added /dev/sdh to /dev/md1 as 6
> mdadm: added /dev/sdf to /dev/md1 as 0
> mdadm: /dev/md1 has been started with 6 drives (out of 7).
>=20
>=20
> Now I guess the question is, how to get that last drive back in? would:=20
>=20
> mdadm --re-add /dev/md1 /dev/sdi=20
>=20
> work?
>=20

re-add should work, yes.  It will use the bitmap info to only update the
blocks that need updating - presumably not many.
It might be interesting to run
  mdadm -X /dev/sdf

first to see what the bitmap looks like - how many dirty bits and what the
event counts are.

But yes: --re-add should make it all happy.

NeilBrown


--Sig_/euMt5CNEm3x96Gecwmj9ZaC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfBTsG5fc6gV+Wb0RAmT2AKC7kFqp01utSc73hshE3hyqrjBNIACguo++
oN1exB3d3gctzE+tBmc/VME=
=Y1QP
-----END PGP SIGNATURE-----

--Sig_/euMt5CNEm3x96Gecwmj9ZaC--
