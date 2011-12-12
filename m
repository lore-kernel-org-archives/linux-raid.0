From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 rebuild not starting
Date: Mon, 12 Dec 2011 17:24:53 +1100
Message-ID: <20111212172453.57bee40c@notabene.brown>
References: <4EE455B2.2040105@iki.fi>
	<20111212140119.35dbf92e@notabene.brown>
	<CAP+ghcLLkAbPVy8LO4Hq6ncNr3=tvGGHB1tJ9Wih=Cjbty+zuw@mail.gmail.com>
	<20111212164240.01e8d1fb@notabene.brown>
	<CAP+ghcLtZQeAR3n4x_8MuGJrEtkOaMWcNKHRin=A+tuDC7aZ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cNGoaqQOPoOF4CDo1woIBbJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP+ghcLtZQeAR3n4x_8MuGJrEtkOaMWcNKHRin=A+tuDC7aZ5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cNGoaqQOPoOF4CDo1woIBbJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 08:02:33 +0200 Anssi Hannula <anssi.hannula@iki.fi> wro=
te:

> On Mon, Dec 12, 2011 at 7:42 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 12 Dec 2011 07:22:17 +0200 Anssi Hannula <anssi.hannula@iki.fi>=
 wrote:
> >
> >> On Mon, Dec 12, 2011 at 5:01 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Sun, 11 Dec 2011 09:03:14 +0200 Anssi Hannula <anssi.hannula@iki.=
fi> wrote:
> >> >
> >> >> Hi!
> >> >>
> >> >> After I rebooted during a raid6 rebuild, the rebuild didn't start a=
gain.
> >> >> Instead, there is a flood of "RAID conf printout"s that seemingly h=
appen
> >> >> on array activity.
> >> >>
> >> >> All the devices show up properly in --detail and two devices are ma=
rked
> >> >> as "spare rebuilding", and I can access the contents of the array j=
ust
> >> >> fine, but the rebuild doesn't actually start. Is this a bug or am I
> >> >> missing something? :)
> >> >>
> >> >> I was initially on 2.6.38.8, but also tried 3.1.4 which seems to ha=
ve
> >> >> the same issue. mdadm is 3.1.5.
> >> >>
> >> >> I'm not using start_ro and writing to the array doesn't trigger a
> >> >> rebuild either.
> >> >>
> >> >> Attached are --examine outputs before assembly, kernel log output on
> >> >> assembly, /proc/mdstat and --detail after assembly (on 3.1.4).
> >> >>
> >> >
> >> > Thank you for the very detailed problem report.
> >>
> >> Thanks for the quick response :)
> >>
> >> > Unfortunately it is a complete mystery to me what is happening.
> >> >
> >> > The repeated "RAID conf printout" messages are almost certainly comi=
ng from
> >> > the end of raid5_remove_disk.
> >> > It is being called from remove_and_add_spares for each of the two de=
vices
> >> > that are being rebuilt. =C2=A0raid5_remove_disk declines to remove t=
hem because it
> >> > can keep rebuilding them.
> >> >
> >> > remove_and_add_spares then counts them and notes there are 2.
> >> > md_check_recovery notes that this is > 0, so it should create a thre=
ad to run
> >> > md_do_sync.
> >> >
> >> > md_do_sync should then print out a message like
> >> > =C2=A0md: recovery of RAID array md0
> >> >
> >> > but it doesn't. =C2=A0So something went wrong.
> >> > There are three reasons that md_do_sync might not print a message:
> >> >
> >> > 1/ MD_RECOVERY_DONE is set. =C2=A0As only md_do_sync ever sets it, t=
hat is
> >> > =C2=A0 =C2=A0unlikely, and in any case md_check_recovery clears it.
> >> > 2/ mddev->ro !=3D 0. =C2=A0It is only ever set to 0, 1, or 2. =C2=A0=
If it is 1 or 2
> >> > =C2=A0 then we would be able to see that in /proc/mdstat as a "(read=
only)"
> >> > =C2=A0 status. =C2=A0But we don't.
> >> > 3/ MD_RECOVERY_INTR is set. Again, md_check_recovery clears this. =
=C2=A0It does
> >> > =C2=A0 get set if kthread_should_stop() returns 'true', but that sho=
uld only
> >> > =C2=A0 happen if kthread_stop() was called. =C2=A0That is only calle=
d by
> >> > =C2=A0 md_unregister_thread and I cannot see any way that could be c=
all.
> >> >
> >> > So. =C2=A0No idea.
> >> >
> >> > Are you compiling these kernels yourself?
> >>
> >> Nope (used Mageia kernels), but I did now (3.1.5).
> >>
> >> > If so, could you:
> >> > =C2=A0- put a printk in the top of md_do_sync to report the values of
> >> > =C2=A0 mddev->recovery and mddev->ro
> >> > =C2=A0- print a message whenever md_unregister_thread is called
> >> > =C2=A0- in md_check_recovery, in the
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev->ro=
) {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* Only thing we do on a ro array is remove
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 * failed devices.
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 */
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mdk_rdev_t *rdev;
> >> >
> >> > =C2=A0in statement, print the value of mddev->ro.
> >> >
> >> > Then see which of those printk's fire, and what they tell us.
> >>
> >> Only the last one does, and mddev->ro =3D=3D 0.
> >>
> >> For reference, attached is the used patch and resulting log output.
> >>
> >
> > Thanks.
> >
> > So it isn't running md_do_sync at all. Odd.
> >
> > Could please add:
> > =C2=A0- call "WARN_ON(1);" in print_raid5_conf() so we get a stack trac=
e and can
> > =C2=A0 =C2=A0see who is calling it.
> > =C2=A0- print the value that remove_and_add_spares is going to return.
>=20
> Attached. As you can see, remove_and_add_spare returns 0.
>=20
> --
> Anssi Hannula


Please add:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5c95ccb..fa56ac5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7328,8 +7328,10 @@ static int remove_and_add_spares(mddev_t *mddev)
 			}
 		}
=20
+	printk("degraded=3D%d\n", mddev->degraded);
 	if (mddev->degraded) {
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
+			printk("raid_disk=3D%d flags=3D%x\n", rdev->raid_disk, rdev->flags);
 			if (rdev->raid_disk >=3D 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
 			    !test_bit(Faulty, &rdev->flags))


'degraded' must be 2 as dmesg contains

[   45.544806] md/raid:md0: raid level 6 active with 8 out of 10 devices, a=
lgorithm 2

and 'degraded' is exactly the difference between '8' and '10' there.

raid disks 3 and 7 must have In_sync and Faulty clear as both of them just
show "spare rebuilding" in the 'detail' output.

so remove_and_add_spares "must" return 2.

Hopefully the above patch will help me understand which of those is wrong.

NeilBrown

--Sig_/cNGoaqQOPoOF4CDo1woIBbJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuWeNTnsnt1WYoG5AQKeeA/+I95reuLWRplKInTxobuEI7DwASDzItvS
iglHlCl1aaPy8a54wxjdRX3KRY3RD/OnfFpcBwwl9c3PxIN/aSqowd/ictm58Apb
dfm/1ktBgpcoKIaRTSv1YObWOeXGU05O88clfUfthAgvW6jUoWNONeMUgwJGBLNJ
7SaNRj9CeHRtYvAeCGdIcAsBLuCqw3J6P+j6dHULSmTRJjd5fPv8h/jPccQ3gzin
YPFHq9BE8ldoR8zeg6dKmbuzzAfViQ6OSMlCMrqiun3QJWR1kaLlxL75LA+rhucY
gAwPOJpi7DS51Wfez1DqlvlQci9bS+wLhus58A1Eqw9HxZ5dw9dzAuM2Iddj60ir
N21X7mUC4kY4D2kiwTsXsgMZBHxBkKAc152XvjUOhE/+ztCOBoRGVDY2YUnTnmeS
4xr+Kp722lL2Ju6wzZQ9UXeMJTXRppiRtLVWQrijv9pblAItl/6pnWOPBn7vwmsv
YUE/F/dvHyq4ZmpKHY8+7ofZpsNqApUOz4PWtB3TrrzLUkDCGUh4c37ViU8kjFjK
oqVps8ogwt1GpkpIaJgB5qKGyRfe1H6xs6EWsE2K8oZU5yc5xj2cdH4pI92nFvoN
nqm/ijj/V8zXyuaMDUVYMeSyPGnS+BjgXDw6iYL7DlnE3Vr5YlwInn57djgSO2bR
Ywi7yfvsWuM=
=DzGx
-----END PGP SIGNATURE-----

--Sig_/cNGoaqQOPoOF4CDo1woIBbJ--
