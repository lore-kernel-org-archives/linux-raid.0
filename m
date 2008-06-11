From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 losing initial synchronization on restart when one disk is
 spare
Date: Thu, 12 Jun 2008 09:45:09 +1000
Message-ID: <18512.25477.431367.952164@notabene.brown>
References: <48466AD9.5@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hubert Verstraete on Wednesday June 4
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Verstraete <hubskml@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 4, hubskml@free.fr wrote:
> Hello
>=20
> According to mdadm's man page:
> "When creating a RAID5 array, mdadm will automatically create a degra=
ded
> array with an extra spare drive. This is because building the spare
> into a degraded array is in general faster than resyncing the parity =
on
> a non-degraded, but not clean, array. This feature can be over-ridden
> with the --force option."
>=20
> Unfortunately, I'm seeing a kind of bug when I create a RAID5 array w=
ith=20
> an internal bitmap, then stop the array before the initial=20
> synchronization is done and restart the array.
>=20
> 1=B0 When I create the array with an internal bitmap:
> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -b internal -R /dev/sd?
> I see the last disk as a spare disk. After the restart of the array, =
all=20
> disks are seen active and the array is not continuing the aborted=20
> synchronization!
> Note that I did not use the --assume-clean option.
>=20
> 2=B0 When I create the array without a bitmap:
> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -R /dev/sd?
> I see the last disk as a spare disk. After the restart of the array, =
the=20
> spare disk is still a spare disk and the array continues the=20
> synchronization where it had stopped.
>=20
> In the case 1=B0, is this a bug or did I miss something?

Thanks for the detailed report.  Yes, this is a bug.

The following patch fixes it, though I'm not 100% sure this is the
right fix (it may cause too much resync in some cases, which is better
than not enough, but not ideal).

> Secondly, what could be the consequences of this non-performed=20
> synchronization ?

If you lose a drive, the data might get corrupted.

When writing to the array, the new parity block will sometimes be
calculated assuming that it was previously correct.  If all updates to
a particular parity block are of this sort, then it will still be
incorrect when you lose a drive, and data recovered based on that
parity block will be incorrect.

Until you lose a drive, it will have no visible effect.

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-10 10:27:51.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-12 09:34:25.000000000 +1000
@@ -4094,7 +4094,9 @@ static int run(mddev_t *mddev)
 				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
 			working_disks++;
-		}
+		} else
+			/* Cannot rely on bitmap to complete recovery */
+			conf->fullsync =3D 1;
 	}
=20
 	/*
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
