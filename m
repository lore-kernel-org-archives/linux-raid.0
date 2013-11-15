From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid1: Rewrite the implementation of iobarrier.
Date: Fri, 15 Nov 2013 14:42:11 +1100
Message-ID: <20131115144211.5ac78deb@notabene.brown>
References: <201308281940511854138@gmail.com>
	<20131024125059.1a440152@notabene.brown>
	<201310290930116677124@gmail.com>
	<20131031133314.522f30ad@notabene.brown>
	<201310311114307462606@gmail.com>
	<20131114174438.7f2db666@notabene.brown>
	<201311151029513246491@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vtx9GI+QHb69A.nDpc/szt2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201311151029513246491@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Vtx9GI+QHb69A.nDpc/szt2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Nov 2013 10:29:56 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >> Yes.How about those code:
> >> spin_lock_irq(&conf->resync_lock);
> >> retry_check:
> >>         if (need_to_wait_for_sync(conf, bio)) {
> >>                 conf->nr_waiting++;
> >>                 /* Wait for the barrier to drop.
> >>                  * However if there are already pending
> >>                  * requests (preventing the barrier from
> >>                  * rising completely), and the
> >>                  * pre-process bio queue isn't empty,
> >>                  * then don't wait, as we need to empty
> >>                  * that queue to get the nr_pending
> >>                  * count down.
> >>                  */
> >>                 wait_event_lock_irq(conf->wait_barrier,
> >>                                     !conf->array_frozen &&
> >>                                     (!conf->barrier ||
> >>                                     (conf->nr_pending &&
> >>                                      current->bio_list &&
> >>                                      !bio_list_empty(current->bio_list=
))),
> >>                                     conf->resync_lock);
> >>                 conf->nr_waiting--;
> >> 				goto retry_check;
> >> >
> >
> >It would look a lot better if you made it a while loop:
> >
> > while (need_to_wait....) {
> >     nr_waiting++
> >     wait_event.....
> >     nr_waiting--
> > if (bio_data_dir.....
> >
> For this, i think it don;t need while() or recheck.
> The code should:
>=20
> if (nedd_to_wait...) {
> 	nr_waiting++
> 	wait_event.....
> 	nr_waiting--
> }
> if (bio && bio_data_dir(bio) =3D=3D WRITE) {
> 	 do;
> }
>=20
> I think again need_to_wait...(),it must return false. So we don't recheck=
 this.
> Or am I missing something?
>=20

An 'if' is fine.  I just didn't like the goto.
If you can send me the updated patch in a day or 2 I should be able to get =
it
into the current merge window.

thanks,
NeilBrown

--Sig_/Vtx9GI+QHb69A.nDpc/szt2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoWYFDnsnt1WYoG5AQKEqg/+KupX7swf4evdDlQ/YPP3Eg4MT0dGanZ6
kSxqIZ2ZVF65fS822DzLfKgDz/8w0yfXLTu1HYHPW31kfV8d1NHkIHul/ILCWAQc
YIi/9zmBjZdvO3P8510Y6wTKGx2b8Fl5EOgG3no74CNkD5q1SM5PsDjlS5mEx2Cx
Ev6/cb1k08WD0ZoSiDjlqOUPSq11xF0RV2W+pBwsnnXQKVy7yRFq9ArHtpH8X3lF
qX7QWpDTo4oRpAsOUAoSVvIMySKo5XFSyo58IqMpTqJSj6r21I3vLK2yz2m8+6lo
QMCRzHMvMkSa+VeVq0m8CIYHp6sAl5JtWw5who/zz9qiLN/6B/2TNjYwWc0EJsF/
rBBCmY6ikckHp3GyJT4+3Dg/YILX5XePi90qvw5idBPwZOOwNHIMrPzMYLAnDr6m
UIEMvuLO3pFvWPNKui7dwiKe7nqxtrTp1uNflg7ap/ufN5cZ5vv4lUs6Mfe/HTAy
CjWMu+KXLjF7y5iybcTi3RheIcKCvBhg6L5GqrbvG3OcwMY7ki82A6u5TJON5Pkb
EeQGBB7/Q0zLECB4q5cAuR0yi7cJ/VRc9cS6ldwStj/OpyhimVah5Rt9MDdWjiDS
GsUa5fdeVo8PGQ2yzzeYWmaoda8LJCmZ3Axg5mkJZ5sg4hWaWKUK0E1ZeSI9uhje
ShcgLKsG5KU=
=qzdX
-----END PGP SIGNATURE-----

--Sig_/Vtx9GI+QHb69A.nDpc/szt2--
