From: NeilBrown <neilb@suse.de>
Subject: Re: cannot re-assmble mdadm array
Date: Sat, 12 Apr 2014 19:54:02 +1000
Message-ID: <20140412195402.3f2a720e@notabene.brown>
References: <1250925833.23839319.1397286490552.JavaMail.root@cds036>
	<400635298.23842674.1397287112819.JavaMail.root@cds036>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s0q1rJ8Lylib=UXEWMvBVIy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400635298.23842674.1397287112819.JavaMail.root@cds036>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Ryder <tireman@shaw.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s0q1rJ8Lylib=UXEWMvBVIy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Apr 2014 01:18:32 -0600 (MDT) Andrew Ryder <tireman@shaw.ca> wro=
te:

>=20
> # mdadm --assemble --run --force -vvv /dev/md2=20
>=20
> mdadm: looking for devices for /dev/md2
> mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4PLD3-part1 is not one of
> /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/=
ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9V=
T156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
> mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4PSMK-part1 is not one of
> /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/=
ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9V=
T156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
> mdadm: /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD4QHNL-part1 is not one of
> /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1,/dev/disk/by-id/=
ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1,/dev/disk/by-id/ata-ST2000DL001-9V=
T156_5YD1516L-part1,/dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1
> mdadm: Not a listed device for /dev/md1.
> mdadm: Not a listed device for /dev/md3.
> mdadm: Not a listed device for /dev/md1.
> mdadm: Not a listed device for /dev/md3.
> mdadm: Not a listed device for /dev/md1.
> mdadm: Not a listed device for /dev/md3.
> mdadm: Not a listed device for /dev/md1.
> mdadm: Not a listed device for /dev/md3.
> mdadm: /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1 is identi=
fied as a member of /dev/md2, slot 0.
> mdadm: /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1 is identi=
fied as a member of /dev/md2, slot 1.
> mdadm: /dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1 is identifie=
d as a member of /dev/md2, slot 2.
> mdadm: /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1 is identifie=
d as a member of /dev/md2, slot 3.
> mdadm: added /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9BZB13889-part1 to =
/dev/md2 as 1
> mdadm: added /dev/disk/by-id/ata-ST2000DL001-9VT156_5YD1516L-part1 to /de=
v/md2 as 2 (possibly out of date)
> mdadm: added /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F31KGY-part1 to /de=
v/md2 as 3 (possibly out of date)
> mdadm: added /dev/disk/by-id/ata-SAMSUNG_HD204UI_S2HGJ9CZB04511-part1 to =
/dev/md2 as 0
> mdadm: failed to RUN_ARRAY /dev/md2: Input/output error

I haven't looked closely, but what version of mdadm is this?
And what happens if you try the latest=20
  git clone git://neil.brown.name/mdadm;cd mdadm;make;./mdadm....

NeilBrown

> mdadm: Not enough devices to start the array.
>=20

--Sig_/s0q1rJ8Lylib=UXEWMvBVIy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0kNOjnsnt1WYoG5AQLMjRAAtryZ677Wz3nXhV1x1XeVN01W4EEsVpO1
bGfo3J4ATcJVGUKEhTHMvXfu89bh5Nbgy47wJbUOT3qWO6YmFbfrta3DEPVPazVj
3G4Pue50cMSJrDxhkMlkgnUy/2HrXDhyfdPxUZssZnb1970ETmdbenTENL+iS9cx
ys+RKq0W30r7OnHASqV+E3OmCsNTJ3CKgEpv6yVvmAjhr3mJIZ50ySJuKBtqWGlN
Rq236RbgR5tpC26OsWgPznnwSuTY25YcrAAr5l1vKAPerSpAFbOzckr325HvPs9y
KAnOsZ5h3UoOHsu717S6xx02KK1BykQ9Dz93MDjFiGCWIviTyN97Ud2leaeecLIE
qjSsxnsPgCslsT2I91N8bN7Qr3zfM3jev0UgRACfidJDRmoyYVXx2Vei6xkQYgau
zTdCCqLMMfdG0qXDwqTtqlPlQPRR0K/0BgL+O1AUV6/9Aw9LjrOrdjXq76Xhnx7S
USZ4w240GZBZ2E2zYuXhjiGH2tV88MIOeK1cCtOwScCUb8K1ig3Ur8RfBEBwdl6R
OBK6auCFOpNtJSDIjW8VfVrZMS4hsibb5buuiCW3HM4M4EY3IrVHiIaJWV+KJHXT
bd8PuuE4fvMyA8B6my8anFOBsCu6f7Mw0hxXF2qpbgmwPoctX93kCqmu84Ibh82A
EmXu+o0izy4=
=/qvB
-----END PGP SIGNATURE-----

--Sig_/s0q1rJ8Lylib=UXEWMvBVIy--
