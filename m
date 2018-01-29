From: NeilBrown <neilb@suse.com>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Tue, 30 Jan 2018 08:50:20 +1100
Message-ID: <87fu6o5o83.fsf@notabene.neil.brown.name>
References: <mqdvafkhep0.fsf@linux-x5ow.site> <5A6F4CA6.5060802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A6F4CA6.5060802@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29 2018, Wols Lists wrote:

> On 29/01/18 15:23, Johannes Thumshirn wrote:
>> Hi linux-raid, lsf-pc
>>=20
>> (If you've received this mail multiple times, I'm sorry, I'm having
>> trouble with the mail setup).
>
> My immediate reactions as a lay person (I edit the raid wiki) ...
>>=20
>> With the rise of bigger and bigger disks, array rebuilding times start
>> skyrocketing.
>
> And? Yes, your data is at risk during a rebuild, but md-raid throttles
> the i/o, so it doesn't hammer the system.
>>=20
>> In a paper form '92 Holland and Gibson [1] suggest a mapping algorithm
>> similar to RAID5 but instead of utilizing all disks in an array for
>> every I/O operation, but implement a per-I/O mapping function to only
>> use a subset of the available disks.
>>=20
>> This has at least two advantages:
>> 1) If one disk has to be replaced, it's not needed to read the data from
>>    all disks to recover the one failed disk so non-affected disks can be
>>    used for real user I/O and not just recovery and
>
> Again, that's throttling, so that's not a problem ...

Imagine an array with 100 drives on which we store data in sets of
(say) 6 data chunks and 2 parity chunks.
Each group of 8 chunks is distributed over the 100 drives in a
different way so that (e.g) 600 data chunks and 200 parity chunks are
distributed over 8 physical stripes using some clever distribution
function.
If (when) one drive fails, the 8 chunks in this set of 8 physical
stripes can be recovered by reading 6*8 =3D=3D 48 chunks which will each be
on a different drive.  Half the drives deliver only one chunk (in an ideal
distribution) and the other half deliver none.  Maybe they will deliver
some for the next set of 100 logical stripes.

You would probably say that even doing raid6 on 100 drives is crazy.
Better to make, e.g. 10 groups of 10 and do raid6 on each of the 10,
then LVM them together.

By doing declustered parity you can sanely do raid6 on 100 drives, using
a logical stripe size that is much smaller than 100.
When recovering a single drive, the 10-groups-of-10 would put heavy load
on 9 other drives, while the decluster approach puts light load on 99
other drives.  No matter how clever md is at throttling recovery, I
would still rather distribute the load so that md has an easier job.

NeilBrown

>
>> 2) an efficient mapping function can improve parallel I/O submission, as
>>    two different I/Os are not necessarily going to the same disks in the
>>    array.=20
>>=20
>> For the mapping function used a hashing algorithm like Ceph's CRUSH [2]
>> would be ideal, as it provides a pseudo random but deterministic mapping
>> for the I/O onto the drives.
>>=20
>> This whole declustering of cause only makes sense for more than (at
>> least) 4 drives but we do have customers with several orders of
>> magnitude more drivers in an MD array.
>
> If you have four drives or more - especially if they are multi-terabyte
> drives - you should NOT be using raid-5 ...
>>=20
>> At LSF I'd like to discuss if:
>> 1) The wider MD audience is interested in de-clusterd RAID with MD
>
> I haven't read the papers, so no comment, sorry.
>
>> 2) de-clustered RAID should be implemented as a sublevel of RAID5 or
>>    as a new personality
>
> Neither! If you're going to do it, it should be raid-6.
>
>> 3) CRUSH is a suitible algorith for this (there's evidence in [3] that
>>    the NetApp E-Series Arrays do use CRUSH for parity declustering)
>>=20
>> [1] http://www.pdl.cmu.edu/PDL-FTP/Declustering/ASPLOS.pdf=20
>> [2] https://ceph.com/wp-content/uploads/2016/08/weil-crush-sc06.pdf
>> [3]
>> https://www.snia.org/sites/default/files/files2/files2/SDC2013/presentat=
ions/DistributedStorage/Jibbe-Gwaltney_Method-to_Establish_High_Availabilit=
y.pdf
>>=20
> Okay - I've now skimmed the crush paper [2]. Looks well interesting.
> BUT. It feels more like btrfs than it does like raid.
>
> Btrfs manages disks, and does raid, it tries to be the "everything
> between the hard drive and the file". This crush thingy reads to me like
> it wants to be the same. There's nothing wrong with that, but md is a
> unix-y "do one thing (raid) and do it well".
>
> My knee-jerk reaction is if you want to go for it, it sounds like a good
> idea. It just doesn't really feel a good fit for md.
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpvlxwACgkQOeye3VZi
gbmqbw/9GtZaOsTvQ0Ob2tC3INRZxyEVZei103CIsWF2U+/RjRlFbZI11xI2mu2G
Gb216HLjynmE5V/sbH47FKmagYIEs9ItAUdJpmvFtlkdNYf8k9xiLOgcuoOzLmG0
v6/UloRzcUt/6QReJqbImdtepWReKdoSjPx0bEfhm372tbYT7EmBDJGFQWj450O0
SohIM0RZwXAs5H8HIZN0BSR43qSpOZ0k3rU/NsS5RVJvVgjnEthllbsmXEu1jNnZ
KbteO8GPlgwWUZTrJpWozTLLXCh9hv4eF6T1yISR6Ej7VrVBYbJAiIheNbOKwPWk
3DaOILjCeyo6YyNkSy+H+SPeMqT/2Sr22JXCkINgYIy8WM9nA3zc1iCd0qzjxuIQ
xE2nUbf6vaxAoxu7BT5NaHomBn2yaygTEsIZmra+HrgKZGoZpengrQ7X4REs95i0
ypO08nYWc5U4sMG7+0SrV2r6prqr9QuoVfRWK0tKrKoJoUMWrrTFGrFs7V3UjXQ4
a7UDhOwPk7vjFnK40/LPrGJsouiCdUfBQfx+/V2YCZonmjhmmwBtBzV4kqRncjJm
LziC8mnX+SOzjHjluV1KkC7l8oKHK0Yiyq11W7wpkVsQT2thTUi+9VXzOunhuvvE
IF2G9Jau/LU9RjR+kQB46gep1DZYw+br3NKiCT+Nbrlw9fLYRoE=
=kYSc
-----END PGP SIGNATURE-----
--=-=-=--
