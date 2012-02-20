From: NeilBrown <neilb@suse.de>
Subject: Re: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 16:29:15 +1100
Message-ID: <20120220162915.43b4f451@notabene.brown>
References: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/upJh6sfudbvcCWW+j8i=CnN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
Sender: linux-raid-owner@vger.kernel.org
To: "RANSOM, Tony" <tony.ransom@baesystems.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/upJh6sfudbvcCWW+j8i=CnN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 14:41:04 +1030 "RANSOM, Tony"
<tony.ransom@baesystems.com> wrote:

> Hi,
>=20
> I'm having problems getting a replacement drive to rebuild after a disk f=
ailure.=20
>=20
> I'm running a 10.04 server using two 2TB WD caviar drives in a linux s/w =
raid 1 configuration.
>=20
> The two drives were set up during Ubuntu install.
>=20
> They contain three partitions, as follows:

.....


> The array goes into degraded mode. It starts to incorrectly rebuild the a=
rray as shown below. It ignores md0, and tries to rebuild the md1 array to =
sdb, not sdb3.

What is the output of each of
  mdadm -E /dev/sdb
  mdadm -E /dev/sdb3

??

What version of mdadm do you have?

What is the starting sector of /dev/sdb3?  In particular, is it a multiple =
of
64K?

NeilBrown


>=20
> ----------------------------------
>=20
> Quote:
> root@server2:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]
> md1 : active raid1 sdb[2] sda3[1]
> 1953027008 blocks [2/1] [_U]
> [=3D>...................] recovery =3D 9.0% (177317632/1953027008) finish=
=3D453.9min speed=3D65198K/sec
>=20
> md0 : active raid1 sda2[1]
> 292800 blocks [2/1] [_U]
>=20
> -------------------------------
>=20
> When I check the sdb disk partition table, it is corrupted ....
>=20
> Quote:
> root@server2:~# gdisk /dev/sdb
> GPT fdisk (gdisk) version 0.8.2
>=20
> Caution: invalid main GPT header, but valid backup; regenerating main hea=
der
> from backup!
>=20
> Caution! After loading partitions, the CRC doesn't check out!
> Warning! Main partition table CRC mismatch! Loaded backup partition table
> instead of main partition table!
>=20
> Warning! One or more CRCs don't match. You should repair the disk!
>=20
> Partition table scan:
> MBR: not present
> BSD: not present
> APM: not present
> GPT: damaged
>=20
> Found invalid MBR and corrupt GPT. What do you want to do? (Using the
> GPT MAY permit recovery of GPT data.)
> 1 - Use current GPT
> 2 - Create blank GPT
>=20
> --------------------------------
>=20
> I've checked the new disk with WD's diagnostic software. It passes the ex=
tended test.
>=20
> I'm presently trying for the third time to get this to work. I'm not conf=
ident as I'm not really doing anything differently from the first two effor=
ts.
>=20
> Note: I've also posted this on the Ubuntu server forum, to date without s=
uccess. http://ubuntuforums.org/showthread.php?t=3D1927909=20
>=20
> Hopefully, the people who are familiar with the workings of the software =
will know what the problem might be.
>=20
> Any assistance is greatly appreciated.
>=20
> Thanks,
> Tony
> "Warning:
> The information contained in this email and any attached files is
> confidential to BAE Systems Australia. If you are not the intended
> recipient, any use, disclosure or copying of this email or any
> attachments is expressly prohibited.  If you have received this email
> in error, please notify us immediately. VIRUS: Every care has been
> taken to ensure this email and its attachments are virus free,
> however, any loss or damage incurred in using this email is not the
> sender's responsibility.  It is your responsibility to ensure virus
> checks are completed before installing any data sent in this email to
> your computer."
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/upJh6sfudbvcCWW+j8i=CnN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0HaKznsnt1WYoG5AQJ+yg//byMpsgzwRWZXhXhD3p/SyzVmweGdRfSE
uxwlViRLpH6xaMFHzgStlPOz9ske1tUFKjyu+TO67kAl8Y/Uw+Mzn3y38EgK1GzK
bVixg229xUX3386s0MGKzh+eXSYRrC1yMEVrQoiN/TIe4jqzIze/5TSFg+S/swKV
DcGqz/BqbGJUiWGfJ3zETgAA2Is8Mrka71oNwiIbZcKV/4a9DpeaDw4t30O79wJR
YwcaRHC3RJBaGWdHHeUGz2Iq0Amc/8B0wBt5cDdbeL1VTds5lwzxU97A6zIxURcx
eCQY9XdZVOqQwzJDq7aNThPgINTmwOXbxDJcRn/I1hwCODMHkKMOpdGpxYCVUlF+
DTmJzXYqU+dsuCvGVnbOxmm8A4L9fPWthqCh86YdhPuoI1+ErDIeuTAzHDgD/SE7
qgec9RAzP2V60WpQFGnGItf3W40SjMFYWzQpdhM4rjFbV3yU3qaQ8yV24tnJClMI
IE/ZYIxf0a9F9c4SCiBVisIhSN0bufQan7N7p0johaF2xE17lcCP0f2Oa95EIkYZ
jhgt2MldQ7z4szd/w0EStuGmSyPoQgnQ1FA7rTzZbtff+Iv4rIWsbr+RC/tU5KUg
wEYfEZs5FvU4Xgn1RNQ/zdN1FRhoTKMTBNVx/Zo2GhoYGfuK7Tn48p5dTXWg1Hcj
6/6o9TXbxZc=
=uHD/
-----END PGP SIGNATURE-----

--Sig_/upJh6sfudbvcCWW+j8i=CnN--
