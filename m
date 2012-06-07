From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 7/8] raid5: raid5d handle stripe in batch way
Date: Thu, 7 Jun 2012 17:38:56 +1000
Message-ID: <20120607173856.0f1ae6d2@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080344.262680737@kernel.org>
	<20120607113239.6a64b64d@notabene.brown>
	<20120607063547.GC779@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s3v0Q_+99z3r//hYGwKStzB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607063547.GC779@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/s3v0Q_+99z3r//hYGwKStzB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 14:35:47 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Jun 07, 2012 at 11:32:39AM +1000, NeilBrown wrote:
> > On Mon, 04 Jun 2012 16:01:59 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > Let raid5d handle stripe in batch way to reduce conf->device_lock loc=
king.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> >=20
> > I like this.
> > I don't think it justifies a separate function.
> >=20
> > #define MAX_STRIPE_BATCH 8
> > struct stripe_head *batch[MAX_STRIPE_BATCH]
> > int batch_size =3D 0;
> >=20
> > ...
> >=20
> > while (batch_size < MAX_STRPE_BATCH &&
> >        (sh =3D __get_priority_stripe(conf)) !=3D NULL)
> >      batch[batch_size++] =3D sh;
> >=20
> > spin_unlock(&conf->device_lock);
> > if (batch_size =3D=3D 0)
> >      break;
> >=20
> > handled +=3D batch_size;
> >=20
> > for (i =3D 0; i < batch_size; i++)
> >      handle_stripe(batch[i]);
> > cond_resched();
> > if (....) md_check_recovery(mddev);
> >=20
> > spin_lock_irq(&conf->lock);
> > for (i =3D 0; i < batch_size; i++)
> >      __release_stripe(batch[i]);
> >=20
> >=20
> > something like that?
>=20
> the 8th patch does the same thing, so I moved the code to a separate func=
tion.

The 8th patch should instead move all of the above into a separate function,
then call it both from raid5d and raid5auxd.
Maybe keep the md_check_recovery bit separate, in raid5d it would look like
  if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
      spin_unlock();
      make_check_recovert();
      spin_lock();
  }

Having the=20
   fill the batch
   handle the batch
   release the batch
all open coded in the one place significantly aids readability.

NeilBrown


--Sig_/s3v0Q_+99z3r//hYGwKStzB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9BakDnsnt1WYoG5AQLnuA//QO3NCNiq6cfse176F/SAcl4cWCHRTbOe
UE5hDvRuhcbV9nUFg+xMeMEOu5gcLf3Da4hJaSCNcZa82SlHEY5ZApm6f4u/lX2f
J+4r22HhuemMCdtSMaamzvzwQKidfd3pMc2uMC+TSY33XCCeWSqqNqurvfY7KIyQ
v4S/NWj7nppgihJ1DFQm9o23DWoDQfPrthQySmH3u5SayulapJzSvyR8gNPh6H+e
ZV1uHBYTpzeU78y6u1yDMz9u8lmf/qhCItSn9MVFDwVIFip0l8I5YLtoFKFrhiBF
cCrYZ81t9cFoBq0iufD2STyHhTVPKxCNHJgecNQ4ys7y5A0bVicUSaz+hiJnnVkQ
IydlfLuUR6/oErFaKvbAkwIsAs/jkomxM9Qper9Uf9SwYM+dgEuM5roZdUBkcXgj
g3zDVLPzgTf1iDQ006gMdnS/1Jx5Kte6IVxk+ulV/a7u18CSUfXRmBFpoLYZjuKd
5xH2V7DoS5mDT+Yq9p4+V2+1U/Q2WMRegEJXcp3Jjy09xGFb6SUG5DXQWiY0ozns
b4EMky4mr+Zk/iF0Dtk1F7Vt8ozkO5UnEtt470HH0dYczxqxRHJkdcIR15p+QITM
howmQFRkvYj8xhFuH2msvasXXkrE20U2ZFrE573LiIZPIfhXRds0Qrg/KwsKxOC7
hTLbOyQIeoo=
=mbD9
-----END PGP SIGNATURE-----

--Sig_/s3v0Q_+99z3r//hYGwKStzB--
