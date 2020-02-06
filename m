From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm RAID1 -> 5 conversion safety
Date: Fri, 07 Feb 2020 09:41:47 +1100
Message-ID: <87a75v8hjo.fsf@notabene.neil.brown.name>
References: <CALZj-VqNACF+Dn5rBrLaVmvVE2weOAjqtvWpwKU7sE=72nyvXg@mail.gmail.com> <5E3B09A5.8010209@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E3B09A5.8010209@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Paul Dann <pdgiddie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05 2020, Wols Lists wrote:

> On 05/02/20 11:51, Paul Dann wrote:
>> Hi there,
>>=20
>> I've got a load of data on an md RAID 1 array assembled from 2x4TB
>> disks. I'm looking to expand this by adding a third 4TB disk and
>> converting the array to RAID 5. Now the required procedure is
>> documented on the wiki, but my question is:
>>=20
>> When I convert the RAID 1 array to RAID 5, the array will be in a
>> degraded state as it rebuilds onto the new disk. However, if one of
>> the original two disks were to fail during this procedure, is mdadm
>> smart enough to convert the array back to degraded RAID 1, or will my
>> array now be a broken RAID 5 with no path to recovery?
>
> There is a "revert reshape" option which will take you back to a raid 1.
> This assumes, however, that it's the new disk that has failed.
>
> I'm pretty certain, however, that should one of the old disks fail
> during the conversion you will end up with a degraded raid 5.

This is correct.
It is not true to say "the array will be in a degraded state as it
rebuilds onto the new disk" as Paul did above.
During the rebuild the array will be in 2 parts:
 - a non-degraded raid5 which starts small and grows
 - a non-degraded raid1 which starts large and shrinks.

at no point in time is the array without full redundancy (unless a
device fails of course).

NeilBrown


>
> If you're worried, I would make sure you've done a SMART health check on
> your two original drives, although that's no guarantee everything's okay.
>
> If you really are that worried, get two new disks with the intention of
> ending up at raid 6. Add a 3rd drive to the mirror, fail and remove one
> of the originals, add the 4th to go raid 5, then add back the first to
> go raid 6.
>
> One thing I will say - MAKE SURE you have the latest mdadm, and if
> possible make sure you're running a recent kernel. There have been
> issues converting from 1 to 5. None of them serious, and all fixed by
> upgrading mdadm/kernel, hence the advice to be running the latest/greates=
t.
>>=20
>> Many thanks,
>> Paul
>>=20
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl48li0ACgkQOeye3VZi
gbk9Vw//ZKdqktaHGetpzhAfc0gQdCfj0Yd6DNtG7HoDDNW82N8v4ZMt6l75pi75
zoGpKowibD4RJlxIGrZ/mnf7fPizGo5U0OYmMSDcd1FJE0h4DMf30e4Q6geS18IX
Kx3DNI6WFK7CfWpLLLqpWUtKE6CJbHh9bEDLecnBTTe67neBJzu0v3/7tE+LoS12
aVyAJxLb2YeOG2kujvLqelqhRn7sRwGN0z3IcrPSGdyUpnGY9n7yt2PF6/9LkNJF
iQXciayDIdQAdik5aqs3htD144ekG1p9RYjHUQl/E0/JZ7C0Hjm7jgqfMPsBpLNN
DNQ8qo8Yz7Qs6EQh4Uod7oNC7sTb5Kgto6rKuvyB0mZ8CDC81NZa9mflGg09bRIs
TXUba7cssnXrW/bsyS1gho7IPvyVTK/yqXdlI24zcE5WE0Qt1Gv1mFB8Edh3vXqf
o8L8wEEGqQ5JhNrz9jqbGmmfIcfs4tiMQiZ70LguXfqyyZ4HW5FI8MoRuWeJGwFC
ZV0QhpvpPrHD86NyfqK3XO3+3UPnDfTb+/PgvZMDWybqrabC8sgZ3JOngDnbRVEo
ytHj6Q2YtBXm1mNwSFnopt1RK6RdwXk+rbPwZhx2A1SUNy6Xxh3n4CEGUi7hT4bs
JI1expr4dfYI+i3bGsKpPqLxBerlSiVk5Jhpco9DEK2KNhvHfCc=
=fSvs
-----END PGP SIGNATURE-----
--=-=-=--
