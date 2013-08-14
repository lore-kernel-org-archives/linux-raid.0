From: NeilBrown <neilb@suse.de>
Subject: Re: RAID problem
Date: Thu, 15 Aug 2013 09:42:53 +1000
Message-ID: <20130815094253.25c57590@notabene.brown>
References: <1869496.205994.1376513377257.JavaMail.root@vznit170146>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R8Am6Dn1ihkA1uYpWav.kLF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1869496.205994.1376513377257.JavaMail.root@vznit170146>
Sender: linux-raid-owner@vger.kernel.org
To: fixitdad5@verizon.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R8Am6Dn1ihkA1uYpWav.kLF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Aug 2013 15:49:37 -0500 (CDT) fixitdad5@verizon.net wrote:

> If you are still offering help with raid corruption due to the bug in ker=
nels 3.2 and 3.3, I would like some help.
>=20
> I load Ubuntu 12.04 precise (with kernel 3.2 since it was in the package)=
 just 2 weeks ago. I had pre-existing raids and the raid's meta data was co=
rrupted on the first boot after the successful installation so I have lost =
my data. I tried most of the suggestions that I found on the web, employing=
 the intelligence in mdadm -assemble, etc. without success.
>=20
> I have now updated the kernel to 3.4.0 rc7 (3.4.0-030400-generic #2012052=
10521 SMP) and built an empty raid. However, I cannot boot without disconne=
cting the RAID drives. With the RAID drives hooked up and the updated kerne=
l with the additional parameters listed below, I I fall into busybox and ca=
nnot boot successfully. What do I do now?
> =20
> My configuration is=20
> Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz
> 7983 MiB
> running SELinux
> Raid is a simple stripping (level 0) for speed
> I have set the noautodetect and nodmraid parameters for the kernel

We would need lots more details to be able to help.
I assume you have given up on the old data - is that correct?  Sorry about
that.

Do you just have the one RAID (the RAID0)?  Is it for the root filesystem or
something else?

Maybe there is something in your initrd that is causing confusion.


 zcat /boot/initrd | cpio -idv
will explode it for you.  Is there an 'mdadm.conf' in there?  What does it
contain?

Maybe just run
   mkinitrd
(or whatever the Ubuntu command is - mkinitramfs maybe).
That might fix it.

Are there  any error messages during boot?

You might need to get Ubuntu specific help as different distros have quite
different boot sequences.

NeilBrown

--Sig_/R8Am6Dn1ihkA1uYpWav.kLF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgwV/Tnsnt1WYoG5AQIu0w//VBp+WY0YQwgxSCE1jYwq/q1H73VbJdUd
94Q8uRN0ZbawstBrOO6xqz5655PhdK5O+IdyKTXoMlFiTISzDQjoxV8tEPmqHAt3
izJaQ1uLkCqBjzetTBvBfmjiOC2vFRUavIIiXaDOtHcCwe4ZubZNYLyBLzqqOXi+
AiDiI6QC844+OJX3wW3PJTkwE/BhUmUnfUm9mzVnNd8w5QksqrAEJ3pAKZ1tGDwz
qV2NhejUV046CZmtbsznh7RUw2x4Z2B33S/Sm+Y997QZWW8aCHgIP5Bq8mEVhSCy
t/ZfWAhjkYnl9Z3CU41aRHWFBXCi8v+8mIYKLlWZAY8+nWQ57KwbQmwb9HB/NGAm
jrguaMOkHfCcGPKHpWGVVnwthuDTnQZpdVFbpW0Flp9geofzVjf7OGhnrqlIqzmg
/W2vckpwlG3jcOfn9qDfJ3R8loHeM8lU0naagl9VY05kqe+LsSbGGVtmrzCydENR
i1Cyg/qV18H/IMBRbyiot47dHxw5ty7B5suecD52dys553NRN0b1RlS544lRTPpX
e2ChTsTnfWiCBDUHZNhvGeOt9n0YliV+hrUeNHiBp12AqaIoWmmJwCvgLf3nzmKJ
qbgP1zSMEN4Lmu8MYcMIbQBrP/L9yD+wLPzx0Z4hYtHgFjIljhwVL4DsjPE48hls
mD0DlTw+p+o=
=xrBv
-----END PGP SIGNATURE-----

--Sig_/R8Am6Dn1ihkA1uYpWav.kLF--
