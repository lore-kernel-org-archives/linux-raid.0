From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: mismatch_count != 0 on multiple hosts
Date: Wed, 16 Sep 2009 12:17:14 -0500
Message-ID: <20090916171714.GA24629@atlantis.cc.ndsu.nodak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,

My organization recently upgraded to RHEL 5.4, which included an=20
updated mdadm RPM (mdadm-2.6.9-2.el5).  Included in the new RPM was a
cron job that does a weekly consistency check on the available RAID arrays.
After the checks completed, I found that most of our systems had a
mismatch_cnt that was !=3D 0.

I've seen mention of this problem on the mailing list before when swap
is being used on the problem array, which is not the case for us.  Out
of about 50 systems I checked, I found roughly 30 arrays that had a=20
mismatch_cnt !=3D 0.
=20
The systems I found with problems vary in kernel versions (2.6.18 - 2.6.29)
and have different types of media attached (SATA, SCSI, SAS, SAN).  In
the case of SAN volumes, we have a RAID 1 mirror across 2 SAN=20
volumes.  The SAN volumes sit on-top of a linux RAID 5 array on the=20
targets.  I did a consistency check on the RAID 5 arrays and did not
find any problems (mismatch_cnt =3D 0).

The most popular mismatch_cnt values are 128 and 256.  The worst I=20
found was 21504 and 7168.  I find it interesting that all are=20
divisible by 128.

So, is there anyway to get an output on which blocks do not match?  I'd
like to see how they are different, if at all.

Regards,

Bryan


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqxHZoACgkQlSl3SAlkhEcExQCfV2I/l0jCA7XRQ0FFPPK0lRpa
pxAAnAotb4wX8vQZUe30hKAcM+al99mH
=Fft1
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
