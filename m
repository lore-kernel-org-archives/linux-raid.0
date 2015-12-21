From: NeilBrown <nfbrown@novell.com>
Subject: Re: I/O errors without erros from underlying device
Date: Mon, 21 Dec 2015 13:25:23 +1100
Message-ID: <874mfc5yi4.fsf@notabene.neil.brown.name>
References: <201512071705.27177.a.miskiewicz@gmail.com> <22117.49283.546268.719858@quad.stoffel.home> <201512072146.28378.a.miskiewicz@gmail.com> <201512081205.48777.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201512081205.48777.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: arekm@maven.pl, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 08 2015, Arkadiusz Miskiewicz wrote:

> On Monday 07 of December 2015, Arkadiusz Miskiewicz wrote:
>
>> Anyway I would expect my problem to be related to badblock lists which
>> numbers are close to dmesg error message: [  848.988518] Buffer I/O error
>> on dev md7, logical block 3907148544, async page read
>>=20
>> > >> http://sprunge.us/XSWI
>>=20
>> But how to repair these if write() also fails and
>> http://www.spinics.net/lists/raid/msg49325.html suggests that write shou=
ld
>> "fix" these (by using replacement blocks I guess) ?
>
> Tried to get rid of badblock lists (well, corruption in that area is bett=
er=20
> than no access at all):
>
> mdadm --assemble /dev/md7 --force --update=3Dno-bbl
> mdadm: Cannot remove active bbl from /dev/sdae1
> mdadm: Cannot remove active bbl from /dev/sdag1
> mdadm: Cannot remove active bbl from /dev/sdai1
> mdadm: Cannot remove active bbl from /dev/sdn1
> mdadm: Cannot remove active bbl from /dev/sdg
> mdadm: Cannot remove active bbl from /dev/sdad1
> mdadm: /dev/md7 has been started with 10 drives.
>
> Is there a way to archieve that anyway?
>

You probably have bad blocks in multiple disks in the one stripe
(look in /sys/block/md7/md/dev-*/badblocks or something like that to
see).

To get rid of these you would need to write to every block in the
stripe.  I guess I should try to find a way to make that easier.

If you like you could hack mdadm to allow you to remove the bbl even
though they aren't empty.
In super1.c look for:
	} else if (strcmp(update, "no-bbl") =3D=3D 0) {
		if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BAD_BLOCKS))
			pr_err("Cannot remove active bbl from %s\n",devname);
		else {
			sb->bblog_size =3D 0;
			sb->bblog_shift =3D 0;
			sb->bblog_offset =3D 0;
		}

and change it to be unconditional and also to clear
MD_FEATURE_BAD_BLOCKS.

No warranty expressed or implied.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd2MTAAoJEDnsnt1WYoG5M24QAJTJC3NTkAhj5McI4r7Z7SRk
WGLqUt1OWigxlXooATxfv3jnOvFye6eNlQOzDxvkeUKAA1EcPBPVTrgOcskpkjfk
/B0FPfos3hZTlOAeFpCTt1tTXTvRajSZD/u+HM/foKYgQvSIA2647oKFAFXp+7rv
bVGn5q0SVFkW6yvkedGRVkA3z1wRgjDyzD42OjLWwkiA5tpGbHcWq9DRZl2WbxkY
Hl2/k7h20ApmZWeIwpDui15KjdLbiuVdz6Jhi6AUTpu9N6BHUtyhCBWJ2lqhnowo
WqaKj3TDW/hM16W27sxdZ1Tzbc1gW0EXGzAoAc59IR88gdK4mpNHvjPkjeoE+fTm
//tbQDlAPELh6UtOZVhvPlT3dBtZzjcDk2kDReiAGaqrTocwmoWVCiiu3waHCmbn
hTHE7FnyS6uxitbhgNGVLgJfuaYsfVUUJS5w4Zba3dK8uicoec96DIphEIwY1Bjr
8PE4c6ADJFyPExbnxfVrLQHQuZFWXkmfsZtb/CiU6F3BeX7cP2uVRvvqCIBGNaID
mCfb47d2mMsic0vPsZe6++ZzD0iCfynuAzX3vFWFIKnBpczwABqUFGFtxQOBeoNt
YK+xF8P2hndQiP3mqJ2ZGraarh4y0Y6c1p6RvOeUqmc5dAb1FNE5XjLb1v02QwrM
NgDvh3m9gQ+MzQzVsrBz
=vcBT
-----END PGP SIGNATURE-----
--=-=-=--
