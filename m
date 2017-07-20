From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Fri, 21 Jul 2017 08:00:44 +1000
Message-ID: <87d18uydir.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <87o9sn232n.fsf@notabene.neil.brown.name> <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com> <87shhyzhg5.fsf@notabene.neil.brown.name> <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 17 2017, Veljko wrote:

> On 07/15/2017 02:12 AM, NeilBrown wrote:
>
>> So command should be
>>
>>>>   dd if=3D/dev/md2 of=3DSOMEWHERE/SAFE bs=3D1M skip=3D5626590
>>
>> and expect it to create a 3M file.
>>
>> Use this 'skip' number of the 'seek' number later.
>>
>> NeilBrown
>
> Thanks, Neil, now it makes more sense.
>
> I tried to create new linear device, but mdadm is complaining about=20
> data-offset:
>
> # mdadm -C /dev/md4 -l linear -n 2 --rounding=3D1M -e 1.0 --data-offset=
=3D0=20
> /dev/md2 /dev/md3
>   mdadm: invalid data-offset: 0

Bother.
 mdadm uses "parse_size()" to parse the offset, and this rejects
 "0", which makes sense for a size, but not for an offset.

 Just leave the "--data-offset=3D0" out. I checked and that is defintely
 the default for 1.0.

> I noticed that md2 and md3 use 1.2 metadata. Can that be the issue?=20

No the metadata on md4 is quite independent of the metadata on md2 and md3.

NeilBrown


>
> I'm using Debian 8.8 if it makes any difference.
>
> # mdadm -V
>   mdadm - v3.3.2 - 21st August 2014
>
> What could be the problem?
>
> Regards,
> Veljko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllxKA8ACgkQOeye3VZi
gbkcZQ/+NdeFqKg9W60/oyOs/7hOARgqrOTa4b3ehqQe1rXxDmwCoqwWQtU5i5Zr
aeXKLZ8O2zKzlhPpK77vN+eo+tfGeOJtXjQwlIBGdS61TmceudaWys0QAEIor1p9
jYL2weQDpWGP/ZQcbIrHz5cWDJ1ZMoaSF6pNoya6ITTLrhdv/qx6jmocDec3LvQ+
6M++gz53ygsIEBlXifYZBGmgL0GSxDmS0I985YVWJDqXtxyCaHaQVWxdBNz2+rKx
WJwAiXOkX3pKVT/LLnp/JDMACVrR9scOaMRytxv9XhlKR67VHb2C8iERpjkxPs9g
PCITYYsN114DcFpPKd/AIAucPcgKMs7/85gn8+YQB3r474D1VW13neevGiK1ZnsC
DhTxP/wvlAT14P0VygddlDS+2AkFznQaeiw/psD8UYSmu+9IrHnMqT3kfyKlUzTe
0xPC+T8xgKWmZSBpmUsZs7rAfSEDRtw1b2jkOMOlzQrYQ1YqXxcuxTLvly4PilSX
CZZd+YQyz3a2I2aZFhUXENXXTIIIeRfWxZb+BiK8zvQcLejPvMHp60P8VENTCea/
tO0hSYixmpNvCmZtGfaQgSkoFNM5S+vyXMrrR8rLNgiBUKDGmDbzuTTOW3uwkUPz
r+05uervC+LQHzuZXXy7aUQSULpap6eK1K655ekTHkBOT1k5KBI=
=ny/M
-----END PGP SIGNATURE-----
--=-=-=--
