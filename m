From: NeilBrown <neilb@suse.de>
Subject: Re: re-adding a disk to a raid1 array with bitmap
Date: Wed, 28 Mar 2012 11:40:14 +1100
Message-ID: <20120328114014.1ac009dc@notabene.brown>
References: <4F5A2ACE.4090003@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mEXvCYlX.JzeGS03rR.NNxV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5A2ACE.4090003@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mEXvCYlX.JzeGS03rR.NNxV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Mar 2012 17:07:42 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Neil,
>=20
> I have been spinning my head over this for a bit trying to figure out
> what is the right solution to this problem.
>=20
> In bedd86b7773fd97f0d708cc0c371c8963ba7ba9a you added a test to reject
> re-adding a drive to an array in some cases.
>=20
> The problem I have been looking at is if one has a raid1 with a bitmap.
> Basically in the situation where we have one of the drives pulled from
> the array, then if I try to add it back, it fails like this:
>=20
> [root@monkeybay ~]#  mdadm -I --run /dev/sdf5
> mdadm: failed to add /dev/sdf5 to /dev/md32: Invalid argument.
>=20
> However this works:
>=20
> [root@monkeybay ~]# mdadm -a /dev/md32 /dev/sdf5
> mdadm: re-added /dev/sdf5
>=20
> I dug through the kernel and it shows up that the failure is due to this
> test in the above mentioned commit:
>=20
> +                    rdev->raid_disk !=3D info->raid_disk)) {
>=20
> So basically when doing -I it seems the disk itself expects to be
> raid_disk =3D 0, whereas the kernel expects it should be raid_disk =3D 1.
>=20
> I agree with the previous discussion that it makes sense to reject a
> drive in the normal case without a bitmap. However it seems illogical to
> me that -a works but -I should fail in this case.
>=20
> What would be the right fix here? Relaxing the test in the kernel to not
> require the raid_disk numbers match up for a bitmap raid, or should
> mdadm be taught to examine the raids and set the expected disk number
> before submitting the add_new_disk ioctl?
>=20
> Cheers,
> Jes

Does this patch fix it?

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D69fe207ed68e560d76a=
592fd86af32a9d1deca25

I found it in a collection of half-forgotten patches recently and decided it
was almost certainly correct, but I didn't remember what motivated it.

It is entirely possible that it was seeing something like the problem you
mention.

The comment for that patch says "This is particularly important for getting
info.disk.state correct", but maybe it is equally important for getting=20
info.disk.raid_disk correct.

So I think your last suggestion is right: "mdadm be taught to examine the
raids and set the expected disk number" - and that patch should do the tric=
k.

(and thanks for the reminder to reply to this).

Note that you might need
   POLICY action=3Dre-add
in mdadm.conf for this to work.  I don't think it is a given that when a
recently failed disk is found that it should always be re-added.  So if the
admin wants that it is reasonable to require the policy be explicitly state=
d.

But I'm not sure if this is currently enforced....


NeilBrown

--Sig_/mEXvCYlX.JzeGS03rR.NNxV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3Jd7jnsnt1WYoG5AQJXWQ/+P9/DfyL9Pbe5iJFXJ7BSi2KIv520faO1
+pAJiLnBkck1zpx/z6iZ5tPiKnW8BdC5yrQTJLgjvBs0CPBaL68PRkTkusVi3AyD
cM1hDAJiFX4U7nOwqFU1K1DCQFyvxd9CbsP1GzXu54R4w9CjLyR8b+Q8m4jloIUz
z/I4gOCTnwseTYTD1uwELLVU1MHAi1sTI2clTXWhKFmpQAhAzHCk//i1bGXo+/ly
qyP2MmtVSB9H0gHvmcTuKoWmBHIrEP7e/Wvvz8e9wMLxLFqWtT18/aeh6VQhFHu6
koWoQIz/pkdqpxgTOgV5YuLlGq2VoZdaAwOnIfB888iGqbRRXL9DIdTHQ0TInpXm
qB+UF1pf92OvkYj7XHOJgYitNKzvl+gkNqgTRQkxatC2TpF2BMS8LdwHr7FHxX3R
fTQr1r7eQzOqfbhhD+zI1nFOnoVs6J8uq2wyzrBEfz5B0mxF5xsd+qKRX6eLUa5v
IiM0rj8nUFiyC3PZkFx1gUh5Fsg3DKrGoXK8g3EZz7vHdKrVJRGFgMPPhDbnC472
AlnWqkiEYdk66NHTd8RqI9lg9cBpwO2J7/i01CpTSxNo/9XYp4j++hlU4Zj8eTSo
hFytuir3pt8+TaFqPrWZZvIAqq6FQ8oKpA/Qg9J0KCAv6kzEcFHcyZKOhoG38GIG
dbwa+j03EN0=
=0+jC
-----END PGP SIGNATURE-----

--Sig_/mEXvCYlX.JzeGS03rR.NNxV--
