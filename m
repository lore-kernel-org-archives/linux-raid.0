From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Tue, 20 Dec 2011 16:18:20 +1100
Message-ID: <20111220161820.0830ef18@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
	<20111215171850.335da016@notabene.brown>
	<CABE8wwtKvNamQM3VfYFHwGQ0BhV2xBtYgqV1=Rmjc=6J3Bqogw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mnWoUo8VxmKuwf7FQ6Dpckz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwtKvNamQM3VfYFHwGQ0BhV2xBtYgqV1=Rmjc=6J3Bqogw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mnWoUo8VxmKuwf7FQ6Dpckz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 23:14:04 -0800 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Wed, Dec 14, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> >> f248f8c md: create externally visible flags for supporting hot-replace.
> >>
> >> 'replaceable' just strikes me as a confusing name as all devices are
> >> nominally "replaceable", but whether you want it to be actively
> >> replaced is a different consideration. =C2=A0What about "incumbent" to=
 mark
> >> the disk as currently holding a position we want it to vacate and
> >> remove any potential confusion with 'replacement'.
> >
> > Fair point. =C2=A0I had wondered if I should not have the flag and just=
 use the
> > "write_error" flag. =C2=A0However the meaning is slightly different.
> >
> > I don't really like "incumbent" as it gives no indication that there is=
 a
> > desire to replace the device. =C2=A0Maybe "want_replacement" ??
>=20
> Yeah that works.  I was hung up on the previous scheme only differing
> the in "able" vs "ment" suffix, so a "want_" prefix fits the bill.

I've changed it all to "want_replacements" and agree that is it clearer.

>=20
> >> 37aebb5 md/raid5: preferentially read from replacement device if possi=
ble.
> [..]
> >> Should this one liner be broken out for -stable?
> >> Do you see a particular problem that this fixes that is already possib=
le
> > without hot-replace?
>=20
> I would need to think it through a bit further, but the changelog was
> sufficiently convincing so I thought I would ask.

I'm pretty sure it isn't really needed before replacements is added but
thanks for checking.

>=20
> >> Nit, not sure if it's worth fixing but this one introduces some
> >> inconsistent line wrapping around logical operators... "at the end" vs
> >> "beginning of next line"
> >>
> [..]
> >
> > Thanks.
> > I almost always prefer 'at the start' as import things should be obviou=
s.
> > So I have updated 'want_replace'.
>=20
> ...and here I've been an 'at the end' Sneetch and convinced myself
> that it's easier to read...
>=20
> >>
> >> 2693b9e md/raid5: handle activation of replacement device when
> >> recovery completes.
> >>
> >> I questioned not needing a barrier in raid5_end_write_request after
> >> finding conf->disks[i].replacement =3D=3D NULL until I found the note =
in
> >> raid5_end_read_request about the rdev being pinned until all i/o
> >> returns. =C2=A0Maybe a similar note to raid5_end_write_request?
> >
> > I like adding explanatory notes ... but I'm not quite sure what you are
> > suggesting here. =C2=A0Could you be a little more explicit? =C2=A0Thank=
s.
> >
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 59f5b05..8074515 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1758,7 +1758,8 @@ static void raid5_end_write_request(struct bio
> *bi, int error)
>                                 replacement =3D 1;
>                         else
>                                 /* rdev was removed and 'replacement'
> -                                * replaced it.
> +                                * replaced it.  rdev is not removed
> +                                * until all requests are finished.
>                                  */
>                                 rdev =3D conf->disks[i].rdev;
>                         break;
>=20

I've added that - thanks.


Thanks,
NeilBrown

--Sig_/mnWoUo8VxmKuwf7FQ6Dpckz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvAanDnsnt1WYoG5AQIAQhAAuCG6hsTJcMQ9rfSXI5xjs2CpKcS4d7h3
ISpBGxKR8nRlNPoZO/Xsv0X/DMj8ZxeANRU/iRHGLQeGJ6JwbJMgRFzcmmXYg2Hm
fGeT+s0bMN9yjX+HZGsYA5IFqpDxu4dv8jkULeRyVmyn/6tt4tsmNXYoiT2ZYrSb
UJhHNL/EJAX6A2i8SyZkRPS0D+5EI6IEQ3mkrRViwaEWZrJcw/JSQ+Hb3JGbCfR7
ba7GiwKYHUSbj2EqjWWhw3O8IGluY+sjkIAaKODS7qG/6wAwiDz8vAYIExXJa/Wj
wYjcAV8zQSOlJz8dGHXmg7PeK58B4YbA0xkS5srcToP0AEyeeUpj4kPnsUpnz98V
Hg4SLyifnMy41mm4gHHYZMwTzacE695Y+7EYcr67FBROfL3BsHhRTyHIFK2ZdYv0
n4D5WpR3erMPafjcMT+YElBPUVUPleH5IKcrWKpgJK+mqcAi07eINiYaUCSSR5Q3
wK3TdWObDqLXwW+86rNa0jgOC8s8eaZF87Zz00IyrAHqF9wngstwY0HvkJv42SmA
7XchyZKhhGMLY25Q5p/EG6fPGUBZSV46NR8BQf4wEEQW/ubmpwQih/WBy7BfU1zm
EBBikTeYszpt5JLtQ8xFxB/OSgioEARiIgP3OGejk98ahMfe2ryvj7Jk7r5sX5yP
eYAcWo9hocM=
=qQxK
-----END PGP SIGNATURE-----

--Sig_/mnWoUo8VxmKuwf7FQ6Dpckz--
