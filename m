From: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Sun, 5 Sep 2010 23:23:35 +0400
Message-ID: <20100905192335.GA8140@albatros>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <20100905190139.GA3163@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100905190139.GA3163@merkur.ravnborg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 05, 2010 at 21:01 +0200, Sam Ravnborg wrote:
> On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
> > From: Vasiliy Kulikov <segooon@gmail.com>
> >=20
> > rcu_dereference() is macro, so it might use its argument twice.
> > Argument must not has side effects.
> >=20
> > It was found by compiler warning:
> > drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
> > drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=80=
=99 may be undefined
>=20
> This change looks wrong.
> In the original implementation new_disk is incremented and
> then we do the array lookup.
> With your implementation it looks like we increment it after
> the array lookup.

No, the original code increments new_disk and then dereferences mirrors=
=2E

The full code:

		for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
		     !rdev || !test_bit(In_sync, &rdev->flags)
			     || test_bit(WriteMostly, &rdev->flags);
		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {

			if (rdev && test_bit(In_sync, &rdev->flags) &&
				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
				wonly_disk =3D new_disk;

			if (new_disk =3D=3D conf->raid_disks - 1) {
				new_disk =3D wonly_disk;
				break;
			}
		}

    so,

    for (a; b; c =3D f(++g)) {
       ...
    }=20

    =3D=3D

    a;
    while (b) {
       ...
       l_continue:
       c =3D f(++g);
    }

    =3D=3D

    a;
    while (b) {
       ...
       l_continue:
       g++;
       c =3D f(g);
    }

    =3D=3D

    for (a; b; c =3D f(g)) {
       ...
       g++;
    }=20

Or you mean smth more?

--=20
Vasiliy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
