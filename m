From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md:Fix name of raid thread when raid takeovered
Date: Mon, 4 Jun 2012 17:10:59 +1000
Message-ID: <20120604171059.229964d7@notabene.brown>
References: <201205311541185787676@gmail.com>
	<20120604134856.00aecfa1@notabene.brown>
	<201206041336070008742@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o6Ws5KYl.ZjoktqsiAxXmEl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206041336070008742@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/o6Ws5KYl.ZjoktqsiAxXmEl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Jun 2012 13:36:11 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On Sun, 3 Jun 2012 20:49:05 -0700,neil wrote:
> >On Thu, 31 May 2012 15:41:22 +0800 "majianpeng" <majianpeng@gmail.com> w=
rote:
> >
> >> When raid takeovered, it used old personality to set task->comm.
> >>=20
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |   15 +++++++++++++++
> >>  1 files changed, 15 insertions(+), 0 deletions(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 1c2f904..93e20ea 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -32,6 +32,7 @@
> >>     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >>  */
> >> =20
> >> +#include <linux/sched.h>
> >>  #include <linux/kthread.h>
> >>  #include <linux/blkdev.h>
> >>  #include <linux/sysctl.h>
> >> @@ -3513,6 +3514,7 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
> >>  	long level;
> >>  	void *priv;
> >>  	struct md_rdev *rdev;
> >> +	char *tmp;
> >> =20
> >>  	if (mddev->pers =3D=3D NULL) {
> >>  		if (len =3D=3D 0)
> >> @@ -3674,6 +3676,19 @@ level_store(struct mddev *mddev, const char *bu=
f, size_t len)
> >>  		del_timer_sync(&mddev->safemode_timer);
> >>  	}
> >>  	pers->run(mddev);
> >> +	/*
> >> +	 * when raid takeover using old personality,so mddev->thread->tsk
> >> +	 * name is wrong.
> >> +	 * if kzalloc error, only using wrong name.
> >> +	 */
> >> +	len =3D strlen(mdname(mddev)) + strlen(mddev->pers->name);
> >> +	tmp =3D kzalloc(len + 2, GFP_KERNEL);
> >> +	if (tmp) {
> >> +		sprintf(tmp, "%s_%s", mdname(mddev), mddev->pers->name);
> >> +		set_task_comm(mddev->thread->tsk, tmp);
> >> +		kfree(tmp);
> >> +	}
> >> +
> >>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> >>  	mddev_resume(mddev);
> >>  	sysfs_notify(&mddev->kobj, NULL, "level");
> >
> >Thanks.  However:
> >
> > 1/ as a task name is limited to TASK_COMM_LEN, there is little point us=
ing
> >    kzalloc.  Just declare a local variable of that size.
> > 2/ No all levels have a thread.  You should check that mddev->thread is=
 not
> >    NULL.
> >
> >If you resubmit with those fixes I'll apply the patch.
> >
> >Thanks,
> >NeilBrown
> >
> >
> Neil, There maybe had anthor issue.
> set_task_comm() is not export.So when compile md is module, it will be er=
ror.
> So I think  it will be rewrite.It should rename in function call md_regis=
ter_thread().
> How about this way?

good point.

If you change all calls to "md_register_thread" that pass NULL as the last
argument to instead pass the name of the personality as the last arg,
then it should get it right.

Thanks,
NeilBrown


--Sig_/o6Ws5KYl.ZjoktqsiAxXmEl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8xfgznsnt1WYoG5AQKlKw/9FNZY8fy40YK7PqMruKV5j7gAo6g917VT
qe6mJwmX759lKTElKYhIK5G925pRg5IWA6BnW0gHwSgE7RhMDxUw+qoTMMFmIo1K
8sYogZZAqiBjjHMdQYFEpMlIvsCMlvnxxkaI73KKkQsNn6EgHqH1oS754l9asKGf
63iXvE6YRUXuV7ixlPr0L6nL5KKh7gYCHXQIm7S/k8xDy5rVehCsRIcBSt5V38gG
4qCTpRuWrm65LAB4w1QVnjR1qcdfiDJUO6a7iGh9q6mrJWm2l2okCmKMdnsuWLrx
0apm2WwpL6mrWiZ7qkVQwDMPYCF5DsepBABbwO95b1p4Q15NHOLEROuEIziAbjtk
8vD6s1eYoNmzUFKe8N/feT5kMaYEe6nGtxJVe2gM+Ep16KhvIonJrlGn9qEpdp9R
KFVItgKXgaHin9I0w1LSCZ6RnwBlohekYF02nu6kuvMQkW1Z2zDRTt/94QsOqPFE
VPBV0Chw2ZMGCUwVi86ekdcXma2isAQrjds5PHrP4BIfdCyfoduS28ZPhv2nn1Kp
3ZEmLZukzEeCeZ37MVyKtVgrK1oHiKxqrYM2Atx9csNb81kqpiD5vaNDFAgvzTYJ
DxXEFgZG/HWvlfYftOBZwPjYujDY+T2NjBkvyU8pkPqDZtoLYz9U1r/IANZ4NcQE
IYCDFpznX6s=
=tXQb
-----END PGP SIGNATURE-----

--Sig_/o6Ws5KYl.ZjoktqsiAxXmEl--
