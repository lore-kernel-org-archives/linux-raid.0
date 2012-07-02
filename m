From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Mon, 2 Jul 2012 17:57:15 +1000
Message-ID: <20120702175715.30724b9d@notabene.brown>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
	<20120627172255.40ee3a19@notabene.brown>
	<CAGRgLy5U_Xzr=LDuQ6R7dEzx4EiNyWQb1fiSQhq_F+oTmyZw1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m6Y1lX/Y0eygHiZSo005uJa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5U_Xzr=LDuQ6R7dEzx4EiNyWQb1fiSQhq_F+oTmyZw1Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: andrey.warkentin@gmail.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/m6Y1lX/Y0eygHiZSo005uJa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jun 2012 19:40:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> >>
> >> I would still think that there is value in recoding in a superblock
> >> that a drive is recovering.
> >
> > Probably. =A0It is a bit unfortunate that if you stop an array that is
> > recovering after a --re-add, you cannot simply 'assemble' it again and
> > get it back to the same state.
> > I'll think more on that.
>=20
> As I mentioned, I see the additional re-add as a minor thing, but
> agree it's better to fix it. The fact that we don't know that the
> drive is being recovered, bothers me more. Because user might look at
> the superblock, and assume the data on the drive is consistent to some
> point in time (time of the drive failure). While the actual data,
> while doing bitmap-based recovery, is unusable until recovery
> successfully completes. So the user might think it's okay to try to
> run his app on this drive.
> Yes, please think about this.
>=20
> >
> > Meanwhile, this patch might address your other problem. =A0It allows --=
re-add
> > to work if a non-bitmap rebuild fails and is then re-added.
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c601c4b..d31852e 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev, mdu=
_disk_info_t *info)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super_types[mddev->major=
_version].
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0validate=
_super(mddev, rdev);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((info->state & (1<<MD_DISK_SYNC)) &&
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!test_bit(In_sync, &rdev->flags)=
 ||
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (test_bit(Faulty, &rdev->flags) ||
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->raid_disk !=3D info->raid=
_disk)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* This was a hot-add re=
quest, but events doesn't
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * match, so reject it.
> >
>=20
> I have tested a slightly different patch that you suggested earlier -
> just removing the !test_bit(In_sync, &rdev->flags) check. I confirm
> that it solves the problem.
>=20
> The Faulty bit check seems redundant to me, because:
> - it can be set by only by validate_super() and only if that drive's
> role is 0xfffe in sb->roles[] array
> - Long time ago I asked you, how can it happen that a drive thinks
> about *itself* that it is Faulty (has 0xfffe for its role in its own
> superblock), and you said this should never happen.

Yes, you are right.  I've remove the test on 'Faulty' - the test on the
raid_disk number is sufficient.

>=20
> Anyways, I tested also the patch you suggested, and it also works.

Thanks!

>=20
> Is there any chance to see this fix in ubuntu-precise?

Not really up to me.  It doesn't fix a crash or corruption so I'm not sure =
it
is -stable material .... though maybe it is if it fixes a regression.

I suggest you ask the Ubuntu kernel people after it appears in 3.5-rc
(hopefully later this week).

Thanks,
NeilBrown


>=20
> Thanks again for your support,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/m6Y1lX/Y0eygHiZSo005uJa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/FUWznsnt1WYoG5AQJmwRAAvrTKSI4TsmRy02wLLGClLf5+yS7MNnfa
KWFKJvvE+SdXgSfzpaGiXt0iBqAXeYZmpHbdwMzMp55cAdRVIrUHIUIpVLhbjkhB
Kic+lHBHv+CbJs+PY2mfbKtwoVIhIUW24V9US3D3OZd7z+QS01w7Uc3LSm8DdaRs
TyF5BYhW1tjYaxOXGSgPf7SpE0QrQKATYtKCwvmb+/DKQVW09iV2ryaUOV8kyGxo
Gcd69xOmW0Qv2KiogJQmhyqMt4HqJPiJJZrF5UfdQMeOqX0u/IWiwwuoQuuVGUQ5
l+62UXQAcbZdmCQE2JxcG0Nvhb82tQZWzoYb0qnNLhCFgbPn+xcWuhQqJ0tNQ3VR
bBQWhe126xoj/U/EeRB8tDUTNOY9HUeU6EMpOV3mJPBgtRO88dTsRXbtIEXhwCrA
dZkDXnuyig7iok8gimmImtyKYpZ8k+C7M7nd6C+SQ//J+GJ3ibh80Jiqam1jFjD8
ALkT9s1Equ2P0qKlwKWK1psxaG18YxNetHpkLeeqCO/9vR7VTQd2DxzQ4O/Bqfd7
Th3ajWULiF3HEzmsttnBRoW/WBfLaOf7E2UCTI1B9KtQkZVf/bVMaqCDYbxguW9Z
LeeSfaSBWgcl7xkIER3d2mPRaeMjEuQKgzJmZRNX8lx+cRtckqNboxac8hyY3UAm
XLz6Hmjb6/8=
=5jPF
-----END PGP SIGNATURE-----

--Sig_/m6Y1lX/Y0eygHiZSo005uJa--
