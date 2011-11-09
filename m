From: NeilBrown <neilb@suse.de>
Subject: Re: mini change of raid5.c
Date: Thu, 10 Nov 2011 09:15:47 +1100
Message-ID: <20111110091547.19b96e9b@notabene.brown>
References: <4EBA5E5D0200004000001B21@ptbl-mail.dnsalias.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r/4w6juTea.s97GO3pgNgUd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBA5E5D0200004000001B21@ptbl-mail.dnsalias.net>
Sender: linux-raid-owner@vger.kernel.org
To: Hardy Flor <Flor@ptbl-gmbh.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/r/4w6juTea.s97GO3pgNgUd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Nov 2011 11:05:01 +0100 "Hardy Flor" <Flor@ptbl-gmbh.de> wrote:

> Hello Mr Brown,
>=20
> can you please transmit this small change to the file raid5.c? There is
> thus a rapid repair of a raid6 possible, using only the defective areas
> must be checked. This change writes only the error position in the log
> during the function "check".
>=20
> Kind regards
>=20
> Hardy Flor

Hi Hardy,
 thanks for suggesting that change.

There a couple of problems with it that would need to be fixed though.

Firstly, it print the 'Q' block for RAID5.  However there is no Q block for
RAID5 so that is just distracting noise which is easy to remove.

Secondly - and more significantly - if you create a new RAID6 array with th=
is
patch, you can expect every stripe to have incorrect parity, so you will get
a message for every single stripe which would not be good.

I don't really think that printk is the best way to get useful data from the
kernel.  I would prefer that raid5 kept a list of sectors internally and ma=
de
them available through a file in sysfs. e.g. ..../md/mismatch_list.
You could then enhance raid6check.c (part of 'mdadm') to read that file and
explain exactly what is happening at each offset.

We would need to limit the number of addresses reported.  If we just
allocated one page and treated it as an array of 256 64bit numbers that wou=
ld
probably be sufficient.

Would you like to try coding that approach?

Thanks,
NeilBrown

--Sig_/r/4w6juTea.s97GO3pgNgUd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrr7kznsnt1WYoG5AQImSA/8DKRT6mOzwsozTTRr33WHD2NbQEPCDJ9m
fX4Kq47yh3KwAm473jB0EdxSAc6JFsz1GrhfwiZMMQbcYhJInZcp4Mv2WLhdnVlb
RiDGlwYXk+T1IXHBz+Y8a4+sP8L8XNi2O/bqKlIjFzPA7yu+NdQXxpggI8YyPFrU
861wDpYtVz+PL7nlsxrUExCosxvQEzaaNDJ+j0K8dm4Y+ZVd1zvYZDqHtokaOZSe
HjM6vbRXvutO3dfBdoTteyixe2YclX3d7eHgvdxJQpSUsIR5K9GTWpbiFvmkdeUY
2SCJQnoduzOdhr1wwXFU1W4Wa2OJmqYIcov7vgv7ILoxXwUdoV2FjH5+Jp0v/wsn
mL1ZeL0uo6Qad5BPlj6JDs35/GEoEzBVoX1ebzjquIHkPMkZ4ahNbWBC0dFgfYAy
6J8SCP1izYmUZ1ixgjqqE/zOpcdgt6INo7PY86n9nqlh2TV0Ag+s7sugg+k8t2Ok
4EywbiSLmyGxl7jdoTTSWdjPF1akeZAahtPOczAeCGODXoQEKQYtXL59qbu56Axo
9EdSbl7zqZAzEPQS9C/Trg60Y7sJPsOMpfba7H1mu9iDYr1U2Ii4y1SQwCiJADMp
EPkiXMkz09ffBHGn+d647pE4knFpb/UVew806VmNtfDx4e5UcQw1wlbDlS5RkpWl
E7mtkxVdqD0=
=uh3L
-----END PGP SIGNATURE-----

--Sig_/r/4w6juTea.s97GO3pgNgUd--
