From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Tue, 12 Jun 2012 14:10:09 -0700
Message-ID: <CAA9_cmdPyczf+ecOMVJs7+Mi3UPznc2QszAwFwHnjV8coFcFaw@mail.gmail.com>
References: <20120604080152.098975870@kernel.org>
	<20120604080300.519377228@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080300.519377228@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jun 4, 2012 at 1:01 AM, Shaohua Li <shli@kernel.org> wrote:
> Add a per-stripe lock to protect stripe specific data, like dev->read=
,
> written, ... The purpose is to reduce lock contention of conf->device=
_lock.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
> =A0drivers/md/raid5.c | =A0 17 +++++++++++++++++
> =A0drivers/md/raid5.h | =A0 =A01 +
> =A02 files changed, 18 insertions(+)
>
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c =A0 =A0 =A0 2012-06-01 13:38:54.705=
210229 +0800
> +++ linux/drivers/md/raid5.c =A0 =A02012-06-01 13:43:05.594056130 +08=
00
> @@ -749,6 +749,7 @@ static void ops_complete_biofill(void *s
>
> =A0 =A0 =A0 =A0/* clear completed biofills */
> =A0 =A0 =A0 =A0spin_lock_irq(&conf->device_lock);
> + =A0 =A0 =A0 spin_lock_irq(&sh->stripe_lock);
> =A0 =A0 =A0 =A0for (i =3D sh->disks; i--; ) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct r5dev *dev =3D &sh->dev[i];
>
> @@ -774,6 +775,7 @@ static void ops_complete_biofill(void *s
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 spin_unlock_irq(&sh->stripe_lock);
> =A0 =A0 =A0 =A0spin_unlock_irq(&conf->device_lock);

Btw... I know this is fixed up in a later patch with the deletion of
device_lock, but bisection may land on this patch which enables irqs a
bit too early.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
