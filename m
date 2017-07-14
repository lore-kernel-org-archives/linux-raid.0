From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Fri, 14 Jul 2017 12:03:21 +1000
Message-ID: <87lgnr22s6.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <1b1d6d77-c17b-ada0-9a04-c724d34c9c1d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b1d6d77-c17b-ada0-9a04-c724d34c9c1d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12 2017, Veljko wrote:
>
> Data offset is not zero on md2 partitions. Is that a dealbreaker?

No.

>
> Would it be than better to reshape the current RAID10 to increase the=20
> number of devices used from 4 to 8 (as advised by Roman)?

I cannot comment on "better".  It would be different.  Both approaches
should work.  End results would not be identical.
A reshape would take longer, but would leave you with just one array to
manage.

NeilBrown

>
> Regards,
> Veljko
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloJmoACgkQOeye3VZi
gbml4w//e/h2fCd88EFZndT8UFMFOCn1FWInxL/3uGvp7HVhX5J1W5q1Os0EFkgr
cULP17hbBx6Dher5OUJ4aju2SRsGVR90f890kNliIgu10aalS2nSwBu09XVvWJJo
kaG4UKwdDkX8O6aZPJ46sZaf9uAs3ATNJST8uoB/OcsEkl0118K8fCoF8cD/qNTp
qGfy/Rjx5KCQERxnz5ZjPSoq3PylflpfTJcDONtDpBRegswkpMWiZxyDqj3QpPTn
cwYxr64RxVXiLrCB4tcdgI6IicgWm0Z/cpdtF2LEbF48OC2up8s3s4xN6FncMeMn
TeG+ze7ZBN3WByLOf+cG9TMKSdyMduSEiUHKg5sArneOHxrqfbzKSG+P9GMEAgNZ
E7GAR1p51pukTSuBAxxy9AObdohJA6911ekcSgkNVYdZFLxxFz18469aavQXW3ke
Pp81NiJgJddK81pnQ+RwcSLOkp9aQLtsG/j+jyqLcUP57WsUBeIT3jZidwsDdAcX
/SmOdUOMmyL7kP1f8XXAohnUaEqVNAqzqQd5G5bO+QS3BEaJP3Fq7Vkk7TXCTD1p
dvlCtJQyJuLicj5KkyyO795SffPdGUcQxgnQTFeLdmZophQn7ajRN36PiJ3hrk9H
82VJzqRSuYGrfJrHmgaPNG6SrhWvnxY8kN92r0osQ4mLKibwZHI=
=e1C3
-----END PGP SIGNATURE-----
--=-=-=--
