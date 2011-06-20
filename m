From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: flummoxed why I can't umount my md device.  fuser and lsof show
 no files locked
Date: Tue, 21 Jun 2011 00:03:17 +0600
Message-ID: <20110621000317.156d7d27@natsu>
References: <4DFF87F8.8050202@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7xoo/_r=Mj+3mT8hXfgvlW."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DFF87F8.8050202@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7xoo/_r=Mj+3mT8hXfgvlW.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jun 2011 18:48:40 +0100
Simon McNair <simonmcnair@gmail.com> wrote:

> I wanted to run 'mkfs.ext4 -n /dev/md0' to see what settings it would=20
> choose that were different to mine but it keeps saying:
> "/dev/md0 is apparently in use by the system; will not make a filesystem=
=20
> here!".
>=20
> I also can't stop the array using 'mdadm --stop /dev/md0' as it says=20
> mdadm: failed to stop array /dev/md0: Device or resource busy.  pretty=20
> much the same error occurs when trying lvchange -an /media/local/Raid
>=20
> I've no problem with any of this except I can't find out what process=20
> has a handle on the mount and/or why.  so I can't stop/kill it.
>=20
> I tried lsof | grep /media/local/Raid and fuser -m /media/local/Raid to=20
> no avail.  I also tried ps aux | grep Raid.  I've stopped pretty much=20
> everything in init.d including samba,nfs,mediatomb,squeezebox and=20
> anything I can think of that I've installed.
>=20
> Any advice/ideas please ?

I don't see you mention actually running "umount /media/local/Raid" (and
perhaps listing the error messages you get after that). Perhaps it goes
without saying and you did this, but in case not, remember that "mdadm --st=
op"
will not try to auto-unmount the filesystem for you first.

Other ideas, AFAIK lsof and fuser won't show you a process that holds the
filesystem mounted in case it doesn't have any files open there, but instead
just has its *current directory* on the FS. So if you launched something wh=
ile
cd'ed somewhere in /media/local/Raid, and it's still running (maybe the
superuser shell you currently work in?), that'd be your reason.

-=20
With respect,
Roman

--Sig_/7xoo/_r=Mj+3mT8hXfgvlW.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3/i2UACgkQTLKSvz+PZwjZ/QCffQK7HOKfnFWHqUqjaGd1hze0
PSgAni5WVrT9pYOsRkKU3cYsceYd9TaK
=/WSO
-----END PGP SIGNATURE-----

--Sig_/7xoo/_r=Mj+3mT8hXfgvlW.--
