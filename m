From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 rebuild not starting
Date: Mon, 12 Dec 2011 18:10:36 +1100
Message-ID: <20111212181036.52860cc3@notabene.brown>
References: <4EE455B2.2040105@iki.fi>
	<20111212140119.35dbf92e@notabene.brown>
	<CAP+ghcLLkAbPVy8LO4Hq6ncNr3=tvGGHB1tJ9Wih=Cjbty+zuw@mail.gmail.com>
	<20111212164240.01e8d1fb@notabene.brown>
	<CAP+ghcLtZQeAR3n4x_8MuGJrEtkOaMWcNKHRin=A+tuDC7aZ5Q@mail.gmail.com>
	<20111212172453.57bee40c@notabene.brown>
	<CAP+ghcKYdEnBmUB5kiOzbMvU6_t3+DuV06xBdPZau8MuiDDV4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dw=Qxi/GHZ93ftDm4LPtgUu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP+ghcKYdEnBmUB5kiOzbMvU6_t3+DuV06xBdPZau8MuiDDV4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Dw=Qxi/GHZ93ftDm4LPtgUu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 08:42:49 +0200 Anssi Hannula <anssi.hannula@iki.fi> wro=
te:

> On Mon, Dec 12, 2011 at 8:24 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 12 Dec 2011 08:02:33 +0200 Anssi Hannula <anssi.hannula@iki.fi>=
 wrote:
> >
> >> On Mon, Dec 12, 2011 at 7:42 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Mon, 12 Dec 2011 07:22:17 +0200 Anssi Hannula <anssi.hannula@iki.=
fi> wrote:
> >> >
> >> >> On Mon, Dec 12, 2011 at 5:01 AM, NeilBrown <neilb@suse.de> wrote:
> >> >> > On Sun, 11 Dec 2011 09:03:14 +0200 Anssi Hannula <anssi.hannula@i=
ki.fi> wrote:
> >> >> >
> >> >> >> Hi!
> >> >> >>
> >> >> >> After I rebooted during a raid6 rebuild, the rebuild didn't star=
t again.
> >> >> >> Instead, there is a flood of "RAID conf printout"s that seemingl=
y happen
> >> >> >> on array activity.
> >> >> >>
> >> >> >> All the devices show up properly in --detail and two devices are=
 marked
> >> >> >> as "spare rebuilding", and I can access the contents of the arra=
y just
> >> >> >> fine, but the rebuild doesn't actually start. Is this a bug or a=
m I
> >> >> >> missing something? :)
> >> >> >>
> >> >> >> I was initially on 2.6.38.8, but also tried 3.1.4 which seems to=
 have
> >> >> >> the same issue. mdadm is 3.1.5.
> >> >> >>
> >> >> >> I'm not using start_ro and writing to the array doesn't trigger a
> >> >> >> rebuild either.
> >> >> >>
> >> >> >> Attached are --examine outputs before assembly, kernel log outpu=
t on
> >> >> >> assembly, /proc/mdstat and --detail after assembly (on 3.1.4).
> >> >> >>
> >> >> >
> >> >> > Thank you for the very detailed problem report.
> >> >>
> >> >> Thanks for the quick response :)
> >> >>
> >> >> > Unfortunately it is a complete mystery to me what is happening.
> >> >> >
> >> >> > The repeated "RAID conf printout" messages are almost certainly c=
oming from
> >> >> > the end of raid5_remove_disk.
> >> >> > It is being called from remove_and_add_spares for each of the two=
 devices
> >> >> > that are being rebuilt. =C2=A0raid5_remove_disk declines to remov=
e them because it
> >> >> > can keep rebuilding them.
> >> >> >
> >> >> > remove_and_add_spares then counts them and notes there are 2.
> >> >> > md_check_recovery notes that this is > 0, so it should create a t=
hread to run
> >> >> > md_do_sync.
> >> >> >
> >> >> > md_do_sync should then print out a message like
> >> >> > =C2=A0md: recovery of RAID array md0
> >> >> >
> >> >> > but it doesn't. =C2=A0So something went wrong.
> >> >> > There are three reasons that md_do_sync might not print a message:
> >> >> >
> >> >> > 1/ MD_RECOVERY_DONE is set. =C2=A0As only md_do_sync ever sets it=
, that is
> >> >> > =C2=A0 =C2=A0unlikely, and in any case md_check_recovery clears i=
t.
> >> >> > 2/ mddev->ro !=3D 0. =C2=A0It is only ever set to 0, 1, or 2. =C2=
=A0If it is 1 or 2
> >> >> > =C2=A0 then we would be able to see that in /proc/mdstat as a "(r=
eadonly)"
> >> >> > =C2=A0 status. =C2=A0But we don't.
> >> >> > 3/ MD_RECOVERY_INTR is set. Again, md_check_recovery clears this.=
 =C2=A0It does
> >> >> > =C2=A0 get set if kthread_should_stop() returns 'true', but that =
should only
> >> >> > =C2=A0 happen if kthread_stop() was called. =C2=A0That is only ca=
lled by
> >> >> > =C2=A0 md_unregister_thread and I cannot see any way that could b=
e call.
> >> >> >
> >> >> > So. =C2=A0No idea.
> >> >> >
> >> >> > Are you compiling these kernels yourself?
> >> >>
> >> >> Nope (used Mageia kernels), but I did now (3.1.5).
> >> >>
> >> >> > If so, could you:
> >> >> > =C2=A0- put a printk in the top of md_do_sync to report the value=
s of
> >> >> > =C2=A0 mddev->recovery and mddev->ro
> >> >> > =C2=A0- print a message whenever md_unregister_thread is called
> >> >> > =C2=A0- in md_check_recovery, in the
> >> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev-=
>ro) {
> >> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/* Only thing we do on a ro array is remove
> >> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 * failed devices.
> >> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 */
> >> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0mdk_rdev_t *rdev;
> >> >> >
> >> >> > =C2=A0in statement, print the value of mddev->ro.
> >> >> >
> >> >> > Then see which of those printk's fire, and what they tell us.
> >> >>
> >> >> Only the last one does, and mddev->ro =3D=3D 0.
> >> >>
> >> >> For reference, attached is the used patch and resulting log output.
> >> >>
> >> >
> >> > Thanks.
> >> >
> >> > So it isn't running md_do_sync at all. Odd.
> >> >
> >> > Could please add:
> >> > =C2=A0- call "WARN_ON(1);" in print_raid5_conf() so we get a stack t=
race and can
> >> > =C2=A0 =C2=A0see who is calling it.
> >> > =C2=A0- print the value that remove_and_add_spares is going to retur=
n.
> >>
> >> Attached. As you can see, remove_and_add_spare returns 0.
> >>
> >> --
> >> Anssi Hannula
> >
> >
> > Please add:
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 5c95ccb..fa56ac5 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7328,8 +7328,10 @@ static int remove_and_add_spares(mddev_t *mddev)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > + =C2=A0 =C2=A0 =C2=A0 printk("degraded=3D%d\n", mddev->degraded);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev->degraded) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_en=
try(rdev, &mddev->disks, same_set) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk("raid_disk=3D%d flags=3D%x\n", rdev->raid_disk, rdev->flags);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (rdev->raid_disk >=3D 0 &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(In_sync, &rdev->flags) &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(Faulty, &rdev->flags))
> >
> >
> > 'degraded' must be 2 as dmesg contains
> >
> > [ =C2=A0 45.544806] md/raid:md0: raid level 6 active with 8 out of 10 d=
evices, algorithm 2
> >
> > and 'degraded' is exactly the difference between '8' and '10' there.
> >
> > raid disks 3 and 7 must have In_sync and Faulty clear as both of them j=
ust
> > show "spare rebuilding" in the 'detail' output.
> >
> > so remove_and_add_spares "must" return 2.
> >
> > Hopefully the above patch will help me understand which of those is wro=
ng.
>=20
> The output is:
> [   47.389379] md0: degraded=3D2
> [   47.389380] md0: raid_disk=3D0 flags=3D4
> [   47.389381] md0: raid_disk=3D-1 flags=3D0
>=20
> Full assemble log attached.
>=20
> --
> Anssi Hannula

Bingo.

This will fix it.   We don't really need that 'break' there, and it is a
problem.

Thanks.

NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5c95ccb..440d964 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7344,8 +7344,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 					spares++;
 					md_new_event(mddev);
 					set_bit(MD_CHANGE_DEVS, &mddev->flags);
-				} else
-					break;
+				}
 			}
 		}
 	}

--Sig_/Dw=Qxi/GHZ93ftDm4LPtgUu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuWo7Dnsnt1WYoG5AQJEjA/9Ge3G1RkQKA2I6FLJ52z6yOWTHfVU+vpU
HNvGKrf9TXzSaV1M8Z97EbbQQjR0uJ2ckdrt8zBb8NsN9HPnbw4vuvb5+Kzqw1y2
FlH4NW6deaOti3hOsHsSYI6U5yyItgN2VTMAbdOloKGVeBAooiao1HYo4AP14HRz
V55VtI6mj0zyo+dq98c57QUWvTZBpwYWnLdDELn8yAnicimV2d67GCx93CTLBf6F
V7iovaTJTxPSTEtqD0U77awYniaNVVappOQydFBDHs3pDcP5isiKAV63rTYDMSgJ
HKFzH+hVEYYHR8XuSFk8Hwl5lLejurgxTwUSouIgxZvEMR4YNvMZkvCERv39Kl1e
kL/KpWMwh9dN1W59XrZxduCsxk3uca3IRPrDlCgyGnSirJXLOgcmf7EqhHUZA9d6
705pdNy2hznB/6KMcTqJJPp3tRDsIpgZcRjqJrEllHUfpAGJXCCJRud0w7va+K1b
WZTm+t1cP7p9sj3faKcueN98uoXy3EFqEzYMTynCfJsTZHwF/YY1wRT1zJOwf6Qx
gtwx/MBV1ajRwI/O5CssPbARIoNMx07Ky8Ej5p5bff+EFPDmnlsmyge678ry+fQU
ZH1kQtQ5j5yxK2bEhgoorBUJIr8cZ6KklDYQJkWytk8hgea6snpSGLo43RVYmmcZ
ZkwE3agBocc=
=YSOf
-----END PGP SIGNATURE-----

--Sig_/Dw=Qxi/GHZ93ftDm4LPtgUu--
