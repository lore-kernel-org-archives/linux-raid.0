From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Wed, 27 Jun 2012 19:40:52 +0300
Message-ID: <CAGRgLy5U_Xzr=LDuQ6R7dEzx4EiNyWQb1fiSQhq_F+oTmyZw1Q@mail.gmail.com>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
	<20120627172255.40ee3a19@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120627172255.40ee3a19@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: andrey.warkentin@gmail.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

>>
>> I would still think that there is value in recoding in a superblock
>> that a drive is recovering.
>
> Probably. =A0It is a bit unfortunate that if you stop an array that i=
s
> recovering after a --re-add, you cannot simply 'assemble' it again an=
d
> get it back to the same state.
> I'll think more on that.

As I mentioned, I see the additional re-add as a minor thing, but
agree it's better to fix it. The fact that we don't know that the
drive is being recovered, bothers me more. Because user might look at
the superblock, and assume the data on the drive is consistent to some
point in time (time of the drive failure). While the actual data,
while doing bitmap-based recovery, is unusable until recovery
successfully completes. So the user might think it's okay to try to
run his app on this drive.
Yes, please think about this.

>
> Meanwhile, this patch might address your other problem. =A0It allows =
--re-add
> to work if a non-bitmap rebuild fails and is then re-added.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c601c4b..d31852e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev, m=
du_disk_info_t *info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super_types[mddev->maj=
or_version].
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0valida=
te_super(mddev, rdev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((info->state & (1<<MD_DISK_SYNC)) =
&&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!test_bit(In_sync, &rdev->flag=
s) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (test_bit(Faulty, &rdev->flags)=
 ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->raid_disk !=3D info->ra=
id_disk)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* This was a hot-add =
request, but events doesn't
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * match, so reject it=
=2E
>

I have tested a slightly different patch that you suggested earlier -
just removing the !test_bit(In_sync, &rdev->flags) check. I confirm
that it solves the problem.

The Faulty bit check seems redundant to me, because:
- it can be set by only by validate_super() and only if that drive's
role is 0xfffe in sb->roles[] array
- Long time ago I asked you, how can it happen that a drive thinks
about *itself* that it is Faulty (has 0xfffe for its role in its own
superblock), and you said this should never happen.

Anyways, I tested also the patch you suggested, and it also works.

Is there any chance to see this fix in ubuntu-precise?

Thanks again for your support,
Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
