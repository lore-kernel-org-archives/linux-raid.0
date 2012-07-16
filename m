From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] raidd5:Only move IO_THRESHOLD stripes from
 delay_list to hold_list once.
Date: Mon, 16 Jul 2012 17:46:00 +1000
Message-ID: <20120716174600.25589b7c@notabene.brown>
References: <201207131831085787372@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=g__1VqCON8N366OD12eAMS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207131831085787372@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Paul Menzel <paulepanter@users.sourceforge.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=g__1VqCON8N366OD12eAMS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 18:31:11 +0800 majianpeng <majianpeng@gmail.com> wrote:

> To improve write perfomance by decreasing the preread stripe,only move
> IO_THRESHOLD stripes from delay_list to hold_list once.
>=20
> Using the follow command:
> dd if=3D/dev/zero of=3D/dev/md0 bs=3D2M count=3D52100.
>=20
> At default condition: speed is 95MB/s.
> At the condition of preread_bypass_threshold was equal zero:speed is 105M=
B/s.
> Using this patch:speed is 123MB/s.
>=20
> If preread_bypass_threshold was zero,the performance will be better,but
> not better than this patch.
> I think maybe two reason:
> 1:If bio is REQ_SYNC
> 2:In function __get_priority_stripe():
> >> } else if (!list_empty(&conf->hold_list) &&
> >>		   ((conf->bypass_threshold &&
> >>		     conf->bypass_count > conf->bypass_threshold) ||
> >>		    atomic_read(&conf->pending_full_writes) =3D=3D 0)) {
> Preread_bypass_threshold is one condition of getting stripe from
> hold_list.So only control the number of hold_list can get better
> performance.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..a6749bb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3662,6 +3662,7 @@ finish:
> =20
>  static void raid5_activate_delayed(struct r5conf *conf)
>  {
> +	int count =3D 0;
>  	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
>  		while (!list_empty(&conf->delayed_list)) {
>  			struct list_head *l =3D conf->delayed_list.next;
> @@ -3672,6 +3673,8 @@ static void raid5_activate_delayed(struct r5conf *c=
onf)
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			if (++count >=3D IO_THRESHOLD)
> +				break;
>  		}
>  	}
>  }


I tried this patch - against my current for-next tree - on my own modest
hardware and could not measure any difference in write throughput.

Maybe some other patch has fixed something.

However it is still reading a lot during a write-only test and that is not
ideal.  It would be nice if we could arrange that it didn't read at all.

NeilBRown

--Sig_/=g__1VqCON8N366OD12eAMS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAPGuDnsnt1WYoG5AQJtxQ//R7qiC0iYMhXuwgtT9R8LO7ayN5f/BK0I
tqDju7DqIpXhuMxCRTP9enRVwUhEZiIieVSjZaBvggxXti7TNjHUpkAaalx0hEZ1
Kj+O3c3a8D2rmzHqQh+IM8XpbiyzA4cWBWMg/eWvOu/jayvKoVL7x6xAix8O81Pr
yvDt3KscvN8mx0Bx4+eHpJoo+kvtUUajmq9/eO65ZEXEW9df5dVcqpnNgFz+jFtw
TkvhYcMBuszQxaQQsjzVgExrJQYL7dLkpF+jg06xHzuBAGQcDIeekGRXO+K7iGg4
M2XOt4T2FAQW1t0sN0drAokGyiJvi8PzGrHxxeTBbn2X1sWSCmmgFluzvrKVLWWF
WKLBTMieadYWIP8pAZTCX+9a1EIRIMQQZWj23DvoABufXY36uCBd+QnsVzF58Mma
ArfBuKdxk/b9UbyT4AXWNj7mZQnFFP66FplyOuMWhCFnBkpouOj/exEkZPlKPAMM
9NH/jf/avztvYdyzOqy09PsVwZDDpvH4QuVBlpkabo5QWFYid8LaSIh0jRWnEBJG
x364QbFBOeJccQhdp2eS/nYoq4ddaYm1NcsKpFBcqMfqlIBHZPfpvRdcKDcFQels
yNBAiZDt78Nh+L1HPFP+yA9uF30D5CFytw8GkJ8V/7dkUalVAIHqTBfI6vFH3BDP
sWVqTuD1sfU=
=HApb
-----END PGP SIGNATURE-----

--Sig_/=g__1VqCON8N366OD12eAMS--
