From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 10/34] md/raid5: unify stripe_head_state and r6_state
Date: Fri, 22 Jul 2011 14:53:52 +0900
Message-ID: <1311314032.1325.4.camel@leonhard>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	 <20110721023225.6728.40355.stgit@notabene.brown> <878vrqex7i.fsf@gmail.com>
	 <20110722151506.54c66e82@notabene.brown>
	 <20110722153746.0f58c356@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110722153746.0f58c356@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-22 (=EA=B8=88), 15:37 +1000, NeilBrown:
> To be specific:
>=20
> 1/ I removed the hunk that you noticed above.
> 2/ I added the following patch.
> 3/ I made the obvious changes to the subsequent patch so that it woul=
d still
>    apply.
>=20
> This is all now in my for-next branch (I haven't added the Reviewed-b=
y's -
> I'll do them all together later.
>=20
> Thanks,
> NeilBrown
>=20
> From 74721b68b4cf8d4845aa9efa3daf99247a611b70 Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Fri, 22 Jul 2011 15:29:38 +1000
> Subject: [PATCH] md/raid5: Remove stripe_head_state arg from handle_s=
tripe_expansion.
>=20
> This arg is only used to differentiate between RAID5 and RAID6 but
> that is not needed.  For RAID5, raid5_compute_sector will set qd_idx
> to "~0" so j with certainly not equals qd_idx, so there is no need
> for a guard on that condition.
>=20
> So remove the guard and remove the arg from the declaration and
> callers of handle_stripe_expansion.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>

Looks good to me, thanks!


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
