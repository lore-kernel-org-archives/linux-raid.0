From: NeilBrown <neilb@suse.de>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Thu, 16 May 2013 10:41:39 +1000
Message-ID: <20130516104139.1a904f3f@notabene.brown>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
	<CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
	<20130510072906.6d457c29@notabene.brown>
	<CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jj8SqIi_Pe9yGiC1zdsQpHy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFfJ-R5_Hcu37DNvQQw8tDyvJPktg8YAvgs-L+CyrVBB4ZRBcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dusty Mabe <dustymabe@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Jj8SqIi_Pe9yGiC1zdsQpHy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 May 2013 20:04:27 -0400 Dusty Mabe <dustymabe@gmail.com> wrote:

> On Thu, May 9, 2013 at 5:29 PM, NeilBrown <neilb@suse.de> wrote:
> >
> > It is an unfortunate consequence of incoherent design.
> > I've occasionally wondered if I should "fix" it.
>=20
> Neil,
>=20
> Thanks for the insight. I don't know the code well but I do notice
> that changing the md_seq_show() function to print out the raid_disk
> rather than desc_nr at least gives me the "desired" behavior from
> /proc/mdstat. This still doesn't change the fact that the "Number" is
> still changed in the mdadm --detail output but is a quick easy way to
> change mdstat without actually having to re-architect anything.
>=20
> What do you think?
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aeceedf..b47fd35 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7023,7 +7023,7 @@ static int md_seq_show(struct seq_file *seq, void *=
v)
>                 rdev_for_each(rdev, mddev) {
>                         char b[BDEVNAME_SIZE];
>                         seq_printf(seq, " %s[%d]",
> -                               bdevname(rdev->bdev,b), rdev->desc_nr);
> +                               bdevname(rdev->bdev,b), rdev->raid_disk);
>                         if (test_bit(WriteMostly, &rdev->flags))
>                                 seq_printf(seq, "(W)");
>                         if (test_bit(Faulty, &rdev->flags)) {

The problem with doing this is that it is potentially an API change.
It is unlikely but possible that some script depends on the current meaning
of the number.

Also it would result in spares being reported as e.g.
     sda1[-1]S
as 'raid_disk' for a spare is '-1'.


My leaning is to not worry too much about /proc/mdstat, but instead add a
"--status" option to "mdadm" which prints out a summary similar
to /proc/mdstat, but more coherent and less full of noise.

mdadm --status

md0 : raid1 chunk=3D65536K bitmap_chunk=3D8KB metadata=3D1.2 size=3D9767624=
96K
   Working: 3[U_U] sda[0] sdc[1]
   Spares: sdd
   Failed: sdb

or something like that.

NeilBrown

--Sig_/Jj8SqIi_Pe9yGiC1zdsQpHy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUZQrQznsnt1WYoG5AQIEdBAAkbs7stDlloiSCJrsMQujf5IRwLlaHae+
f49CmFelUaZXp9oR5Rca+u9pTT3UWDs9Moc8qhpYodcPJfvA/27aJQ0t4x0dHbHG
H9vbuhzWZhOzqEQ7ghM7f6puagFdu/Mdisr7Qcb4USIAEw9iDlPaJYUZga1ImUvb
FYULc0rPxhsLzrKnut/eN7rlVG0ggAA1bbez6/quUiXr8p5ct5VnLZMcR0e0eyb4
dRWHP2QAwwEEHb/ShN3+ECjJEhlOiuJr8qY/2MCp+xSWy0AayYw5fJY07noUMQz0
07/R4p5qBG0h+k+9nx5Y9UXlpArCkpwzxCGvN7IPkYwj0m+SftUF7Le+QRi8d3pW
yQubXiFYiXHDhbgpK6lC5fkLgGb5/QRnuOEeaMEUom3prPQWxRp94tvBKbSyXJqr
W5YoeQXQEST4NvwmQbYQ75NmOsqgTI0hTOqnmjGWdHtjtEaGcWEHkpcP43Byk/9L
cy1G5QoQy4s2Vp2GjjWuFvxRDYz6sX5ciTjPCKX8THpmj8Gfie4z5RVb8AV7kGXP
LDS7CjYZPO1PSpYBtjQ5/58OotPVj/j3HTj77XZaE2UC+xs3ABbhq7yXJuZWVxiy
dEAS3NAO/JOJw5x6uNQimrGh3xjECvZz9OpPtQD4FACmxSZoO5uC2LL9fLFu7qr7
QD4osAeA0Z0=
=Ri1i
-----END PGP SIGNATURE-----

--Sig_/Jj8SqIi_Pe9yGiC1zdsQpHy--
