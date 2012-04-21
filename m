From: NeilBrown <neilb@suse.de>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Sun, 22 Apr 2012 07:00:41 +1000
Message-ID: <20120422070041.7e4b95e7@notabene.brown>
References: <4F92BC43.3010603@computer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oa7_6CbuyblBs3=CWu=x767"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F92BC43.3010603@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/oa7_6CbuyblBs3=CWu=x767
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Apr 2012 15:55:15 +0200 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> Hi
>=20
> Ever since I installed a 3.2 kernel on my Ubuntu  11.04 system, dmesg=20
> began being flooed with messages such as the following:
>=20
> [15746.465106]  disk 1, wo:0, o:1, dev:sdb2
> [15748.100302] RAID1 conf printout:
> [15748.100306]  --- wd:2 rd:2
> [15748.100310]  disk 0, wo:0, o:1, dev:sdd2
> [15748.100313]  disk 1, wo:0, o:1, dev:sdb2
> [15748.438638] RAID1 conf printout:
> [15748.438642]  --- wd:2 rd:2
> [15748.438646]  disk 0, wo:0, o:1, dev:sdd2
> [15748.438649]  disk 1, wo:0, o:1, dev:sdb2
> [15751.181020] RAID1 conf printout:
> [15751.181026]  --- wd:2 rd:2
> [15751.181030]  disk 0, wo:0, o:1, dev:sdd2
> [15751.181034]  disk 1, wo:0, o:1, dev:sdb2
> [15751.630244] RAID1 conf printout:
> [15751.630250]  --- wd:2 rd:2
> [15751.630255]  disk 0, wo:0, o:1, dev:sdd2
> [15751.630259]  disk 1, wo:0, o:1, dev:sdb2
> [15754.004658] RAID1 conf printout:
> [15754.004662]  --- wd:2 rd:2
> [15754.004666]  disk 0, wo:0, o:1, dev:sdd2
> [15754.004670]  disk 1, wo:0, o:1, dev:sdb2
> [15754.312749] RAID1 conf printout:
> [15754.312754]  --- wd:2 rd:2
> [15754.312758]  disk 0, wo:0, o:1, dev:sdd2
> [15754.312762]  disk 1, wo:0, o:1, dev:sdb2
> [15759.231107] RAID1 conf printout:
> [15759.231112]  --- wd:2 rd:2
> [15759.231115]  disk 0, wo:0, o:1, dev:sdd2
> [15759.231118]  disk 1, wo:0, o:1, dev:sdb2
>=20
> (etc, ad infinitum)
>=20
> I'm now running a 3.3 kernel and it's still happening. My RAID sets are=20
> working just fine; it's just this nuisance log spamming that's annoying.
>=20
> Anything I can do about that?

Best thing you can do it report it and hope some maintainer notices and hel=
ps
out.   Oh wait, you did that :-)

Looks like:

   commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3

is at fault.  It causes md to attempt to add spares into the array more oft=
en.
Would I be right in guessing that you have one spare in this array?
If you remove the spare, the messages should stop.

I think I know how I'll fix it but it'll have to wait for tomorrow.  Then
I'll send you a patch to test.

Thanks for the report,
NeilBrown

>=20
> root@zotac:~# uname -a
> Linux zotac 3.3.2-030302-generic #201204131335 SMP Fri Apr 13 17:36:17=20
> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> root@zotac:~# mdadm -V
> mdadm - v3.1.4 - 31st August 2010
>=20
>=20
> Thanks, Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/oa7_6CbuyblBs3=CWu=x767
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5Mf+Tnsnt1WYoG5AQL4VQ//ay8jPRtPiGycG9UBYuOcbWDy+iq+qwAW
o2+ifNAqpVgjaxvhjGQZeUfdq8OL1lkl5XRv+f+QqK7Q2X47ES42HDLkHWtK91tV
SP2tP+KHEvnwZVC8T5qh4KWYPn6+k7RzTg36Y7y9lUJ4zi6FBMwR4W/K6A9UofBb
j5dFIUrJAJ33ZdCmUschMRguYhn27YoTvcPY5wxKmhOkXFH2TYHm/VZeuxxxAfcB
koHhD9M4ns/u210nS638l2ZGz3VXoYAPGGiTCLhQIH9slLYVVnA1rSWudBCx++Qc
Mt2Z2DJDbMvT5EnmiVDTHnnEpJht+Q3HvhlV3uIpVC6+qzVBg7/SwXPjHxShbXsG
OXz+FU5VeKwdMGyEXx+CmI7gFvBeVfSiEJUzyctIiWqylrkdDYCmF4bdfgSxnc6y
cXmI5RzxcIDV48fbgl+1aJCeAupzv9ypfAAXaDQOnqdW/nYu5CA9T5YljSRmTEQY
9UKhZXnAvrhI7qorM3/YEdpU9oRSl/YflURVpIgyLPg6BZyW0MebyA2VM70b40bp
G/367Y98W0j6pOuaqTH9C1TZWxRGqKpcuHOOLRPiAFYqGKfFKNy4grGesL/eBhsb
A9V/BqDBgDgpO/SG5OmIcsAKKidrSBE8QayGDC/ePb8x1dXe4AgQRSOrLAQvQb5V
/Qokt7tif3s=
=5ZtK
-----END PGP SIGNATURE-----

--Sig_/oa7_6CbuyblBs3=CWu=x767--
