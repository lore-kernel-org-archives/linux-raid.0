From: NeilBrown <neilb@suse.com>
Subject: Re: Reshape stalled at first badblock location (was: RAID 5 --assemble doesn't recognize all overlays as component devices)
Date: Fri, 03 Mar 2017 11:27:47 +1100
Message-ID: <8760jrnr0c.fsf@notabene.neil.brown.name>
References: <CAF-KpgY0ySvCN9ftbDmW_P6wDiyfN2yWE6=NECVru4=vCe+pbQ@mail.gmail.com> <20170221175801.wt64t2tzcvg3sfmc@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221175801.wt64t2tzcvg3sfmc@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Feb 21 2017, Shaohua Li wrote:

>
> Add Neil and Jes.
>
> Yes, there were similar reports before. When reshape finds nadblocks, the
> reshape will do an infinite loop without any progress. I think there are two
> things we need to do:
>
> - Make reshape more robust. Maybe reshape should bail out if badblocks found.
> - Add an option in mdadm to force reset badblocks

The second of these is already possible
Commit: 6dd16dac4001 ("Add --update=force-no-bbl.")

It isn't documented though, and only works during "assemble", not on an
active array.
Writing to the "bad" blocks should remove the "bad" status.  It would be
nice if mdadm could locate the bad blocks, map them to array blocks,
trigger a limited "resync" if there are any good copies, or write zeros
if there aren't.

And yes; reshape should be more robust...  if only we had a pool of
developers, eager to work on these problems :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4uIMACgkQOeye3VZi
gbm1Qw//blWR0ZOv503+Q2nhid44XOXLZYcCTfPHLgOV1cQ/wFcnyKN34kSq+9ei
cuYAe/Y/j9OV/wBA51AZlBPe1nZgoM2SlS7D2BRpDWwuatSzAdLZFy8GYwVatokG
gBIWtt0KM2fQTO/FUefAFy91kf6X/B3SQEM27Rr6DxmGjISzYcZR6c4+or+hrlK4
ec3V2uVhvngpk7mg5URVw3bbv35GgrTTMDw9Ou3VmVI2oSHhe1RJFMdeydPo3a3k
Uj9ACTVVUTtA3jJ978lisLCkEOLJQ1L1jLRn5PNSyNhN9OoCalUIlrgZbRd7YUSS
5mK2cX8t9NCi9jDImttPbYMK2PfyDaYlVDCxzqZl6IsrII68U+kB28EKRwRD4V7b
pZ2E4IAzVnlsvR6xJWDkvyY+PKt7XqdxKLlb8eE+qFMF9ntFc8hxid4m8TdJIUKN
QhBZliRju8AsIWoeaGnLYsPCFa5OYmQjibpOM+17p+sQ4Q/Zqp+mzFEzA+FFLPGQ
l+OGLD/Yq2Uyuqew4SFQHO2Gwv8KoJTibxugx7MP5uAR323Dvrjbi12Rg333wJ3Y
kBYN3Nt7xOoBMZCdy3UdkCkNr53XlZxAc6//d7dmIcJvaXnmIWdcrWJO5zchRYaY
phMT3KACWxnSFJSwdAE2TlrODZJNMed3PZgec57z4Oz/Tnjsfqw=
=MWAV
-----END PGP SIGNATURE-----
--=-=-=--
