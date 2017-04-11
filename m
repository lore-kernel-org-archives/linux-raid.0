From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 00/10] Simplify bio splitting and related code.
Date: Wed, 12 Apr 2017 09:27:07 +1000
Message-ID: <871ssywmno.fsf@notabene.neil.brown.name>
References: <149136485390.25893.1797855041954158826.stgit@noble> <20170411170112.4txdyjdat63qpsi6@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170411170112.4txdyjdat63qpsi6@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11 2017, Shaohua Li wrote:

> On Wed, Apr 05, 2017 at 02:05:50PM +1000, Neil Brown wrote:
>> This is part of my little project to make bio splitting
>> in Linux uniform and dead-lock free, in a way that will mean
>> that we can get rid of all the bioset threads.
>>=20
>> The basic approach is that when a bio needs to be split, we call
>> bio_split(), bio_chain() and then generic_make_request().
>> We then proceed to handle the remainder without further splitting.
>> Recent changes to generic_make_request() ensure that this will
>> be safe from deadlocks, providing each bioset is used only once
>> in the stack.
>>=20
>> This leads to simpler code in various places.  In particular, the
>> splitting of bios that is needed to work around known bad blocks
>> is now much less complex.  There is only ever one r1bio per bio.
>>=20
>> As you can see from
>>  10 files changed, 335 insertions(+), 540 deletions(-)
>> there is a net reduction in code.
>
> Looks good and makes code simpler, applied, thanks Neil! The patch 1 and =
6 need
> comments in the code to explain how deadlock is avoided though. Care to s=
end a
> new patch?

It isn't clear to me what sort of comment you want, or where it should
go.
It might make sense to have a comment near bio_split() explaining how to
use it (i.e. explaining the pattern used in various patches here), but
I don't see what sort of comments would help in raid1.c or raid10.c
??

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljtZksACgkQOeye3VZi
gblvmg//ZnPBj6QOJKUUG770uNnqGs3xZVwDodcX8PQlNAPMdPlY/uUGAmfH9orB
08oFwyvzgXyP5BNV5nFeVnd/0Nx4aEsCUO9OV8ZG/Qodl4T3XK13MmQL9xervdJX
6vJ44OFJFapeHWMcLEIAiKwWaPk19DzjPMsBxWCOu3LYOCEfQ5H9N8bSys36oHlN
ta4XmZ6Nv/FhFq8VDbUcXR1uim+kPeX2+pfolXKtz/5cI7+08dSfWUaiVJoM1Quu
jEaxB8IfZAcEo62gaWfPSbM1DpRaj/9/kxITxSEUROKKryu4IgKGJg3zfGmkQFJT
RgxNbFH/oz4fm4I9tjhpGNGBWz3osTjlRhoQehEP1OfUALpr2ap6f9iagVs3iU/b
X3OjNi/TOYn05CLnXgdEsOPuF13feuIT1e389ok+2xuyYHnxR7sbSWX1FUsq9/yK
gP4Ju2TlLI5Y/WfR7pqjJX3hpRflOXoaxuD+wCMKu0BeRstRskvESYU0/7qAivB/
dyNlOTjWvDTjk08ziFyEJKQ57TdrWXbEyQMO61DbfJAfrFnxVeednjBnzPo5TEUI
KyOWSlpMGV7SHvksoY+m+b/pethNyzvZIxvMvbwaRFcUmRcbYzW9iWNEDRS6CUzm
X+Fq719606MKB4LARi/Vdb5t1vSihOM5iB5VsTianA1jlLGRlHw=
=tyd0
-----END PGP SIGNATURE-----
--=-=-=--
