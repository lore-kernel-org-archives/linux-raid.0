From: Tracy Reed <treed@ultraviolet.org>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 11:35:27 -0700
Message-ID: <20090730183526.GD19663@tracyreed.org>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2009 at 11:25:47PM -0700, Tirumala Reddy Marri spake thusly:
>   I have two 1 tera byte disks in RAID-1 configuration. When I started
> RAID-1 array initial speed was 100MBps by the time it finishes the speed
> was <50MBps. Is there is any reason for this behavior ? Isn't speed
> supposedly uniform.=20

I currently have a RAID-1 rebuild running and cat /proc/mdstat shows
speed=3D1481K/sec. This seems incredibly slow to me. That's just just
about one and a half megs per second. I'm wondering if this machine
has some more serious hardware problem. No errors showing up in dmesg
or /var/log/messages or anything though.

--=20
Tracy Reed
http://tracyreed.org

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQFKcefu9PIYKZYVAq0RAmZWAJdVcQBR21e0dYcSG/VUl//A79T3AJ9V4YBk
0W03/SAdgBWiY/67CBdNQQ==
=Ijts
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
