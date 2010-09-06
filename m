From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Mon, 6 Sep 2010 22:10:55 +0200
Message-ID: <201009062210.56824.arnd@arndb.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1283711539-7123-1-git-send-email-segooon@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 05 September 2010 20:32:18 Kulikov Vasiliy wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
>=20
> rcu_dereference() is macro, so it might use its argument twice.
> Argument must not has side effects.
>=20
> It was found by compiler warning:
> drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
> drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=80=
=99 may be undefined

I think the rcu_dereference macro should really not evaluate its argume=
nt
twice, and I don't see where it does.
As a general rule, we try to write macros in Linux such that they behav=
e
like functions and don't have surprising side-effects.

Which kernel and gcc version do you see the warning with?

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
