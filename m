From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Spare drive won't spin down
Date: Mon, 17 May 2010 17:38:04 -0700
Message-ID: <AANLkTiknwELDEgA2LKbhOkNJWlm-wxBozMZ4i0BUFtu2@mail.gmail.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com> <20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com> <20100507194704.3ffcf17e@notabene.brown>
	<4BE83B75.8050709@tmr.com> <20100512065318.44e934d4@notabene.brown>
	<4BF186DE.5050502@redhat.com> <20100518102312.01c85274@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100518102312.01c85274@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Bill Davidsen <davidsen@tmr.com>, Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 17, 2010 at 5:23 PM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 17 May 2010 14:11:42 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>
>> On 05/11/2010 04:53 PM, Neil Brown wrote:
>> > Theoretically, when the spares are one behind the active array and=
 we need to
>> > update them all, we should update the spares first, then the rest.=
 =A0If we
>> > don't and there is a crash at the wrong time, some spares could be=
 2 events
>> > behind the most recent device. =A0However that is a fairly unlikel=
y race to
>> > lose and the cost is only having a spare device fall out of the ar=
ray, which
>> > is quite easy to put back it, that I might not worry to much about=
 it.
>> >
>> > So if you haven't seen a patch to fix this in a week or two, pleas=
e remind me.
>>
>> They're spares. =A0They don't need to have an in-sync generation cou=
nt.
>> Change the semantics so that spares have a 0 generation count and on=
ly
>> when they've been activated does their count get brought into sync w=
ith
>> the rest of the array. =A0The only thing needed to make that work is=
 to
>> not kick them on assembly because their generation count doesn't mat=
ch,
>> but that should be trivial (and sane) to do based on the fact that i=
f
>> they are a spare, they don't contain data, so the generation count
>> really is meaningless.
>>
>
> Yes.
> However current kernels will kick them on assembly and so I cannot ma=
ke
> future kernels leave the event count at zero, else people who try a n=
ew
> kernel then revert to an old might find there spares drop off ... and=
 could
> well not be happy about that.
>
> But I can certainly relax the requirement that the event count on a s=
pare be
> current now. =A0Maybe in a few years I can then stop updating the eve=
nt count
> on spares completely....
>
> NeilBrown
>
> From 589af914c85ebb8205ba315a1e78e76ec7bd9e99 Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Tue, 18 May 2010 10:17:09 +1000
> Subject: [PATCH] md: don't insist on valid event count for spare devi=
ces.
>
> Devices which know that they are spares do not really need to have
> an event count that matches the rest of the array, so there are no
> data-in-sync issues. It is enough that the uuid matches.
> So remove the requirement that the event count is up-to-date.
>
> We currently still write out and event count on spares, but this
> allows us in a year or 3 to stop doing that completely.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ef21d9..26b3d28 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1070,10 +1070,13 @@ static int super_90_validate(mddev_t *mddev, =
mdk_rdev_t *rdev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mddev-=
>bitmap_info.default_offset;
>
> =A0 =A0 =A0 =A0} else if (mddev->pers =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Insist on good event counter while a=
ssembling */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Insist on good event counter while a=
ssembling, except
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for spares (which don't need an ev=
ent count) */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0++ev1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ev1 < mddev->events)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb->disks[rdev->desc_nr].state & (
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1<<MD_DISK_SYN=
C) | (1 << MD_DISK_ACTIVE)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ev1 < mddev->events=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-EINVAL;
> =A0 =A0 =A0 =A0} else if (mddev->bitmap) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if adding to array with a bitmap, t=
hen we can accept an
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * older device ... but not too old.
> @@ -1469,10 +1472,14 @@ static int super_1_validate(mddev_t *mddev, m=
dk_rdev_t *rdev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0} else if (mddev->pers =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Insist of good event counter while a=
ssembling */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Insist of good event counter while a=
ssembling, except for
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* spares (which don't need an event =
count) */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0++ev1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ev1 < mddev->events)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rdev->desc_nr >=3D 0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->desc_nr < le32_to_cpu(sb-=
>max_dev) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(sb->dev_roles[rdev-=
>desc_nr]) < 0xfffe)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ev1 < mddev->events=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-EINVAL;
> =A0 =A0 =A0 =A0} else if (mddev->bitmap) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* If adding to array with a bitmap, t=
hen we can accept an
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * older device, but not too old.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You should make it a sysfs controllable option to keep the counter
updated on spare discs or not.  The default can be to keep it within
one as you currently are patching it to.  Then later you can change
the default to the higher performance setting.  Better, the presence
of that file can be used to test if the kernel supports it, and if it
doesn't initramfs scripts can react accordingly.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
