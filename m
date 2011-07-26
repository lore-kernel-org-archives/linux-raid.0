From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 10/34] md/raid5: unify stripe_head_state and r6_state
Date: Tue, 26 Jul 2011 15:44:00 +0900
Message-ID: <1311662640.1522.6.camel@leonhard>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	 <20110721023225.6728.40355.stgit@notabene.brown> <878vrqex7i.fsf@gmail.com>
	 <20110722151506.54c66e82@notabene.brown>
	 <20110722153746.0f58c356@notabene.brown> <1311314032.1325.4.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1311314032.1325.4.camel@leonhard>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-22 (=EA=B8=88), 14:54 +0900, Namhyung Kim:
> 2011-07-22 (=EA=B8=88), 15:37 +1000, NeilBrown:
> From 74721b68b4cf8d4845aa9efa3daf99247a611b70 Mon Sep 17 00:00:00 200=
1
> > From: NeilBrown <neilb@suse.de>
> > Date: Fri, 22 Jul 2011 15:29:38 +1000
> > Subject: [PATCH] md/raid5: Remove stripe_head_state arg from handle=
_stripe_expansion.
> >=20
> > This arg is only used to differentiate between RAID5 and RAID6 but
> > that is not needed.  For RAID5, raid5_compute_sector will set qd_id=
x
> > to "~0" so j with certainly not equals qd_idx, so there is no need
> > for a guard on that condition.
> >=20
> > So remove the guard and remove the arg from the declaration and
> > callers of handle_stripe_expansion.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> Looks good to me, thanks!
>=20

And please feel free to add this in case you need it :)

Reviewed-by: Namhyung Kim <namhyung@gmail.com>



--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
