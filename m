From: NeilBrown <neilb@suse.de>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 13:10:17 +1100
Message-ID: <20140225131017.6e71fa5a@notabene.brown>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
	<530AAD64.4030701@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/drE=Bw7Qf1+.vABUqSnnf=o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530AAD64.4030701@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/drE=Bw7Qf1+.vABUqSnnf=o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Feb 2014 10:24:36 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> On 22/02/14 02:09, Mikael Abrahamsson wrote:
> >
> > Hi,
> >
> > we have "check", "repair", "replacement" and other operations on raid
> > volumes.
> >
> > I am not a programmer, but I was wondering how much work it would
> > require to take current code and implement "rewrite", basically
> > re-writing every block in the md raid level. Since "repair" and "check"
> > doesn't seem to properly detect a few errors, wouldn't it make sense to
> > try least existance / easiest implementation route to just re-write all
> > data on the entire array? If reads fail, re-calculate from parity, if
> > reads work, just write again.
>=20
> Now, this is after 3 minutes of looking at raid5.c, so if I've missed=20
> something obvious please feel free to yell at me. I'm not much of a=20
> programmer. Having said that -
>=20
> Can someone check my understanding of this bit of code?
>=20
> static void handle_parity_checks6(struct r5conf *conf, struct=20
> stripe_head *sh,
>                                    struct stripe_head_state *s,
>                                    int disks)
> <....>
>=20
>          switch (sh->check_state) {
>          case check_state_idle:
>                  /* start a new check operation if there are < 2 failures=
 */
>                  if (s->failed =3D=3D s->q_failed) {
>                          /* The only possible failed device holds Q, so it
>                           * makes sense to check P (If anything else=20
> were failed,
>                           * we would have used P to recreate it).
>                           */
>                          sh->check_state =3D check_state_run;
>                  }
>                  if (!s->q_failed && s->failed < 2) {
>                          /* Q is not failed, and we didn't use it to=20
> generate
>                           * anything, so it makes sense to check it
>                           */
>                          if (sh->check_state =3D=3D check_state_run)
>                                  sh->check_state =3D check_state_run_pq;
>                          else
>                                  sh->check_state =3D check_state_run_q;
>                  }
>=20
>
> So we get passed a stripe. If it's not being checked we :
>=20
> - If Q has failed we initiate check_state_run (which checks only P)
>=20
> - If we have less than 2 failed drives (lets say we have none), if we=20
> are already checking P (check_state_run) we upgrade that to=20
> check_state_run_pq (and therefore check both).
>=20
> However
>=20
> - If we were check_state_idle, beacuse we had 0 failed drives, then we=20
> only mark check_state_run_q and therefore skip checking P ??

This code is obviously too subtle.

If 0 drives have failed, then 's->failed' is 0 (it is the count of failed
drives), and  's->q_failed' is also 0 (it is a boolean flag, and q clearly
hasn't failed as nothing has).
So the first 'if' branch will be followed (as "0 =3D=3D 0") and check_state=
 set to
check_state_run.
Then as q_failed is still 0 and failed < 2, check_state gets set to
check_state_run_pq.

So it does check both p and q.

NeilBrown

--Sig_/drE=Bw7Qf1+.vABUqSnnf=o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwv7iTnsnt1WYoG5AQJZdQ//fZvykcUHMXY89so0tPD2ATe/TyNKA3hr
cdAf7CUGkaVIQeigeUNj66K1y/7XugdCFRu0QfS2sqTQKwwJco1MbLi0jopWc8Eb
p8rl2azpIeUdjrcTUj+IMGkcinDhEpvjXZIXHDIgladS9TPBSX1MIusMd3AF+JnR
1S8OI4nkWYRDrKov4q5GjXkRRyFxAN5qfQmLRitBKGcflWGuQ4VdqwuR73WraRTf
404i29aaas5Afsc2ldBrUIrr9uZY972TIP5u3f5YnmM3d2+RV+Lo3v/5sHRZrxG6
1FGj0bEtBN6EjZkPX5CaFAR2UgqGhXNaOPWOusnKCgKunJo1GFzXRQO1h5tAUZoL
Oc0fyCp9QJah3XwPOg0IXYv1Tfb3wGzQNsTMrrD0wRSuCC8fs+Gh4w36WhUCBtZo
W+imv+d6PNOHFdN2ThhWCOcMmbchUZqni6U0V3GLCROyQopMnUgJ7BNtdNo8ayFJ
Yp8Pos9d7MQupig19sgX2ku2/v2UBMYziYeE56sN3R6+aGbrWNCkej1MYYKtCVvd
A6A6SrxQxs2r2w8s1BDpke1ovvBpN3s9BDU+IUAtpbM2ptG/PqglrZf2PxgJmf1L
JBJf9Q2gEU/gyG+Q2Xi/1c2fF7jgl9knfqPRyBcbsJhDIACbwcHaeJlwWyV79HYj
ZDVkQJZq23Y=
=Xc4T
-----END PGP SIGNATURE-----

--Sig_/drE=Bw7Qf1+.vABUqSnnf=o--
