From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 03/12] raid5-cache: add a new policy
Date: Thu, 08 Dec 2016 10:24:23 +1100
Message-ID: <87lgvr2uhk.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-4-artur.paszkiewicz@intel.com> <87d1h44lcj.fsf@notabene.neil.brown.name> <ba67c43b-067e-c565-8c70-4bb5544392a3@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ba67c43b-067e-c565-8c70-4bb5544392a3@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08 2016, Artur Paszkiewicz wrote:

> On 12/07/2016 01:46 AM, NeilBrown wrote:
>> On Tue, Dec 06 2016, Artur Paszkiewicz wrote:
>>=20
>>> Add a source file for the new policy implementation and allow selecting
>>> the policy based on the policy_type parameter in r5l_init_log().
>>>
>>> Introduce a new flag for rdev state flags to allow enabling the new
>>> policy from userspace.
>>=20
>> This seems odd.  Why is this a per-device flag?
>> It makes sense for "journal" to be a per-device flag, because only one
>> device is the journal device and it is obviously different from the
>> others.
>>=20
>> But with the ppl, all devices serve as journal devices.  So we would
>> need to set journal_ppl on all devices?  What happens if you set it on
>> some, but not others?  I see you get an error.
>>=20
>> I think some sort of array-wide setting would make more sense, would it
>> not?
>
> Yes, it would. The problem exists only for external metadata, because
> for native there is a feature flag in the superblock and a corresponding
> flag in mddev->flags. Patch 12 adds a sysfs attribute to control the
> policy at runtime but it would have to be moved out of raid5 personality
> into the main md code. I didn't like the idea of adding something
> specific to raid5 to generic code and visible in sysfs for unrelated
> raid levels.
>
>> And what is an RWH???  A Really Weird Handle ??
>>=20
>> I guess it is probably a Raid5 Write Hole ?  At the very least there
>> should be a comment explaining this when you define the enum. (remember,
>> you are trying to make it easier for reviewers).
>
> That's right, RWH stands for RAID Write Hole. I think I introduced it in
> the cover letter, but I'll explain it also in the code.
>
>> It might almost make sense for bitmap/metadata to be used here.
>> It can currently be "external" "internal" "clustered".
>> Allow also "journalled" or "partial-partiy-log" ???
>>=20
>> Maybe not ... but I'd definitely prefer a global setting, and one that
>> didn't use an obscure abbreviation.
>
> So do you think the sysfs attribute from patch 12 ("rwh_policy") could
> be made global? This would simplify things but it doesn't seem right.
> And about the abbreviation, should it be called "write_hole_policy" or
> "raid5_write_hole_policy"? Maybe using bitmap/metadata is not a bad
> idea...

How about we call it "resync_policy" which describes how to cope with
unexpected shutdown.  Options include:

 full     regenerate all redundancy info after a crash
 bitmap   only regenerate redundancy info indicated by bitmap
          (both these suseptible to write-hole on raid456)
 journal  raid456 only, though could theoretically be extended
          to raid1, raid10 : log transactions and replay after crash
 ppl      raid456 only: log partial-parity before writes.

With external metadata, this must be set explicitly.  With internal
metadata, it is set best on flags etc.

Thoughts?  I'm not really happy with "full", but I cannot think of a
better name.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhImicACgkQOeye3VZi
gbln2Q/+Op8cTl4pRAtCyCoRYw4you9gd8aMxBzpAp/YtXiy1yVxJkx1JTjzJe6J
+T4zu7v2hXCwC6y0nkSo4+GJhj72pY0VTTwUe8B7hdbJLfpaB0PDXu00m/MoqMJF
Tilpx0Mu3fuTMan7E5Vu9FZnRP8Zo2R/riza6Uubw5kc3Bk7GLKE3hNwsa50yX+j
8CRbESM1H9aggtOXDukLDUulrQ8g0OX5439IxRkhN6oD4b65/7xIFRuxJJ/qxCSY
zZwy14CWATk4c8ehOFxGf1OqqLoqxBMkm2+vrZJgOZaplgqlISp72uXrerE7meq8
FXmru/zbvy/KphlaTSi2R5nfIyN/DKxpIotUwTaYGUJdwJs5B3aM0v3YSvav/FGn
Ww9wGNKK1t3y1vhMzI3HxPbH0bzVuI2OWbtzsaDn2pAvJlpMRfDglBdXZYATPwj0
BtBRk3Q8Om5Y9JrmHjW7vdhzbDh0m2apyOxwnt5tPMa8rNmXUfTzKeQRmoONbuR8
z+YRzvf6yPUqFlM8OEJnlPB0ExscBFu2Rg4aiQbtxO8MUPdEQ4lhd/xh+sfQDPhl
LLo0y0qVNDm4paYa+Xuv+ftAM1wICQhE9j55n191Tkc7cdb+eIYIMzeNCktvEwuf
6L4mEjeex5ZbP2DodY7vRvCyAdiSnXgptP6mYquB4Gu32ChSYkU=
=Mw2w
-----END PGP SIGNATURE-----
--=-=-=--
