From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 - data intefrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Tue, 11 Mar 2014 14:04:18 +1100
Message-ID: <20140311140418.4eee07f8@notabene.brown>
References: <13688C12F44C7C428726663F950CA253094ADAC5@venus.in.megatrends.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J+VsASAvGF1aEFnJFMS5URn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13688C12F44C7C428726663F950CA253094ADAC5@venus.in.megatrends.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manibalan P <pmanibalan@amiindia.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J+VsASAvGF1aEFnJFMS5URn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Mar 2014 14:18:59 +0530 "Manibalan P" <pmanibalan@amiindia.co.in>
wrote:

> Hi,

Hi,
 when posting to vger.kernel.org lists, please don't send HTML mail, just
 plain text.
 Because you did the original email didn't get to the list.

>=20
> =20
>=20
> We are facing a data integrity issue on RAID 6. On CentOS 6.4 kernel.

I don't know what kernel "CentOS 6.4" runs.  Please report the actual kernel
version as well as distro details.

>=20
> =20
>=20
> Details of the setup:
>=20
> =20
>=20
> 1.       7 drives Raid6 md devices (md0) - Capacity 25 GB
>=20
> 2.       Resync speed max and min set to 100000 (100Mb)
>=20
> 3.       A script is running to simulate drive failure, this script will
> do the following
>=20
> a.       Mdadm set faulty for two random drives on the md, the mdadm
> remove those drives.
>=20
> b.      Mdadm add ond drive, and wait for rebuild to complete, then
> insert the next one.
>=20
> c.       Wait till the md become optimal, and continue the disk removal
> cycle again.
>=20
> 4.       iSCSI target is configured to "/dev/md0"
>=20
> 5.       From  Windows server, the md0 target is connected using
> MicroSoft iSCSI initiator, and formatted with NTFS.
>=20
> 6.       Dit32 IO tool is running on the formatted volume.
>=20
> =20
>=20
> Issue#:
>=20
>                 The Dit32 tool will running IO in multiple threads, in
> each thread, IO will be written and verified.
>=20
>                 And on the verification Cycle, we are getting
> mis-compare. Below is the log from the dit32 tool.
>=20
>                =20
>=20
> Thu Mar 06 23:19:31 2014 INFO:  DITNT application started
>=20
> Thu Mar 06 23:20:19 2014 INFO:  Test started on Drive D:
>=20
>      Dir Sets=3D8, Dirs per Set=3D70, Files per Dir=3D75
>=20
>      File Size=3D512KB
>=20
>      Read Only=3DN, Debug Stamp=3DY, Verify During Copy=3DY
>=20
>      Build I/O Size range=3D1 to 128 sectors
>=20
>      Copy Read I/O Size range=3D1 to 128 sectors
>=20
>      Copy Write I/O Size range=3D1 to 128 sectors
>=20
>      Verify I/O Size range=3D1 to 128 sectors
>=20
> Fri Mar 07 01:28:09 2014 ERROR: Miscompare Found: File
> "D:\dit\s6\d51\s6d51f37", offset=3D00048008
>=20
>      Expected Data: 06 33 25 01 0240 (dirSet, dirNo, fileNo, elementNo,
> sectorOffset)
>=20
>          Read Data: 05 08 2d 01 0240 (dirSet, dirNo, fileNo, elementNo,
> sectorOffset)
>=20
>      Read Request: offset=3D00043000, size=3D00008600
>=20
> =20
>=20
> This mail has been attached with the following files for your reference
>=20
> 1.       Raid5.c and .h files, the Code what we are using.
>=20
> 2.       RollingHotSpareTwoDriveFailure.sh - the script which simulates
> the two disk failure.
>=20
> 3.       dit32log.sav - Log file from the dit32 tool
>=20
> 4.       s6d31f37 - the file where the corruption happened(hex format)
>=20
> 5.       CentOS-system-info - md and system info
>=20
> =20

I didn't find any "CentOS-system-info" attached.

I know nothing about "dit32" and so can not easily interpret the output.  Is
it saying that just a few bytes were wrong?

Was the array fully synced before you started the test?

I can't think of anything else that might cause an inconsistency.  I test t=
he
RAID6 recovery code from time to time and it always works flawlessly for me.

NeilBrown



>=20
>                =20
>=20
> Thanks,
>=20
> Manibalan.
>=20
> =20
>=20


--Sig_/J+VsASAvGF1aEFnJFMS5URn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx59Mjnsnt1WYoG5AQK55xAAlVG4hlzGLwUULZLOJ2DnA81ZAqhSdP7h
XZlXpMq6S8WVyU5NhVvPtMDHb9SgyGd4ojFICM8+lydvvrZPYnQ8jGc6jIQKBSs1
7YCYvte0YgsSouk6vAKmbJJtkNJNdkMao04eXnlXw8YgLd3fq8KbrZMVQBKo2OVF
FjkyVTAHXzVY/H6FJ2LFy9QmTxaIYSJWVzBUK6xAF031yhUfFTuktKWFwOCZPI+7
U1wHJxGRwcM5fs+kYa1Uzt65ChefwAjljALpY/tqAEnPJ32WVZRyuVBbF6cQOkry
0QltgVPszLYlfA1uz1l5MnDHrR+pa/zT74JPImcKG4a79wzlF14xMWjQyBS/pEXm
Ki9b/fxWgxr9dalkD7kTv2ojPxAFUCTxTUp9aB1CCg3WuhSLIpg/yax7FAbnZEj0
vTIIiwxtT1tiC4xgKpO8kcrBzgXTt0pxiZ5ocWcrBWkS27CM1p+DfUIo0rIHsdTk
uflnFBkpw5UYH0mdodjcsxTBliCr/bsGsC5RJiRpMcXad2M/aIS+axY8crPoTdms
a8yTiE64Pak2n+giMVF+U2rntjp+zKaODcluPQD1RIHEEkgVjLH5972WmiC7BqhO
LHOtmckFuZxXcj3WLa24tIi08lzfWHCl7uBlrlO3WilzDt5xVXqFnYc4d2OyKF2m
jyKJLFSaDXU=
=liq0
-----END PGP SIGNATURE-----

--Sig_/J+VsASAvGF1aEFnJFMS5URn--
