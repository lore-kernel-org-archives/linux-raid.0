From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 08/10 v3] raid5: make_request use batch stripe release
Date: Mon, 2 Jul 2012 15:07:12 +1000
Message-ID: <20120702150712.3a870e49@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072702.921605418@kernel.org>
	<20120702123112.795e1db3@notabene.brown>
	<20120702025950.GA29770@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sRrJxs3bhdT+EzIdgxgf3/f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702025950.GA29770@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/sRrJxs3bhdT+EzIdgxgf3/f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jul 2012 10:59:50 +0800 Shaohua Li <shli@kernel.org> wrote:


> > From 04b7dd7d0ad4a21622cad7c10821f914a8d9ccd3 Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Mon, 2 Jul 2012 12:14:49 +1000
> > Subject: [PATCH] md/plug: disable preempt when reported a plug is prese=
nt.
> >=20
> > As 'schedule' will unplug a queue, a plug added by
> > mddev_check_plugged is only valid until the next schedule().
> > So call preempt_disable before installing the plug, and require the
> > called to call preempt_enable once the value has been used.
> >=20
> > Signed-off-by: NeilBrown  <neilb@suse.de>
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 1369c9d..63ea6d6 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -512,6 +512,10 @@ static void plugger_unplug(struct blk_plug_cb *cb)
> > =20
> >  /* Check that an unplug wakeup will come shortly.
> >   * If not, wakeup the md thread immediately
> > + * Note that the structure returned is only value until
> > + * the next schedule(), so preemption is disabled when it
> > + * is not NULL, and must be re-enabled after the value
> > + * has been used.
> >   */
> >  struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
> >  				       md_unplug_func_t unplug, size_t size)
> > @@ -522,6 +526,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev=
 *mddev,
> >  	if (!plug)
> >  		return NULL;
> > =20
> > +	preempt_disable();
> >  	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
> >  		if (mdcb->cb.callback =3D=3D plugger_unplug &&
> >  		    mdcb->mddev =3D=3D mddev) {
> > @@ -533,6 +538,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev=
 *mddev,
> >  			return mdcb;
> >  		}
> >  	}
> > +	preempt_enable();
>=20
> preempt doesn't do unplug, only yield(schedule) does, so I don't like thi=
s,
> just redoing mddev_check_plugged before checking the return value is fine=
 to
> me.

<digs through code...>

Ahh, I see.  preempt calls _schedule(), not schedule(), and schedule() does
the unplug before calling _schedule().
So you are right -  I'll remove that extra patch.
Thanks.



> > -	if (do_sync || !bitmap || !plugged)
> > +	if (do_sync ||
> > +	    !mddev_check_plugged(mddev, NULL, 0))
> >  		md_wakeup_thread(mddev->thread);
>=20
> Do we really bother to recheck here? just a wakeup.
>

This isn't a re-check.  This is the one-and-only check.
In the current code each request gets queued for raid1d and the all get
processed next time the thread wakes up.  So we would prefer to create the
plug and do the wakeup later.  But if creating the plug fails, we do the
wakeup immediately.

Once we are queueing the requests in the plug, this will change.

NeilBrown

--Sig_/sRrJxs3bhdT+EzIdgxgf3/f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/EsgDnsnt1WYoG5AQJHQxAAnVeYY7ZTSF7tO4OoKVqdQ7VJLO4brUWP
A5FRT4ySmyrXf7oQLDcc8tZD8R7ye57uTs9AEE9LZdHRqdFqGXAyiog2niXA9kTS
bZBuK+u4JIMc6WuOcjat+szoHdqSOpDXAPU0uHe7YFxeKnx2j7Xx0bdhpQpexvhr
imRMB4jbuGGWLXhBWo9YNjXpV/YJ9+5VIkn0q2seAheVpCgfveKGP7mvEVQwMIud
LBojgzD5QOdwMUJtbGcfx9954pSpn5GLTmFqxGcf7fAFknOOUvuzb6zsN9QN5z4H
3qqScmDxloO7pC6jwtn92X3Vf/3Agr4+X4zvKv6fIPOIDZL9sv3+Iscy0ZVj/oHp
sp4yzvQgebhGXyGmi1LofUfNY80We89rZiLcmcWiED3sWxSt/eLeF9ErdXToIbUb
Zfv4KWvK/UCiJUoSO4Elbo+xAiCMu7elANW2KDK2ky+JeS0gSb/v8wXbJLIDeNaR
0BDha+qZTNobZdfGafttn/ujsOdNvZtit6NmzagRCbFwT2kNahHWcYh4QoSj0LEa
WOqMHbq63xdsKaCCtlUKYG9FvGzkAg8qwGsjE9w0nwUQND9H87+GoSYPoVLY/fdr
1SvteAIEMbAZjkpGKAZqBkiQ14m6aMTDE2lgpgccWoqOsDo9ZAFPuq9ntov6SgoI
y1E/La8v5b8=
=SoS8
-----END PGP SIGNATURE-----

--Sig_/sRrJxs3bhdT+EzIdgxgf3/f--
