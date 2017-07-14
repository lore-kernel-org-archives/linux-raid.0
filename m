From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Fri, 14 Jul 2017 12:05:25 +1000
Message-ID: <87iniv22oq.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <87o9sn232n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9sn232n.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Jul 14 2017, NeilBrown wrote:
>
> Now create the linear from /dev/md2 and /dev/md3(?).  Be sure to use
> "-e 1.0 --data-offset=0".  This creates /dev/md4

I meant to add:
 if you want the linear device to align with raid10 stripes (which seems
 elegant, and might slightly help performance is rare cases) you can use
 the "--rounding" mdadm option.  e.g.
   mdadm --create /dev/md4 -l linear --rounding=1M -e 1.0  --data-offset=0 .....

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloJuYACgkQOeye3VZi
gblpQw/+ItMLBOHOV97ihPlDAsdF/OfBFFV/EOQwFMonX8B8fdU+clp0xPZiQSPz
8WLLPzgRw6TL1x4odIs6kGYWbTkrZwUHX5b5wTzr6MlacGVurXQH97J3PbhCcu9Q
zzs8ISosLED7yGZ7F6zxjv7DzQBXsjQLR455ZiQYur0YeHmZmoEXQ51MpHp9y5vH
oK6sG8G0FD/R5OjAyMMTzsnF9am6yYXD0AN8uqirtM3rc1W0V8rHPP2ltspWx50l
jgCW4rEIlEK6WITM3a5oCRVOXjPjUWgQ2PYaTlDhERu+vPSSRmXJkWjJuFWggAQq
BKaJqHgb7jkZhnQWGRFmFhPT9ZlUl2Ve8GvPOQV4D7Hb6C6MyYNFilE+MgzzAtwM
tYGk/cl2wFEqgvuzSNBG2r8GKG16OD8EaTWRtJ91gTQnPEWvD4pLFDleJxOVIOiX
Js+Ni1bhXnovDDp8DrvbTvijEwt5X7ApLyNJY3gL8tsITPXiKso1RRe3QP9MMp9k
HC3N7zVQ/AxhHIu33PfxdL4ltA6sWmwkMcRe0NvC2m9dq2I4mOKciqOKLxGg5Wc9
60TWotCmFApbdv4MDYdm4q7EoYuLOUzm2qPOYffQWHPIkF0WY/H4+3GJruzRxRlJ
699rnyjipxMbYO50IPZ8+mW4Hbt4d0z5dsjxBH4FWbxSw1r5Tkw=
=NMOv
-----END PGP SIGNATURE-----
--=-=-=--
