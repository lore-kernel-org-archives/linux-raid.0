From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-6 disk superblock issue
Date: Thu, 15 Dec 2011 09:07:51 +1100
Message-ID: <20111215090751.3801a75a@notabene.brown>
References: <jc8kca$mf$1@dough.gmane.org>
	<4EE8F26D.7010608@turmel.org>
	<jcb570$1do$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qGPBvTYWt3ri1qvIDzydXTc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jcb570$1do$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Telford <ttelford.groups@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qGPBvTYWt3ri1qvIDzydXTc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 14:41:52 -0700 Troy Telford <ttelford.groups@gmail.com>
wrote:

> On 2011-12-14 19:01:01 +0000, Phil Turmel said:
>=20
> > Hi Troy,
> >=20
> > On 12/13/2011 05:42 PM, Troy Telford wrote:
> >=20
> > Let me guess:  You have version 0.90 superblock, and sdl1 covers the=20
> > whole device?
>=20
> sdl1 does cover the entire device, but I'm fairly certain I do not have=20
> a 0.90 superblock (Unless 0.90 was the standard version for Linux 2.6=20
> about two years ago.)

It is mdadm that determines the superblock rather than the kernel, but you
definitely have 0.90 superblocks - I can tell from the /proc/mdstat output
(it doesn't list a version, so it must be 0.90).

>=20
> Unfortunately, I'm not sure how to get my current superblock version:
> $ sudo mdadm --examine /dev/md2
> mdadm: No md superblock detected on /dev/md2.
>=20
> I find it curious that I can't detect the superblock for the MD device,=20
> even though the device is up, active, and working.

The array doesn't have a superblock.  Each member device does.
  mdadm --examine /dev/sdl1

>=20
> > Short term, change your mdadm.conf to only accept device names that end=
=20
> > with a digit.  Like so:
> >=20
> > DEVICE /dev/sd[a-z][1-9]
>=20
> OK, I'll give that a whirl.  For the record, it was DEVICE partitions=20
> previously.
>=20
> > Then rebuild your initramfs to include the new mdadm.conf.
> >=20
> > Long term, rebuild your array with v1.x metadata.
>=20
> You know, I was hoping to be able to wait until btrfs handles RAID-6=20
> (or "raid-z") arrays by the time I had to rebuild the array.  I guess=20
> I'm not that lucky.

You don't really need to rebuild the array.  Just change the DEVICE line and
all will be happy.

(but I advise you never to plan on using software that hasn't be released y=
et
- that way lies madness).

NeilBrown


--Sig_/qGPBvTYWt3ri1qvIDzydXTc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTukeNznsnt1WYoG5AQKVLw/6A+ONDXLhA30LJFsj+og5vQe/UwMjPLgg
HPKaMv418n2Mof5ePZh48/gJGqTU2q1zUrI5P3sKrjtqaD4QGPSnIZ7qc13CWyeN
4O78tp50W0wyapRvhw6tc/IFxL74xM/zJMHXgl85z7zUsH6zvzr+IkW58Z4rKjiD
+zrQncH6WqvJVYaiDQkCvHsIWYtbAhMAPllq3EUJJHa5r05z/3LJXB9R8tyKh+gb
iVfd01GLPYrUar9ij8QVkCkLDc2tjGMgTS+z7LerI1VOFW6ni1V5Yk8FZ//UtIWK
257AQ/p7ceXx1b7+jnCGaZFcCtEelMjCB+u44SKZzH2cTtABhcIq0XYp5tRrbNgO
JpYTJrSha1ZdpMZGP6Lzk695Ov+l85fmfWxEjmU6bTG6uTVxhwEQLaPgjLAi1L6Z
Kpi7FKpJXd8dPaZBSwaT1bKENp4fjSsYrgtvzj3rqlRuSEDBb2OzoeVzklsJaNsF
Mse6jLQF/3E6nMlimcjLVMN4yWyEgQZrwOOa13VkaVZo18660clBbVuYlMjwsqUN
ezYUIk4K/P/l/ML0rk9lGKTt8kP0tGbxQMe8kpCfwrsCrB1qK9Xdevbfdk2YwEe7
KphUW9MaubYPDCocbiZn6F1xESRTYySDMExKgvLqXIS0WHrmfx0SJTUybysFqY20
69WmaI59Rck=
=k1os
-----END PGP SIGNATURE-----

--Sig_/qGPBvTYWt3ri1qvIDzydXTc--
