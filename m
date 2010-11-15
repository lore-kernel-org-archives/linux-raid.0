From: Neil Brown <neilb@suse.de>
Subject: Re: md raid1 rebuild bug? (2.6.32.25)
Date: Mon, 15 Nov 2010 12:33:42 +1100
Message-ID: <20101115123342.4432308c@notabene.brown>
References: <AANLkTikbbcXH7Q1KqcOsS0n05TWYpgBev-wR9NVBdKxa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikbbcXH7Q1KqcOsS0n05TWYpgBev-wR9NVBdKxa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian =?ISO-8859-1?B?RuRyYmVy?= <faerber@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 9 Nov 2010 13:41:11 +0100
Sebastian F=E4rber <faerber@gmail.com> wrote:

> Hi,
>=20
> i just stumbled across a problem while rebuilding a MD RAID1 on 2.6.3=
2.25.
> The server has 2 disks, /dev/hda and /dev/sda. The RAID1 is degraded,=
 so sda
> was replaced and i tried rebuilding from /dev/hda to /dev/sdb.
> While rebuilding i noticed that /dev/hda has some problems/bad sector=
s
> but the kernel
> seems to be stuck in some endless loop:
>=20
> --
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D2391471=
98,
> sector=3D239147057
> hda: possibly failed opcode: 0xc8
> end_request: I/O error, dev hda, sector 239147057
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D2391481=
74,
> sector=3D239148081
> hda: possibly failed opcode: 0xc8
> end_request: I/O error, dev hda, sector 239148081
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D2391472=
13,
> sector=3D239147209
> hda: possibly failed opcode: 0xc8
> end_request: I/O error, dev hda, sector 239147209
> raid1: hda: unrecoverable I/O read error for block 237892224
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D2391481=
74,
> sector=3D239148169
> hda: possibly failed opcode: 0xc8
> end_request: I/O error, dev hda, sector 239148169
> raid1: hda: unrecoverable I/O read error for block 237893120
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D2391482=
25,
> sector=3D239148225
> hda: possibly failed opcode: 0xc8
> end_request: I/O error, dev hda, sector 239148225
> raid1: hda: unrecoverable I/O read error for block 237893248
> md: md1: recovery done.
> RAID1 conf printout:
>  --- wd:1 rd:2
>  disk 0, wo:0, o:1, dev:hda6
>  disk 1, wo:1, o:1, dev:sda6
> RAID1 conf printout:
>  --- wd:1 rd:2
>  disk 0, wo:0, o:1, dev:hda6
>  disk 1, wo:1, o:1, dev:sda6
> RAID1 conf printout:
>  --- wd:1 rd:2
>  disk 0, wo:0, o:1, dev:hda6
>  disk 1, wo:1, o:1, dev:sda6
> --
>=20
> I get a new "conf printout" message every few seconds until i used
> mdadm to set /dev/sda6 to
> "faulty". I know /dev/hda is bad and i probably won't be able to
> rebuild the raid device, but this
> endless loop seems fishy?

=46ishy indeed!!

This was supposed to have been fixed by commit
     4044ba58dd15cb01797c4fd034f39ef4a75f7cc3
in 2.6.29.  But it seems not.

The following patch should fix it properly.
Are you able to apply this patch to your kernel, rebuild, and see if it=
 makes
the required difference?
Thanks.

I'm working on making md cope with this situation better and actually f=
inish
the recovery - recording where the bad blocks are so when you read from=
 the
new device, you can still get read errors, but when you over-write, the=
 error
goes away.  But there are so many other things to do....

=46or now, your best bet might be to use dd-rescue (or is that ddrescue=
) to
copy from hda6 to sda6, then stop using hda6.

NeilBrown


=46rom c074e12fe437827908bc31247a05aec4815e1a1b Mon Sep 17 00:00:00 200=
1
=46rom: NeilBrown <neilb@suse.de>
Date: Mon, 15 Nov 2010 12:32:47 +1100
Subject: [PATCH] md/raid1: really fix recovery looping when single good=
 device fails.
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Commit 4044ba58dd15cb01797c4fd034f39ef4a75f7cc3 supposedly fixed a
problem where if a raid1 with just one good device gets a read-error
during recovery, the recovery would abort and immediately restart in
an infinite loop.

However it depended on raid1_remove_disk removing the spare device
from the array.  But that does not happen in this case.
So add a test so that in the 'recovery_disabled', then device will be
removed.

Reported-by: Sebastian F=E4rber <faerber@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 45f8324..845cf95 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1161,6 +1161,7 @@ static int raid1_remove_disk(mddev_t *mddev, int =
number)
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !mddev->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err =3D -EBUSY;
 			goto abort;

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
