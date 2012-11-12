From: NeilBrown <neilb@suse.de>
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Tue, 13 Nov 2012 07:31:19 +1100
Message-ID: <20121113073119.27f1a1db@notabene.brown>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
	<6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
	<6.2.5.6.2.20121112131017.05df8b18@binnacle.cx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fd5/FKUKOWL2gqnpSn.2+fn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121112131017.05df8b18@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: starlight.2012q4@binnacle.cx
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fd5/FKUKOWL2gqnpSn.2+fn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Nov 2012 13:11:50 -0500 starlight.2012q4@binnacle.cx wrote:

> Probably this is more elegant:
>=20
>    mdadm --create --level=3D1 --raid-devices=3D2 --spare-devices=3D1 /dev=
/sdd /dev/sde missing

That is fairly meaningless ... I'm not sure it even works.

While it makes sense for raid devices to be missing, it doesn't make sense
for spares to be missing.  Spares are just just any devices in the array
which aren't active.  If they are missing, then they aren't spare.

NeilBrown


>=20
> At 12:26 PM 11/12/2012 -0500, starlight.2012q4@binnacle.cx wrote:
> >After some pondering, think I've figure it out.
> >
> >Best way to go is to set it up with
> >
> >  --create --level=3D1 --raid-devices=3D2
> >
> >for the initial pair of drives, then
> >
> >  --fail --remove
> >
> >the rotate-out drive, then
> >
> >  --add
> >
> >the alternate drive.  Now there will be
> >three drive slots with one "removed" and two
> >"active".
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/fd5/FKUKOWL2gqnpSn.2+fn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKFclznsnt1WYoG5AQJ8JBAAksGn1KoNjQ+RuS0FyUn4CeSh0g3jpcrb
iiqp1IKhIqQwTHnhwlVCQZbrvSUOEMCCPlritHHrrwoWxbPaGXaEe8nxI0cDVvIU
wICD/nI0EUcLsVtwe2rYD+zccvR88+M78kh66OUZffnVz60jMP2ik7Wh8HDS6/IE
xkJHhf+jjnCdPsENJEDAv2+FKxHLCeXvBHq/pZojubzLi4ZQ6a90ziL4opI/WGgO
H1sbICgi0wBPWaFHRpT9sA9pEoTiJMNR/RSFK/2S6+BDGbeR4R+16MP0aBEVKC37
IS3TAfoCA50bHi5K89KGOKGk90kB2gtA0qq/sETZlbYH6Xd7pY/DFf8JtH/H3aDj
VcrSG//n2Nu75mPcQW4curR0XbS8IW6SNC9hq16lpX1m/hkLT25eN74Jq0tKYCr3
fRV2xwtF/Pf3frirawer8HBNW+s4ZNtlZejVLFZ28LTW+1X7wDwnR+qDTE7Bwl2z
pMeeYKQbh7gyBwMXMkJ93FM193ZPzg9PV9Nac6xv9LfN6HLQgO+E9OPrdHODyBZh
OIJ5SyTTz2NnAMkFDTsmzHYPfe6oT1KW7efIGAUGyYr+tFum7KiDcoovswcMGIk8
G9pGvqeFuvwn/GI548CqsRz7uJy0XhbbkS+AL7mIoABjzuy8PfR5IDJomUN/rZZu
YHcj1Qfd89s=
=bdpx
-----END PGP SIGNATURE-----

--Sig_/fd5/FKUKOWL2gqnpSn.2+fn--
