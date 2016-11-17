From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 1/4] md: add block tracing for bio_remapping
Date: Thu, 17 Nov 2016 16:33:33 +1100
Message-ID: <87twb6hdqq.fsf@notabene.neil.brown.name>
References: <147910131504.27168.6566119701315109161.stgit@noble> <147910142095.27168.11356591734977480053.stgit@noble> <20161116192922.ylqx32zocag4xp4b@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161116192922.ylqx32zocag4xp4b@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17 2016, Shaohua Li wrote:

> On Mon, Nov 14, 2016 at 04:30:21PM +1100, Neil Brown wrote:
>> The block tracing infrastructure (accessed with blktrace/blkparse)
>> supports the tracing of mapping bios from one device to another.
>> This is currently used when a bio in a partition is mapped to the
>> whole device, when bios are mapped by dm, and for mapping in md/raid5.
>> Other md personalities do not include this tracing yet, so add it.
>>=20
>> When a read-error is detected we redirect the request to a different dev=
ice.
>> This could justifiably be seen as a new mapping for the originial bio,
>> or a secondary mapping for the bio that errors.  This patch uses
>> the second option.
>>=20
>> When md is used under dm-raid, the mappings are not traced as we do
>> not have access to the block device number of the parent.
>
> Looks the the original sector (the last parameter of trace_block_bio_rema=
p)
> isn't correct.
> - in linear/raid0, bio_split already updated bio->bi_iter.bi_sector

Oh yes, of course.  in the common case 'split =3D=3D bio' so when
split->bi_iter.bi_sector  is adjusted, bio->.... is as well.
I'll fix that, and also add calls to trace_block_split() as appropriate.


> - in raid1/raid10, r1_bio->sector is updated before the bio is sent.

Here I really think my code is correct.  r1_bio->sector is always the
address in the array of the request.  It is only set once for each
r1_bio, and that is before the call to trace_block_io_remap().

Thanks,
NeilBrown


>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLUEtAAoJEDnsnt1WYoG5EvgP/3MoCHvnru3ENId+Nu+h45HO
osMP9zUwCVXBCf/OhA6icUXW75iN3RpiCd31jnlIjclca58XjBcoBiN6QpQGrWLK
KZMMBC8SeQ55lUZ5c7d/A4vmJDFu76eteAnwTo71/egsZZ+4W7qduVS5Cnx3vmXP
3PR0ArYXLmC/PAGg0D4fVzAAtNCymY7gE1gW5gYdCRYVjBj69HX3FKNje/I87woE
8/Hz0A0jsrptIFVaZGXMA4Nm9FjPGKQ9dl7kyxo+LZsHk3kMZuuD//LtlazBZkCt
zj53xy/afbbTFWETZxstOV7j78nYlQeyYz3prGc0grR7fWIicMr2aHoVACb0+osI
TNDDOJDs8Kio1gSi5lGIUb7bAljt2931dxYJZb8DvStD6umwpBAi7aC61YJ/PH4h
sgTRXnux6+oWGj4zyxKLObIKMuyaFH2zk3iLaFAQBNY+8ugn9sWp1OkXf5Bq2V7K
yNy4rjlZL8jlGN54UcxAgAk3+uzsGlKwLdpIxe0psOPZNhuTNg61vCIeH1rUdoob
CfCf4tEn7zP4g+MUbADSS5I4QtRRQusVsgNa/kPKYgSFQYMzeWWWgY4dSkv+P1n0
uGJwELE9DaKLHFpzOb8rrHMvjG08cvRXNYWcNeuodjessnV+hV1KT9Hmdcs+ZRW+
4q4ZN52hCbK96wwWsJIk
=NPPL
-----END PGP SIGNATURE-----
--=-=-=--
