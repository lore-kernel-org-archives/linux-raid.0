From: Coly Li <i@coly.li>
Subject: Re: [RESEND PATCH 2/3] bcache: update document info
Date: Wed, 29 Jun 2016 18:16:04 +0800
Message-ID: <b66c1795-3201-e571-75da-979893338d85@coly.li>
References: <1466561534-17595-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1466561534-17595-1-git-send-email-wangyijing@huawei.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

=D4=DA 16/6/22 =C9=CF=CE=E710:12, Yijing Wang =D0=B4=B5=C0:
> There is no return in continue_at(), update the documentation.
>=20

There are 2 modification of this patch. The first one is about a typo,
it is correct.

But I doubt your second modification is proper. The line removed in you=
r
patch is,
> - * continue_at() also, critically, is a macro that returns the
calling function.
> - * There's good reason for this.
> - *

I think this is exactly what original author wants to say. It does not
mean return a value, it means return to the calling function. And the
bellowed lines explains the reason.

> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/md/bcache/closure.c |    2 +-
>  drivers/md/bcache/closure.h |    3 ---
>  2 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.=
c
> index 9eaf1d6..864e673 100644
> --- a/drivers/md/bcache/closure.c
> +++ b/drivers/md/bcache/closure.c
> @@ -112,7 +112,7 @@ bool closure_wait(struct closure_waitlist *waitli=
st, struct closure *cl)
>  EXPORT_SYMBOL(closure_wait);
> =20
>  /**
> - * closure_sync - sleep until a closure a closure has nothing left t=
o wait on
> + * closure_sync - sleep until a closure has nothing left to wait on

Yes, this modification is good.

>   *
>   * Sleeps until the refcount hits 1 - the thread that's running the =
closure owns
>   * the last refcount.
> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.=
h
> index 782cc2c..f51188d 100644
> --- a/drivers/md/bcache/closure.h
> +++ b/drivers/md/bcache/closure.h
> @@ -31,9 +31,6 @@
>   * passing it, as you might expect, the function to run when nothing=
 is pending
>   * and the workqueue to run that function out of.
>   *
> - * continue_at() also, critically, is a macro that returns the calli=
ng function.
> - * There's good reason for this.
> - *
>   * To use safely closures asynchronously, they must always have a re=
fcount while
>   * they are running owned by the thread that is running them. Otherw=
ise, suppose
>   * you submit some bios and wish to have a function run when they al=
l complete:
>=20


--=20
Coly Li
