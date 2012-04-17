From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: support sync request
Date: Tue, 17 Apr 2012 15:59:45 +0800
Message-ID: <CANejiEXhcxhR16oL8uknY+XZdAqaf-Av-cJaETxm-Lp=jUon=g@mail.gmail.com>
References: <4F8CFB12.306@kernel.org>
	<20120417164635.733b1776@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417164635.733b1776@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2012/4/17 NeilBrown <neilb@suse.de>:
> On Tue, 17 Apr 2012 13:09:38 +0800 Shaohua Li <shli@kernel.org> wrote=
:
>
>>
>> REQ_SYNC is ignored in current raid5 code. Block layer does use it t=
o do
>> policy,
>> for example ioscheduler. This patch adds it.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>> =A0 drivers/md/raid5.c | =A0 12 ++++++++++--
>> =A0 drivers/md/raid5.h | =A0 =A01 +
>> =A0 2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> Index: linux/drivers/md/raid5.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux.orig/drivers/md/raid5.c =A0 =A0 2012-04-17 11:59:24.556008=
869 +0800
>> +++ linux/drivers/md/raid5.c =A02012-04-17 12:06:06.306007114 +0800
>> @@ -518,6 +518,8 @@ static void ops_run_io(struct stripe_hea
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 replace_only =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_and_clear_bit(R5_SyncIO, &sh->dev=
[i].flags))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rw |=3D REQ_SYNC;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bi =3D &sh->dev[i].req;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rbi =3D &sh->dev[i].rreq; /* For writing=
 to replacement */
>> @@ -1114,6 +1116,8 @@ ops_run_biodrain(struct stripe_head *sh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev->sec=
tor + STRIPE_SECTORS) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wbi-=
>bi_rw & REQ_FUA)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 set_bit(R5_WantFUA, &dev->flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wbi->b=
i_rw & REQ_SYNC)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 set_bit(R5_SyncIO, &dev->flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D a=
sync_copy_data(1, wbi, dev->page,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 dev->sector, tx);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wbi =3D =
r5_next_bio(wbi, dev->sector);
>> @@ -1131,13 +1135,15 @@ static void ops_complete_reconstruct(voi
>> =A0 =A0 =A0 int pd_idx =3D sh->pd_idx;
>> =A0 =A0 =A0 int qd_idx =3D sh->qd_idx;
>> =A0 =A0 =A0 int i;
>> - =A0 =A0 bool fua =3D false;
>> + =A0 =A0 bool fua =3D false, sync =3D false;
>>
>> =A0 =A0 =A0 pr_debug("%s: stripe %llu\n", __func__,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)sh->sector);
>>
>> - =A0 =A0 for (i =3D disks; i--; )
>> + =A0 =A0 for (i =3D disks; i--; ) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fua |=3D test_bit(R5_WantFUA, &sh->dev[i=
].flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sync |=3D test_bit(R5_SyncIO, &sh->dev[i].=
flags);
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 for (i =3D disks; i--; ) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct r5dev *dev =3D &sh->dev[i];
>> @@ -1146,6 +1152,8 @@ static void ops_complete_reconstruct(voi
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(R5_UPTODATE, &de=
v->flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fua)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(=
R5_WantFUA, &dev->flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sync)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(R5=
_SyncIO, &dev->flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> Index: linux/drivers/md/raid5.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux.orig/drivers/md/raid5.h =A0 =A0 2012-04-17 11:59:26.866008=
859 +0800
>> +++ linux/drivers/md/raid5.h =A02012-04-17 12:00:29.196008586 +0800
>> @@ -285,6 +285,7 @@ enum r5dev_flags {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 R5_Wantdrain, =A0 /* dev->towrite needs to be drained */
>> =A0 =A0 =A0 R5_WantFUA, =A0 =A0 /* Write should be FUA */
>> + =A0 =A0 R5_SyncIO, =A0 =A0 =A0/* The IO is sync */
>> =A0 =A0 =A0 R5_WriteError, =A0/* got a write error - need to record =
it */
>> =A0 =A0 =A0 R5_MadeGood, =A0 =A0/* A bad block has been fixed by wri=
ting to it */
>> =A0 =A0 =A0 R5_ReadRepl, =A0 =A0/* Will/did read from replacement ra=
ther than orig */
>
> Thanks.
> There was some interesting white-space damage in this patch, but I so=
rted it
> out and applied it.
Thanks and sorry, will double check my email client.

> However I'm not convinced that it is correct. =A0It is probably bette=
r than
> nothing so I'll allow it for now, but you might want to fix it up to =
make it
> better.
>
> The point of REQ_SYNC is to remove any delays in handling the write, =
and get
> it to disk as soon as possible.
> However with RAID5, the write isn't complete until all the blocks in =
the
> stripe have been written, so just setting REQ_SYNC on the write for o=
ne of
> the blocks may not achieve the goal.
> You at least need to use REQ_SYNC on the parity block, and you probab=
ly want
> it on all the blocks in the stripe.
>
> So rather than setting R5_SyncIO on the dev, you should be setting in=
 on the
> whole stripe_head.
>
> Similarly WantFUA should affect all device writes in the strip as the=
y all
> need to hit the media for any of the data to be considered 'safe'.
>
> If you would like to fix both of those issues at once, that would be =
great :-)
In current code, all written disks and parity disks will have FUA/SYNC
set, please see ops_complete_reconstruct.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
