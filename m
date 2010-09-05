From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Sun, 5 Sep 2010 22:39:08 +0200
Message-ID: <20100905203908.GA3228@merkur.ravnborg.org>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <20100905190139.GA3163@merkur.ravnborg.org> <20100905192335.GA8140@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100905192335.GA8140@albatros>
Sender: linux-kernel-owner@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 05, 2010 at 11:23:35PM +0400, Kulikov Vasiliy wrote:
> On Sun, Sep 05, 2010 at 21:01 +0200, Sam Ravnborg wrote:
> > On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
> > > From: Vasiliy Kulikov <segooon@gmail.com>
> > >=20
> > > rcu_dereference() is macro, so it might use its argument twice.
> > > Argument must not has side effects.
> > >=20
> > > It was found by compiler warning:
> > > drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
> > > drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=
=80=99 may be undefined
> >=20
> > This change looks wrong.
> > In the original implementation new_disk is incremented and
> > then we do the array lookup.
> > With your implementation it looks like we increment it after
> > the array lookup.
>=20
> No, the original code increments new_disk and then dereferences mirro=
rs.
>=20
> The full code:
>=20
> 		for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
> 		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
> 		     !rdev || !test_bit(In_sync, &rdev->flags)
> 			     || test_bit(WriteMostly, &rdev->flags);
> 		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {
>=20
> 			if (rdev && test_bit(In_sync, &rdev->flags) &&
> 				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
> 				wonly_disk =3D new_disk;
>=20
> 			if (new_disk =3D=3D conf->raid_disks - 1) {
> 				new_disk =3D wonly_disk;
> 				break;
> 			}
> 		}
>=20
>     so,
>=20
>     for (a; b; c =3D f(++g)) {
>        ...
>     }=20

Thanks - that explains it.
This code really screams for a helper function but thats another matter=
=2E

	Sam
