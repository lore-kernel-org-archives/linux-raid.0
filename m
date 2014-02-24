From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm won't remove drive from array
Date: Tue, 25 Feb 2014 08:54:16 +1100
Message-ID: <20140225085416.478dc97e@notabene.brown>
References: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d0mM4sEzY/0J9eVFV_K6vqK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/d0mM4sEzY/0J9eVFV_K6vqK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Feb 2014 11:51:00 +0100 Caspar Smit <c.smit@truebit.nl> wrote:

> Hi all,
>=20
> I'm having trouble removing a failed drive from an array.
>=20
> #cat /proc/mdstat
>=20
> md5 : active raid6 sdn[14](S) sdm[13](S) sdad[12] sdl[11] sdba[10]
> sde[0](F) sdd[9] sdc[8] sdk[7] sdj[6] sdi[5] sdh[3] sdg[2]
>       15628103680 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
>=20
> The drive in question is sde
>=20
> #mdadm --remove /dev/md5 /dev/sde
> mdadm: cannot find /dev/sde: No such file or directory
>=20
> The drive crashed so hard it is not visible to the kernel anymore.
>=20
> # cat /proc/partitions |grep sde
> <no output>
>=20
> Normally in such case i do:
>=20
> #mdadm --remove /dev/md5 detached
> <no output>
>
> The drive remains in the array.

Odd.  This suggests that /dev/sde has been removed (presumably by udev) but
that if you create a device with the appropriate major/minor numbers, the
device can be opened.  Maybe udev got confused....

>=20
> Is there any other way to remove this detached drive from the array
> without having to stop/start the array or is this a (known) bug?

Try
   mdadm /dev/md5 --remove faulty

that will remove all devices marked as 'faulty'.
You could all use

   mdadm -If sde

NeilBrown


>=20
> # mdadm -V
> mdadm - v3.1.4 - 31st August 2010
>=20
> # uname -a
> Linux supernas01 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.39-2~bpo60+1
> x86_64 GNU/Linux
>=20
> Kind regards,
> Caspar Smit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/d0mM4sEzY/0J9eVFV_K6vqK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwu/iDnsnt1WYoG5AQLt7g//QFq6pGlF6/s7J6JquuXBMKO/7qL5s0D7
C1guq/drah4vpnXav4QVxWFndInNYpo5bC9sZq9ZOWNUb2dG0bzBAbr8wFdgsv+A
1lc5zzSCtA0aAyIAPOHigG+HYEGe1HotfXggYTTn2xfgoBhfC5FkrCGm7wqKDfD0
CTlvKk4kcNwMTKS20/w6dljoq8vH4Jwyd6oJ9Csbd6fV2fsfZHBtyZxuMVl7ynio
9eXG+2vpZFvwhrnmfRsXZ3PJNa2alVZVNqc1WOSggG8kiKueZUAn0Oft8tmh7c4F
qZJjVCY50sZWmYWxV4gQget3w8ro81u9gVeElZUOyYYERaj52LI9bivFcgo7hkln
EdI0JVUP6e1n+eO/ubbjeDF3Rwda3t4yc7X/gg+ijDTK4Fsqtjzj1sGplA31xZba
OSk9PDFIWVKVaL9SySL2DsVU3I3tmW7/JvrOYmmMwmqypLoZe7ieka8B02cJFRmJ
Oir4N+dgY7SkDnMXiBq/ZqMOlj0E8FR9MqEivGuHSZ5F2clnfcHclCX9xXV9Acmk
D0lnii91pEfdIsFnLksLyEXaog66DeOll8TmcoDzhqWD3L+8sNCd3DqjTeOTae6F
bJGxQUV24axMKXx9r2cZieffu+Bfh9ICnucy2oxOEtYGTTrJyAxMiFyB3aStJ1SQ
6gN4upI9yTI=
=CYPG
-----END PGP SIGNATURE-----

--Sig_/d0mM4sEzY/0J9eVFV_K6vqK--
