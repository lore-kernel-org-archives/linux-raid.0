From: NeilBrown <neilb@suse.de>
Subject: Re: Help with recovering a RAID5 array
Date: Mon, 6 May 2013 16:31:02 +1000
Message-ID: <20130506163102.066b9264@notabene.brown>
References: <34199580.p6EyCyMeIZ@chablis>
	<CANU9nTnwx_3m3Ggebxgfe1RqKU6OMk59qnhecSmYvmC2cUeRnw@mail.gmail.com>
	<1838659.cc600uVROo@rattle>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Fra.4G=JduEvOru8juSfDiW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1838659.cc600uVROo@rattle>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Borggraefe <stefan@spybot.info>
Cc: Ole Tange <tange@binf.ku.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Fra.4G=JduEvOru8juSfDiW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 04 May 2013 13:13:27 +0200 Stefan Borggraefe <stefan@spybot.info>
wrote:

> Am Freitag, 3. Mai 2013, 10:38:52 schrieben Sie:
> > On Thu, May 2, 2013 at 2:24 PM, Stefan Borggraefe <stefan@spybot.info>=
=20
> wrote:
> > > I am using a RAID5 software RAID on Ubuntu 12.04
> > >=20
> > > It consits of 6 Hitachi drives with 4 TB and contains an ext 4 file
> > > system.
> > >=20
> > > When I returned to this server this morning, the array was in the
> > > following
> > > state:
> > >=20
> > > md126 : active raid5 sdc1[7](S) sdh1[4] sdd1[3](F) sde1[0] sdg1[6] sd=
f1[2]
> > >=20
> > >       19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [=
6/4]
> > >=20
> > > [U_U_UU]
> > >=20
> > > sdc is the newly added hard disk, but now also sdd failed. :( It woul=
d be
> > > great if there was a way to have the this RAID5 working again. Perhaps
> > > sdc1
> > > can then be fully added to the array and after this drive sdd also
> > > exchanged.
> > I have had a few raid6 fail in a similar fashion: the 3rd drive
> > faliing during rebuild (Also 4 TB Hitachi by the way).
> >=20
> > I tested if the drives were fine:
> >=20
> >   parallel dd if=3D{} of=3D/dev/null bs=3D1000k ::: /dev/sd?
> >=20
> > And they were all fine.=20
>=20
> Same for me.
>=20
> > With only a few failing sectors (if any) I figured that very little
> > would be lost by forcing the failing drive online. Remove the spare
> > drive, and force the remaining online:
> >=20
> >   mdadm -A --scan --force
>=20
> I removed the spare /dev/sdc1 from /dev/md126
>=20
> with
>=20
> mdadm /dev/md126 --remove /dev/sdc1
>=20
> After mdadm -A --scan --force the array is now in this state
>=20
> md126 : active raid5 sdh1[4] sdd1[3](F) sde1[0] sdg1[6] sdf1[2]
>       19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/4]=
=20
> [U_U_UU]

Did you stop the array first?
  i.e.
    mdadm --stop /dev/md126
    mdadm -Asfvv

NeilBrown


> =20
> > Next step is to do fsck.
>=20
> I think this is not possible yet at this point. Don't I need to reassembl=
e the=20
> array using the --assume-clean option and with one missing drive first? S=
ome=20
> step is missing here.
>=20
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Fra.4G=JduEvOru8juSfDiW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYdOJjnsnt1WYoG5AQIOVg/9GVTrzcafD2Ma6TJwh2DVgJAP7OJox+uY
d/QF6midWhxUYzqSHq0VI7Y5ur7sfw+Vn7hnG8h7nTbqYqyl2cs6j+pFKH3srYn1
ibCxxBU7ImW+J6OuwAHmODIVai42nx3HzRWlXFZ/9fIa5Ot/3fRk4SYHbIO5poaG
nE1xhPTvClakTqPyGlNptNovSLWMePWxIBbaIpsCu7G/CEjKXj1vCUpb8P8dfMK8
unEwn0mUobzO1GBa4sHE7TenkoQGusPLt9nrDGaUJ6MLX22O0FsJuZlHTyQ6s/oH
Gky3hc+NtXv6xAifqald6sMYpTYcEa/s+4dYDZK6gEo55LtY8MbAygiSYzIqQh/i
bzTvsdQbtRZ8hy/jDFbM6Tzc22wKO4Z3QhOtKJ9HGhO+hmWet1o+jClf8E52k0es
pPm4nDAGiiAzezyZRlDLfqgOg71k41dVslEECoExyM7hB3Xt1Fl9wvmQwOiIt1RR
YmZyhwAz9AXF9GqEYaoayq/3oABIgSeIkpWtUCMOA3vCzoObpatWo20tkuYLJcna
UGQfnCxbmSAWOdCWRpWjO5ZMXKCWEisplOWe/+ehNuWM7PC5xKDg/DT1c0U8lXyt
uO2JQEKqhXIJh8heOGHSSTfdqPVD119FSi3rTas6nJaqjoSkwmzCgEUzIsrBGNJu
dVr+EmH5bTE=
=l9AY
-----END PGP SIGNATURE-----

--Sig_/Fra.4G=JduEvOru8juSfDiW--
