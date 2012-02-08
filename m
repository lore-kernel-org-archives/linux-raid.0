From: NeilBrown <neilb@suse.de>
Subject: Re: imsm raid is always readonly on boot
Date: Wed, 8 Feb 2012 12:57:29 +1100
Message-ID: <20120208125729.5674f35d@notabene.brown>
References: <4F3111D9.2060303@profihost.ag>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DAz_niNd=9D6MQGB=nge+LX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3111D9.2060303@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DAz_niNd=9D6MQGB=nge+LX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Feb 2012 12:58:17 +0100 Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:

> Hi,
>=20
> i'm running 3.0.18 as kernel (renamed to 2.6.40) and mdadm 3.2.2.
>=20
> I'm trying to get an intel fake raid running but it is always set to
> readonly on boot after running
> mdadm --assemble --scan --run --force --auto=3Dyes
>=20
> But i've absolutely no idea why.

Probably mdmon isn't running for some reason.

For these arrays the metadata is managed in user-space by mdmon.
Until it is ready to record failures the array must remain readonly.
On of the first things it does is switch the array to read-write, having
arranged to catch any failure notifications.

If you=20

 mdmon --all --takeover

it might just start working.  However that doesn't explain why mdmon wasn't
started at boot.  mdadm is meant to start it.
There are some concerns about mdmon starting this way being not "the right
thing" from a systemd perspective and there might be some issues there that
are causing problems.

NeilBrown



>=20
> My mdadm.conf:
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan,
> using
> # wildcards if desired.
> #DEVICE partitions containers
>=20
> # auto-create devices with Debian standard permissions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>=20
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <ignore>
>=20
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
>=20
> # definitions of existing MD arrays
> ARRAY metadata=3Dimsm UUID=3D24cdb70d:101f4c4b:23dfa5cb:3f176b6a
> ARRAY /dev/md126 container=3D24cdb70d:101f4c4b:23dfa5cb:3f176b6a member=
=3D0
> UUID=3D84aa9982:ed593d80:ee7c7f53:e2944038
>=20
>=20
> ~# cat /sys/block/md126/md/array_state
> readonly
>=20
> What's wrong? Thanks!
>=20
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/DAz_niNd=9D6MQGB=nge+LX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzHWiTnsnt1WYoG5AQLrQRAApgynF242eGO6OOjk2KOLRi9ADuZfm8ei
w4lT5lW28Pb10Knx+LM6POogjqqK7q1nsEKK5ebdawV/w0JzLVy3+YIVOOoUauQ0
F/0SOZ++bYAxR7OsXqayQ537KriLR1DzDZxrZwqzvYn7BYVNZlmTHot0+poE5Mlo
1xFd7vRZm8Y4mppUH4KBIeQkGLVA27KFMgwhhancnwsh3ab0YGThYzVmSbb8ZEUS
+LuCyCsP0CgeEmclYxjlVzT4APjy/Fx/xu9p1DWd8YFLsMDtxhYsd12s/m+V86J0
mIbWagp6I1WIDXD33b4Rc/fdY6IMTpsD1ru1j4Qvo0wCl5WV5ifNVcoJ0Y/q4INb
30k/yrCdF5VNFcoQ2hfbGi0LHHJlOA355ckvUoHDYAlJki/512ajNYaoJm7QornJ
9YQ2Yur7v/cmJjyVLMAUGoOdPjgYo3xA4OKl32Zxt84sAB3GHDEVF1Z20zQ727yV
xRRX3kNDmU8FV9zZDnRMbatigdb1N1y3XiQDcMS4KwilNoTVoqZvfnt9ILNdiCcB
MpmJbY/i6BEx4Hbos7QcHsHvHWuNgBmt2thsMrTd4234FtKO32lTHQyD/1jJEpr5
DBEdY2pSSoN0v+dDC7Ph08535pRnfSR0RBsUc2C+v7MLu9eQo+pREmc1OZqLOds2
GBfXZtgXSWM=
=QlXy
-----END PGP SIGNATURE-----

--Sig_/DAz_niNd=9D6MQGB=nge+LX--
