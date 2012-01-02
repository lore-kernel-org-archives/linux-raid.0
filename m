From: NeilBrown <neilb@suse.de>
Subject: Re: Install grub2 to /dev/md126 fails
Date: Tue, 3 Jan 2012 10:34:01 +1100
Message-ID: <20120103103401.2d90498e@notabene.brown>
References: <760811954.244872.1325303953552.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JatZzoxsK21cr6X0TRUfVjm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <760811954.244872.1325303953552.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: jlcenter@comcast.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JatZzoxsK21cr6X0TRUfVjm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Dec 2011 03:59:13 +0000 (UTC) jlcenter@comcast.net wrote:

> Hi,
>=20
> I've been trying to install Ubuntu 11.10 on a mdadm imsm raid1 array, but=
 it fails installing grub.  I had to chroot /target to install mdadm from t=
he distribution.  I've also upgraded to the latest version of mdadm, hoping=
 this would fix the problem.  This is the error I'm getting:
>=20
> root@ubuntu:/# grub-install --recheck /dev/md/V1
> /usr/sbin/grub-probe: error: no such disk.
> Auto-detection of a filesystem of /dev/md126p3 failed.
> Try with --recheck.
> If the problem persists please report this together with the output of "/=
usr/sbin/grub-probe --device-map=3D"/boot/grub/device.map" --target=3Dfs -v=
 /boot/grub" to <bug-grub@gnu.org>
>=20
> Here's how mdadm sees my config:
>=20
> root@ubuntu:/dev# mdadm --examine --scan
> ARRAY metadata=3Dimsm UUID=3D92ae2913:95d651ca:62154f33:7069b04c
> ARRAY /dev/md/V1 container=3D92ae2913:95d651ca:62154f33:7069b04c member=
=3D0 UUID=3D71b12777:c6a51a84:5b0f1d11:0bd6e497
>=20
> I also tried with several variations of /dev/md126, etc., but always with=
 the same result.  I also tried to install directly to one of the disks in =
the array, but this didn't work, either.  When I ran grub-probe, I got the =
following error:
>=20
> /usr/sbin/grub-probe: info: opening mduuid/71b12777c6a51a845b0f1d110bd6e4=
97,3.
> /usr/sbin/grub-probe: error: no such disk.
>=20
> What could be causing this problem?  How do I fix it?  Please let me know=
 if I need to supply more information to troubleshoot this problem.
>=20

Sounds like a problem with 'grub'.  I suggest you find a list for discussing
that tool.

Feel free to keep linux-raid on 'cc' as the outcome may be interesting for =
us
too.

Thanks,
NeilBrown

--Sig_/JatZzoxsK21cr6X0TRUfVjm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwI+6Tnsnt1WYoG5AQJ9kw//ZkmRiMpZvQv+eOmBI+kr41LZyJcZyo0s
Y/7/luJL58gL4geEjVRbngRH0LqGZ+K7/YqMuBuXBT8WtJeZdoRFtSyebU2O6N5A
WtcFpb81z0X8Q8L7InFlFsbX5kO64fSKXc8vgrf30hv3uyFyN6ZbwgNdZMUfK3qw
shUNsKRWu1ThnkqEmAA9F2lNuV5c2OZsV5GjmaokLECAaMFRZA546IMzC4R+NY6k
AtMiWgPBT1SD45bOupa3ddu01z1XGGHKPOftysvGHDIDsQbKeAiwffBbl/zYx5TF
YrGy/XHrP6NHfe0qCsMjQGwMY4KjMlDKio939YrFbvFXRrhUnw7KEGsd07Mky4pm
HmuqzDXosM1icnfKScUQnz99aAc89nl7eR0SjQ2wFZjue2hVv8maob/V6J9uCJ/X
BBIEEMIqErXJeux3tnwsNANuygrsYN+PtY54Q64vr+yrqFoYoGTuBQyrTuZfB45j
Lz+S4qiRbBVYsV+SVjAiFnIEEh+8gYz70gYm+FCFOVJ0WDDrYJw3s+gHrOZ2tJWL
ed5Xm/Hrave0t322RglVuj75mVwZqQq3FKFoJtt/b0UgfHpfuS3KhaCXVVC6lYTr
LUs780FAy9uiCTdmuIsGsfHBA+f13pX9mJ/SUMVUIqawJznta+io3ysqOCJjgnEL
G1Xr7ICcc1s=
=UTWY
-----END PGP SIGNATURE-----

--Sig_/JatZzoxsK21cr6X0TRUfVjm--
