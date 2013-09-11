From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Thu, 12 Sep 2013 08:59:33 +1000
Message-ID: <20130912085933.54b5021b@notabene.brown>
References: <52090E6D.10104@profitbricks.com>
	<20130813143115.55dd27d1@notabene.brown>
	<5209E37D.6050107@profitbricks.com>
	<20130814104410.10bb2259@notabene.brown>
	<520B3B39.4060703@profitbricks.com>
	<522EFDD1.3000708@profitbricks.com>
	<20130911095459.086d532d@notabene.brown>
	<52301E58.7010000@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QCS/Ii4tlZjLl=o/OT=Bm02"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52301E58.7010000@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, linux-raid@vger.kernel.org, Sebastian Riemer <sebastian.riemer@profitbricks.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QCS/Ii4tlZjLl=o/OT=Bm02
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 09:40:08 +0200 Jack Wang <xjtuwjp@gmail.com> wrote:

> On 09/11/2013 01:54 AM, NeilBrown wrote:
> > On Tue, 10 Sep 2013 13:09:05 +0200 Jack Wang <jinpu.wang@profitbricks.c=
om>
> > wrote:
> >=20
> >> snip
> >>
> >> Hi Neil,
> >>
> >> I notice you send out pull request for md update, which include fix for
> >> this bug.
> >>
> >> I think we'd better include the fix to stable tree at least from 3.4
> >> above, what do you think?
> >=20
> > I don't think it is a situation that is at all like to occur in normal =
usage,
> > so it doesn't seem justified for -stable.
> >=20
> > Do you disagree?  Did you ever experience the deadlock in normal usage =
or
> > only in artificial situations?
>=20
> Yes, we do see this BUG in our production environment, so I think it's
> good to include it in stable tree.
>=20

I was hoping you would explain how....

Maybe I'm misunderstanding, but as I see it the deadlock can only occur if
you run "mdadm --stop" while some other process has the block device open
and is writing to it.  That seems like a dumb thing to do and my suggest
would be to not do it.
Is there a good reason why you try to stop the array while it is being
written to.
Would it make sense for the process to open the block device with O_EXCL.
This would encourage exclusive access, and would also prevent the deadlock
from happening.

NeilBrown

--Sig_/QCS/Ii4tlZjLl=o/OT=Bm02
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjD12jnsnt1WYoG5AQIEDhAAmkdUVnVCdR01gNrTx1Pm1nRwEKha162s
DhAepwaokXSYtY5BTx5qxn3w83LMy0V09CJVeS1lrk+gi1yUo3lnwvvkHzF4pQ1o
8SL60Otry/RTuJMN39px5lAr3njVa1k6sxSPddsqrcM/cP47QdbFaR2QqyI3n8Mk
u8q9oKoVjNDfSjPww2Be7PVI9fZmTuY1mKopMgQiPFyJB0hM7h02htMyk9T3vkGO
rmo6iMsbKau74JnOoAOSp/0lYDHpDmmv963s1ehZV6c4ARpdufKEFazUJYO6K6S7
C+ANaaZM+xRkVhoV0WOfb/fDPeAmiyRp6ziIlW8S/dbFXkliUoyQa8bsJiiIuJJr
dcqwCq2DN/RKpIJyo/eaaOTCfAB+HKpHsIveNHrn5UTfPjgts4BPltRdNFMfRliy
H8SZrRnX4M6wStp8yIY/uXIdzyC0x/k/Rax0SvUMI9j+DjOzfKOFAkvRX+5NgZLc
eQT+CxmKwbXOs+txn47uvRzglLEvzUfvx3uA0lMzMxR0C/iMniKUr1awJlGGsw0u
Ge5k8VNKEaDZnIwDxDfgIduIaI+Mrc+zvrUkFH51eAsIyzw6VLVPwL5hWu47b7JK
jZl0SEG1Rhqts3AnmY2Ym8OcRnhs3yQAO4VSSCVv5frp8PJT5f4goMwgXM95mkJe
dNRnUY/AeP4=
=jtWi
-----END PGP SIGNATURE-----

--Sig_/QCS/Ii4tlZjLl=o/OT=Bm02--
