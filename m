From: NeilBrown <neilb@suse.com>
Subject: Re: moving spares into group and checking spares
Date: Thu, 29 Sep 2016 11:21:17 +1000
Message-ID: <8760pf7b76.fsf@notabene.neil.brown.name>
References: <nramjg$n07$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nramjg$n07$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 14 2016, scar wrote:

> i currently have four RAID-5 md arrays which i concatenated into one=20
> logical volume (lvm2), essentially creating a RAID-50.  each md array=20
> was created with one spare disk.
>
> instead, i would like to move the four spare disks into one group that=20
> each of the four arrays can have access to when needed.  i was wondering=
=20
> how to safely accomplish this, preferably without unmounting/disrupting=20
> the filesystem.

You don't need to move the devices.  Just use the spare-group=3D setting
in mdadm.conf to tell mdadm that all arrays should be considered part of
the same spare-group.  Then "mdadm --monitor" will freely move spares
between arrays as needed.

>
> secondly, i have the checkarray script scheduled via cron to=20
> periodically check each of the four arrays.  i noticed in the output of=20
> checkarray that it doesn't list the spare disk(s).  so i'm guessing they=
=20
> are not being checked?  i was wondering, then, how i could also check=20
> the spare disks to make sure they are healthy and ready to be used if=20
> needed?

mdadm doesn't provide any automatic support for this.
You would need to e.g.
 - remove a spare from an array
 - test it in some way: e.g. use dd to read every block.
 - if satisfied, add it back to the array.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX7GyOAAoJEDnsnt1WYoG5jtsP/j2hwJ38/RPYdBh4WeJyq48o
Wv8qVbz5yQW5fuKHO2MFK1Q3YJqyN8aEfEevsLbXFZarI5jrByTDIRUbHv49zztK
T9L+CjBCET0SD896eF5UbcRYaMKhTCOjUeNj9o2ZzNfN3O6Q8lzAYL+jicxknXJA
+ZtnZwcGRn0ajA+Egu456TEuzA5BE1WaDu+5olsT/Wt2x4P27lc6HJlkwUwcMjob
YsjqyLnAyPgi2M1B/Vwc+J+e4Q518RFaIoirZEjYXWBRbJ5dO1TeDOtTYxINpbLY
RHbfBej9sjPvxtJjlniKeUEYokBdI+m5wjVIVmRDigL0qlLv7m4Qf/ifGKPOINGt
Et9KWQmsSPlxZ1YeufWQ4UZJBocutrlZP1mQqvR4ng/zV4IcqtqAUHSOvmJL8B2y
J2QdZxh1R7ZMpgDkvCi8U6pVquHxQU7YLqrfdcAcNo4thAz51hVZrHVM4tVplpv5
+ViUQV0dNOJb54dC0NPppT6v+/4+3DpcVXQ0ZVtJJECYlvAKtHhAN8VqPpSwPcy/
ko40of13MJO0fRLvxjdmbf4/AyDdXi+Agsq+B67UMJuCvxUkyqrMlVqMO/YUIdI5
++ohRsB89d3GCCALQZjohAi6COp9JTruFnmRW8RaV8CrAQOlRrYeN2kth5n2jhgM
GErNmniD59Ba4V78egL6
=6R7c
-----END PGP SIGNATURE-----
--=-=-=--
