From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 01:53:44 +0200
Message-ID: <201107290153.45227.xavier@alternatif.org>
References: <4E25C9BA.1060401@dodtsair.com> <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com> <4E31AAEE.30601@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E31AAEE.30601@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: brian.foster@emc.com, mpower@dodtsair.com, rm@romanrm.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le jeudi 28 juillet 2011 20:31:10 Doug Ledford, vous avez =E9crit :
> On 07/20/2011 08:59 AM, brian.foster@emc.com wrote:
> >> -----Original Message-----
> >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> >> owner@vger.kernel.org] On Behalf Of Mike Power
> >> Sent: Tuesday, July 19, 2011 3:14 PM
> >> To: Roman Mamedov
> >> Cc: linux-raid@vger.kernel.org
> >> Subject: Re: RAID 1 using SSD and 2 HDD
> >>=20
> >> Thanks for the link.  That is the kind of thing I am looking for.
> >>=20
> >> On 07/19/2011 11:32 AM, Roman Mamedov wrote:
> >>> On Tue, 19 Jul 2011 11:15:22 -0700
> >>>=20
> >>> Mike Power<mpower@dodtsair.com>   wrote:
> >>>> Is it possible to implement a RAID 1 array using two equal size =
HDD
> >>>> and one smaller and faster SSD.  The idea being that the resulti=
ng
> >>>> RAID would have the same size of the HDD while picking up the sp=
eed
> >>>> benefits of the SSD.
> >>>=20
> >>> See http://bcache.evilpiepirate.org/
> >=20
> > Also, Roberto referred to the facebook flashcache implementation. I=
t is
> > based on device-mapper and last I tried bcache, probably a bit more
> > production-worthy at the moment (though bcache looks intriguing lon=
g
> > term, so I'd suggest to try both and draw your own conclusion):
> >=20
> > https://github.com/facebook/flashcache
>=20
> Having not looked at those two, I can say that an md raid1 with two h=
ard
> drives and one SSD works *very* well.  It's blazing fast.  Here's how=
 I
> set mine up:
>=20
> SSD: three partitions, one for boot, one for /, and one for ~/repos
> (which is where all my git/cvs/etc. checkouts reside)
> hard disks: four partitions, one for boot, one for /, one for /home, =
one
> for ~/repos
>=20
> Then I created four raid1 arrays like so:
>=20
> mdadm -C /dev/md/boot -l1 -n3 -e1.0 --bitmap=3Dinternal --name=3Dboot
> /dev/sda1 --write-mostly --write-behind=3D128 /dev/sdb1 /dev/sdc1
> mdadm -C /dev/md/root -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3Droot
> /dev/sda2 --write-mostly --write-behind=3D1024 /dev/sdb2 /dev/sdc2
> mdadm -C /dev/md/home -l1 -n2 -e1.2 --bitmap=3Dinternal --name=3Dhome
> /dev/sdb3 /dev/sdc3
> mdadm -C /dev/md/repos -l1 -n3 -e1.2 --bitmap=3Dinternal --name=3Drep=
os
> /dev/sda4 --write-mostly --write-behind=3D1024 /dev/sdb4 /dev/sdc4
>=20
> Works for me with stellar performance.  Treats the SSD as the only
> device that matters on the three arrays it participates in with the h=
ard
> drives there merely as a backing store for safety in case the SSD blo=
ws
> chunks some day.  Obviously, if you need some other aspect of your ho=
me
> directory to have the SSD benefit then modify to your tastes, but all=
 my
> scratch builds happen under ~/repos and the thing flies when compilin=
g
> stuff compared to how it used to be.


One thing you didn't said is the respective size of the SSD and HD part=
itions.=20
How did you determine them?

Xavier
xavier@alternatif.org
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
