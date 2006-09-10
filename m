From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Re: Care and feeding of RAID?
Date: Sun, 10 Sep 2006 09:36:25 +0200
Message-ID: <20060910073625.GB29449@scavenger.homeip.net>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net> <44FDC21C.7050203@maine.edu> <20060905205727.GD17634@percy.comedia.it> <20060906071224.GA20933@scavenger.homeip.net> <20060906184945.GD991@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060906184945.GD991@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.09.2006 20:49:45, Luca Berra wrote:
> On Wed, Sep 06, 2006 at 09:12:24AM +0200, Benjamin Schieder wrote:
> >>>>Personally, I use this script from cron:
> >>>>http://shellscripts.org/project/hdtest
> >>
> >>nice race :)
> >
> >As in race condition? Where?
>=20
> mktemp
> rm
> touch
> why do you do that?

Probably because of a wrong understanding of mktemp. I fixed this now.

> i retested now with 5.36 and it seems the output did _not_ change, i
> don't know what i saw this morning.
>=20
> but then it errors on the line
> IFS=3D"   " read type status online < <( smartctl -d ata -a ${disk} | grep
> \#\ 1 | sed 's,  \+,   ,g' | cut -f 2,3,5 )

I think I know what you mean. I've seen these errors sometimes, too. But I
was too lazy to investigate yet since they only pop up once a month or so.


Greetings,
	Benjamin

--=20
 _  _     _   _            _  =20
| \| |___| |_| |_  __ _ __| |__
| .` / -_)  _| ' \/ _` / _| / /
|_|\_\___|\__|_||_\__,_\__|_\_\
| |  (_)_ _ _  ___ __
| |__| | ' \ || \ \ /
|____|_|_||_\_,_/_\_\
Play Nethack anywhere with an x86 computer:
	http://www.crash-override.net/nethacklinux.html

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFA8B5r0OTeImXvg8RAv1/AJ0cDG0UUpP59gWhhVNrlodpPhBfKwCdHcNC
v9VYFTChwLK0mIA/SRh2V9s=
=4tUh
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
