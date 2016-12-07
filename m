From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 03/12] raid5-cache: add a new policy
Date: Wed, 07 Dec 2016 11:46:36 +1100
Message-ID: <87d1h44lcj.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-4-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-4-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> Add a source file for the new policy implementation and allow selecting
> the policy based on the policy_type parameter in r5l_init_log().
>
> Introduce a new flag for rdev state flags to allow enabling the new
> policy from userspace.

This seems odd.  Why is this a per-device flag?
It makes sense for "journal" to be a per-device flag, because only one
device is the journal device and it is obviously different from the
others.

But with the ppl, all devices serve as journal devices.  So we would
need to set journal_ppl on all devices?  What happens if you set it on
some, but not others?  I see you get an error.

I think some sort of array-wide setting would make more sense, would it
not?

And what is an RWH???  A Really Weird Handle ??

I guess it is probably a Raid5 Write Hole ?  At the very least there
should be a comment explaining this when you define the enum. (remember,
you are trying to make it easier for reviewers).

It might almost make sense for bitmap/metadata to be used here.
It can currently be "external" "internal" "clustered".
Allow also "journalled" or "partial-partiy-log" ???

Maybe not ... but I'd definitely prefer a global setting, and one that
didn't use an obscure abbreviation.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHW+wACgkQOeye3VZi
gbnsZhAAvA+RqlAyrbEAoChy0ArBbpkLhO8eLmtZHc06B0HxZPzm7NN8iWXDeDjI
Ib+FtE2yGbf4EomU3s1f+KA/PoIMcOPz0hvGV5bRJ0ivaCbCKD+HkuExQ+MxB4k2
/Mjg6YEJ2ejuDlJHDIXR8powi1Y4oLhjInOkm8uFHd4NuASWFKosGC2VTCCxOqW0
0C0Y3LpaJROT3s7s4W4wU6BziHz32KJ/oNudAlvisNalsRDHx1gZoGCeeoeJx8Bl
MPwesodmDOdoLvb72dUpjW1W+PYF9Jz48TD/ORUoMZaZPWyWdLQpxa0j4P5arBnW
XXEypLKUwkAkMJvqu9PBRbKpOK6TZUMm3U+jmdBHsvrdETzcC/qmo0+QKMwX0CEb
USAUS3FAKBHfZc5WEAtMcs8/aZGWgp9X9VtxoR+EK863USS06CJXxQfU3K9ndKg+
mdLoXEkVGDPCmM8HCGh6iBPp3Qgp2i8aq8dUslxcALfaSrI4OKIvNrYePvdrLh5l
jsbscM+pHFXfUM+5D1Kb4QO3C2JjvmolRoZB9opqZZI1k0J2FlKNccNNbYSWZon2
/svXOCcXt+Uz63anohFksWsSCfVJpEiWSrrrsKy5kWYiEQnwOWt6cK7adKjGR/Ng
0nGrHo5OOdUCvJm+Y01fduRAaLlSNlcDMIOLMa+ELzFLjLns7Jw=
=/1C4
-----END PGP SIGNATURE-----
--=-=-=--
