From: NeilBrown <neilb@suse.de>
Subject: Re: Advice recovering from interrupted grow on RAID5 array
Date: Wed, 16 Oct 2013 16:26:25 +1100
Message-ID: <20131016162625.628c5558@notabene.brown>
References: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ke+bTZut5Hcn/bArBaJhOZO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Yates <jyates65@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ke+bTZut5Hcn/bArBaJhOZO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Oct 2013 21:59:45 -0400 John Yates <jyates65@gmail.com> wrote:

> Midway through a RAID5 grow operation from 5 to 6 USB connected
> drives, system logs show that the kernel lost communication with some
> of the drive ports which has left my array in a state that I have not
> been able to reassemble. After reseating the cable connections and
> rebooting, all of the drives appear to be functioning normally, so
> hopefully the data is still intact. I need advice on recovery steps
> for the array.
>=20
> It appears that each drive failed in quick succession with /dev/sdc1
> being the last standing and having the others marked as missing in its
> superblock. The superblocks of the other drives show all drives as
> available. (--examine output below)
>=20
> >mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev=
/sdf1 /dev/sdg1
> mdadm: too-old timestamp on backup-metadata on device-5
> mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW_OL=
D=3D1'
> mdadm: /dev/md127 assembled from 1 drives - not enough to start the array.

Did you try following the suggestion and run

 export MDADM_GROW_ALLOW_OLD=3D1

and the try the --asssemble again?

NeilBrown

--Sig_/Ke+bTZut5Hcn/bArBaJhOZO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl4jgTnsnt1WYoG5AQI2tQ//SzDCyHh219jfRRX4yMZNYyVglmMErkdP
ZeGdIcNzRXZOcNmIIA4Gig7UZzM0zhhPIUG7LBJjJ5CUpADVPcNapWVMqTQ6vqQ3
Y6B+zaXQOMmbtY6ChwKe9B+Q9jqfBRxYo4r8HUWZ8RMda3s12efkHMErH9ysB0cC
j3E5juCNw0gCtebNPVq+X91ZMGsi4YSvnRNXPHY4hi0nIX8RQ+mtkLmd8hwViAA/
sgT8ByaCHD6z0asCDu84KnLbIN78lKM3W7TAqie8J2kMpHMoqZ73WIaI44LXGZ+1
m0B4kytn2gP9ZLSxbaUZfWWCon0hVf/42NDY70wmgf1vzZKpGpD2dHWAYExSSQin
b9xzLlbPKd+ckxznvwi6vYsDzc6H9H9ns/CW7cx5hliLavKZ02bGuUBsQQWIpWDL
IoQ7P2MOryylHFdq3dhLCJmpTPjNG+pM26mf6B3NbjnFtJCmfq5ZyvsJVdfo9vBr
2/XVKCKAjk0sS1ydzCRNl2/STUfqC0DlKRcoQBudjC0NBsKMADNCqPdnnUAJgMms
4towmsfxnnuQJ/7TT57thRs8Bxb3kNcwOow8MvmOViU13xIQmXmqBG3VW7SboiEk
2a4D2VbX2RR74RbsvHZUtPgPY0sWqWKP/IcvBQ8eNjZZlbyJq+/wkcYSOtPu9zzI
sXe1tr0Bdg4=
=u0yl
-----END PGP SIGNATURE-----

--Sig_/Ke+bTZut5Hcn/bArBaJhOZO--
