From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4 of 4] DM RAID:  Add support for MD's RAID10 "far" and
 "offset" algorithms
Date: Mon, 7 Jan 2013 17:05:54 +1100
Message-ID: <20130107170554.3764bb45@notabene.brown>
References: <1355769688.15326.26.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FQe9PtsO.RepK8U9KgzFd6W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355769688.15326.26.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/FQe9PtsO.RepK8U9KgzFd6W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Dec 2012 12:41:28 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:


> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -91,15 +91,44 @@ static struct raid_type {
>  	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTI=
NUE}
>  };
> =20
> +static char *raid10_md_layout_to_format(int layout)
> +{
> +	/*
> +	 * Bit 16 and 17 stand for "offset" and "dev_stride"
> +	 * Refer to MD's raid10.c for details
> +	 */

I don't think "bit 17" is "dev_stride" any more..  "use_far_sets" ??

Thanks,
NeilBrown


--Sig_/FQe9PtsO.RepK8U9KgzFd6W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUOplwjnsnt1WYoG5AQLlLBAAp+PKmNfLQAobn+9N8pAt9NCXlDJpV9sa
AUPPI100h3m7OB3O+AxtsC1BTwGqtZiG8fDc1QeO77aNHM+pJB5GYRe2L8TsubWH
BrMK07vL8KZmU24ipzWFVaBc2s4CVY7oI5ri8hmfQYLtVzDvoe30L0JDj3IbZ3vN
O2mdGWv2SE4RwVvR28mSmZ9yTzlX21W0w6e1cHkUiGYuo4vIuR8Y8KeBtc/juUid
k5DR6JD7pieFfIMI3K6JR8HDo5AmE8SXa36PFcyFbtMGaN5DkHz33DCAgFXo17+q
Rl2uesNB4GAsAb/Zrt9loAhGXEmbuziicMK7h5SNVSFXxCjMhP6FSMwJt7nNvORE
er6Xwfi2rDV7fBowJQZyioH5u1KU5S2WdP8bqdzU6RZ/ZxosqZ+ceUs3o3uGiGrd
CcFKnRo7WDZyKZccC4qlJZk2eH/8hQbJrDnqZ1zuGAuKf54zQfqeYFa7aoHwPP7A
ryqYwobND8L+wqym0lVLmqoXcI/6BM/1W2mU9XV59oZ9aLd2O+Vol87JADVE/wnG
j1Qa3ZnLYPJHH9mc25IXVsCbiIcoM2rSbmQ09HrJNfdGhiZ82mNlI0Lus02E3iwL
hCq1JzPMJEt1rc4xAu3n6xHuk09kVJK9n1i2oNXBipsdxYNbuGatfbutfh6evnAi
AwnHlNK/7KQ=
=1/Kj
-----END PGP SIGNATURE-----

--Sig_/FQe9PtsO.RepK8U9KgzFd6W--
