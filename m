From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 11:22:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030221102250.GP351@lug-owl.de>
References: <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gw540V35x8o0wdnq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fasttrack.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Gw540V35x8o0wdnq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-02-21 21:15:23 +1100, Lewis Shobbrook <lshobbrook@fasttrack.ne=
t.au>
wrote in message <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fastt=
rack.net.au>:

> /mnt/md0 device resulted in failure because nodes in the dev directory
> would never copy onto the mdX filesystem. Out of frustration I updated

Then you did the copy wrong. Use tar for it, one source partition at a
time. Like this:

(let /usr be on it's own partition)

	cd /usr
	tar cpf - --numeric-owner --one-file-system | \
		(cd /mnt/new/usr && tar xpf - --numeric-owner; )=20

> filesystem,  and all works like a charm.  The raidtools versions are
> both 0.90.200109 for woody and Testing, so the source of the woody woes
> must lay a little deeper, perhaps the raidtools dependencies weren't as
> compatible with woody or mke2fs is somehow different. Anyway hope this
> info helps someone.

With a bit of luck, newer fileutils managed to get the device nodes
right whilst you've not given appropriate parameters to 'cp'?!

> RE; Unable to mount -- Appologies ! I think the mounting trouble with
> ...
>=20
> EXT2-fs: md(9.0): couldn't mount because of unsupported optional
> features (fff80000).

Seems you try to mount an unclean ext3 filesystem with ext2 drivers...

> cramfs: wrong magic
> Md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use
> new ictls.=20
> Kernel Panic.=20
>=20
> ... was likely fstab pointing to /dev/hda1 with lilo.ocnf root=3D/dev/md0.

That seems to be an ext2 <-> ext3 problem...

MfG, JBG

--=20
   Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481
   "Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur
    fuer einen Freien Staat voll Freier B=FCrger" | im Internet!
   Shell Script APT-Proxy: http://lug-owl.de/~jbglaw/software/ap2/

--Gw540V35x8o0wdnq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+Vf36Hb1edYOZ4bsRAqOUAJ4gnn9XmuClJDoTHtGRMSQilPkDfQCgiY4B
KpOud9S0BkP7REgaaAzPki8=
=fKNw
-----END PGP SIGNATURE-----

--Gw540V35x8o0wdnq--
