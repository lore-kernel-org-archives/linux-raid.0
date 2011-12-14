From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Wed, 14 Dec 2011 14:18:51 -0800
Message-ID: <CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 25, 2011 at 6:43 PM, NeilBrown <neilb@suse.de> wrote:
> The following series - on top of my for-linus branch which should app=
ear in
> 3.2-rc1 eventually - implements hot-replace for RAID4/5/6. =A0This is=
 almost
> certainly the most requested feature over the last few years.
> The whole series can be pulled from my md-devel branch:
> =A0 git://neil.brown.name/md md-devel
> (please don't do a full clone, it is not a very fast link).

Some belated comments based on the commit ids at the time:

88eeb3d md: refine interpretation of "hold_active =3D=3D UNTIL_IOCTL".
9c22832 md: take a reference to mddev during sysfs access.
a7d6ae4 md: remove test for duplicate device when setting slot number.
6deecf2 md: change hot_remove_disk to take an rdev rather than a number=
=2E

last 4 reviewed-by.

f248f8c md: create externally visible flags for supporting hot-replace.

'replaceable' just strikes me as a confusing name as all devices are
nominally "replaceable", but whether you want it to be actively
replaced is a different consideration.  What about "incumbent" to mark
the disk as currently holding a position we want it to vacate and
remove any potential confusion with 'replacement'.

ce8fd05 md/raid5: allow each slot to have an extra replacement device
fd7557d md/raid5: raid5.h cleanup
15e9a58 md/raid5: remove redundant bio initialisations.

last 3 reviewed-by.

37aebb5 md/raid5: preferentially read from replacement device if possib=
le.

+                       /* This flag does not apply to '.replacement'
+                        * only to .rdev, so make sure to check that*/
+                       struct md_rdev *rdev2 =3D rcu_dereference(
+                               conf->disks[i].rdev);
+                       if (rdev2 =3D=3D rdev)
+                               clear_bit(R5_Insync, &dev->flags);
+                       if (!test_bit(Faulty, &rdev2->flags)) {

can't rdev2 be NULL here?

@@ -4201,7 +4241,6 @@ static int  retry_aligned_read(struct r5conf
*conf, struct bio *raid_bio)
                        return handled;
                }

-               set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
                if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
                        release_stripe(sh);
                        raid5_set_bi_hw_segments(raid_bio, scnt);


Should this one liner be broken out for -stable?

8e2c0f9 md/raid5: allow removal for failed replacement devices.
17df00a md/raid5: writes should get directed to replacement as well as =
original.

last 2 reviewed-by

dba5a681 md/raid5:  detect and handle replacements during recovery.

This one got me looking back to recall the rules about when
rcu_deference must be used for an rdev (the ones outlined in commit
9910f16a "md: fix up some rdev rcu locking in raid5/6").  But the
casual future reader may have a hard time finding that commit.  Maybe
we could introduce our own rdev_deref() macro so that sparse and
lockdep can automatically validate rdev derefences like below.

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8d8e139..6023583 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -357,9 +357,14 @@ enum {


 struct disk_info {
-       struct md_rdev  *rdev, *replacement;
+       struct md_rdev __rcu *rdev,
+       struct md_rdev __rcu *replacement;
 };

+#define rdev_deref(p, md, sh) \
+       rcu_dereference_check((p), (md) ? mddev_is_locked(md) : 1 || \
+                                  (sh) ? test_bit(STRIPE_SYNCING,
&(sh)->state) : 1)
+
 struct r5conf {
        struct hlist_head       *stripe_hashtbl;
        struct mddev            *mddev;

=2E..but not sure if it's worth the code uglification.


Nit, not sure if it's worth fixing but this one introduces some
inconsistent line wrapping around logical operators... "at the end" vs
"beginning of next line"

+               if (rdev
+                   && !test_bit(Faulty, &rdev->flags)
+                   && !test_bit(In_sync, &rdev->flags)
+                   && !rdev_set_badblocks(rdev, sh->sector,
+                                          STRIPE_SECTORS, 0))
+                       abort =3D 1;
+               rdev =3D conf->disks[i].replacement;
+               if (rdev
+                   && !test_bit(Faulty, &rdev->flags)
+                   && !test_bit(In_sync, &rdev->flags)
+                   && !rdev_set_badblocks(rdev, sh->sector,
+                                          STRIPE_SECTORS, 0))
                        abort =3D 1;
        }
        if (abort) {
@@ -2456,6 +2475,22 @@ handle_failed_sync(struct r5conf *conf, struct
stripe_head *sh,
        }
 }

+static int want_replace(struct stripe_head *sh, int disk_idx)
+{
+       struct md_rdev *rdev;
+       int rv =3D 0;
+       /* Doing recovery so rcu locking not required */
+       rdev =3D sh->raid_conf->disks[disk_idx].replacement;
+       if (rdev &&
+           !test_bit(Faulty, &rdev->flags) &&
+           !test_bit(In_sync, &rdev->flags) &&
+           (rdev->recovery_offset <=3D sh->sector ||
+            rdev->mddev->recovery_cp <=3D sh->sector))
+               rv =3D 1;
+
+       return rv;

2693b9e md/raid5: handle activation of replacement device when
recovery completes.

I questioned not needing a barrier in raid5_end_write_request after
finding conf->disks[i].replacement =3D=3D NULL until I found the note i=
n
raid5_end_read_request about the rdev being pinned until all i/o
returns.  Maybe a similar note to raid5_end_write_request?

d6db3d0 md/raid5: recognise replacements when assembling array.
6cdb4fb md/raid5: If there is a spare and a replaceable device, start
replacement.
0124565 md/raid5: Mark device replaceable when we see a write error.

last 3 reviewed-by.

058c478..678a66d
raid10 and raid1 patches not reviewed.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
