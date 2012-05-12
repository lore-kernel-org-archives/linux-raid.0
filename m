From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Sun, 13 May 2012 09:19:01 +1000
Message-ID: <20120513091901.5265507f@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//6.rCD+phnxGF5BE8zIOzpQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//6.rCD+phnxGF5BE8zIOzpQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 12 May 2012 17:56:04 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> Neil,

Hi Patrik,
 sorry about the "--layout=3Dpreserve" confusion.  I was a bit hasty.
 -layout=3Dleft-symmetric-6" would probably have done what was wanted, but =
it
 is a bit later for that :-(

>=20
> so I further analyzed the behaviour and I found following:
>=20
> - The bottleneck cca 1.7 MB/s is probably caused by backup file on one
> of the drives, that drive is utilized almost 80% according to iostat
> -x and its avg queue length is almost 4 while having await under 50
> ms.
>=20
> - The variable speed and low speeds down to 100 KB are caused by
> problems on drive I suspected as problematic. Its service time is
> sometimes going above 1 sec.. Total avg speed is about 0.8 MB/s. (I
> tested the read speed on it by running check of array and it worked
> with 30 MB/s. And because preserve should only read from it I did not
> specifically test its write speed )
>=20
> So my questions are:
>=20
> - Is there a way I can move backup_file to other drive 100% safely? To
> add another non-network drive I need to restart the server. I can boot
> it then to some live distribution for example to 100% prevent
> automatic assembly. I think speed should be couple of times higher.

Yes.
If you stop the array, then copy the backup file, then re-assemble the
array giving it the backup file in the new location, all should be well.
A reboot while the array is stopped is not a problem.

>=20
> - Is it safe to fail and remove problematic drive? The array will be
> down to 6 from 8 drives in part where it is not reshaped. It should
> double the speed.

As safe as it ever is to fail a device in a non-degraded array.
i.e. it would not cause a problem directly but of course if you get an error
on another device, that would be awkward.

>=20
> - Why mdadm did ignore layout=3Dpreserve? I have other arrays in that
> server in which I need replace the drive.

I'm not 100% sure - what version of mdadm are you using?
If it is 3.2.4, then maybe commit 0073a6e189c41c broke something.
I'll add test for this to the test suit to make sure it doesn't break again.
But you are using 3.2.2 .... Not sure. I'd have to look more closely.

Using --layout=3Dleft-symmetric-6 should work, though testing on some
/dev/loop devices first is always a good idea.

NeilBrown



--Sig_//6.rCD+phnxGF5BE8zIOzpQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT67v5Tnsnt1WYoG5AQKKeQ/9GsA6eRLSWvGlyvlSXLZNwmgcyQ5RWRVB
jOUPaPQkipyyL9bLXEcpfBrRMyn8hjaFsTlr2QKCLINiiAk6OIpjz1hN0BTqYrHf
+pzYhqWEawN3ysrTtGkNeGe+g++zNL5GLGytl2Rv37oKwaaCQHZu/mAiiNgvsJ4N
Gc2JcDJE04C1Tc5hYus0xDX1iIuHAF+IXzj5K7tuyEi2owviZk7fQasIyCfymcNY
vO80Rj/m4q99kK+QaDNN8Rq3ptXgUyOkHWdB4FlNTewOZFaKl64m5x4vgQJbdJdR
anq7S1DqAdSshw0jyEyjCOVumyM8BAkQiFaGG3ZDbFG+eJSSJGrtGQB6ArPkvAMS
EmtWhf1rwjGbxvD2SvH53uZ0iMnWsjPd0AW2yRiBUQBRbPrVUgyGALF0mt1LQ+SF
6k+lhkIjCI87HsBb8243eJ0Hk0rRHR6aDoLeE8YHaS2ZmBHTa9VumLiTWTp9o1iq
CobUKyBOyqCV9Xz4UBTf4V/dxMO4ZpUM0442WQrllDTZKDBlqz7whrxBP3v+YVd0
yFh6Pn4yDXslUTyiDgfzaUmDAAMk51zINMGyDSaFS58ozU8BadgIa1AyEPvISYK+
qX73Wo5/jgfYEK38LkYEDVQr13NrEwz6kpH0P10/pO923t330Ba4uozQfMaXDmDy
umHYzIauzn0=
=3SYo
-----END PGP SIGNATURE-----

--Sig_//6.rCD+phnxGF5BE8zIOzpQ--
