From: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Tue, 7 Sep 2010 23:21:55 +0400
Message-ID: <20100907192154.GA14214@albatros>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <201009062210.56824.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201009062210.56824.arnd@arndb.de>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 06, 2010 at 22:10 +0200, Arnd Bergmann wrote:
> On Sunday 05 September 2010 20:32:18 Kulikov Vasiliy wrote:
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
> I think the rcu_dereference macro should really not evaluate its argu=
ment
> twice, and I don't see where it does.
> As a general rule, we try to write macros in Linux such that they beh=
ave
> like functions and don't have surprising side-effects.
>=20
> Which kernel and gcc version do you see the warning with?
>=20
> 	Arnd

gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5), linux-next.

#define __rcu_dereference_check(p, c, space) \
	({ \
		typeof(*p) *_________p1 =3D (typeof(*p)*__force )ACCESS_ONCE(p); \
                                                                   ^
		rcu_lockdep_assert(c); \
		(void) (((typeof (*p) space *)p) =3D=3D p); \
                                      ^     ^
		smp_read_barrier_depends(); \
		((typeof(*p) __force __kernel *)(_________p1)); \
	})

If I understand this, it is evaluated three times, right?


--=20
Vasiliy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
