From: Xiao Ni <xni@redhat.com>
Subject: Re: Unable to handle kernel NULL pointer dereference in
 super_written
Date: Wed, 30 Mar 2016 23:30:02 -0400 (EDT)
Message-ID: <1484870851.36155496.1459395002337.JavaMail.zimbra@redhat.com>
References: <678678296.35099303.1459240762496.JavaMail.zimbra@redhat.com> <538658018.35237734.1459254120634.JavaMail.zimbra@redhat.com> <20160329213731.GA2287@kernel.org> <2075551491.35783408.1459323893191.JavaMail.zimbra@redhat.com> <56FC0C77.7000006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56FC0C77.7000006@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Shaohua Li" <shlikernel@gmail.com>
> To: "Xiao Ni" <xni@redhat.com>, "Shaohua Li" <shli@kernel.org>
> Cc: "linux-raid" <linux-raid@vger.kernel.org>, "Jes Sorensen" <Jes.So=
rensen@redhat.com>, "Neil Brown" <neilb@suse.de>
> Sent: Thursday, March 31, 2016 1:27:19 AM
> Subject: Re: Unable to handle kernel NULL pointer dereference in supe=
r_written
>=20
>=20
>=20
> On 03/30/2016 12:44 AM, Xiao Ni wrote:
> >
> > ----- Original Message -----
> >> From: "Shaohua Li" <shli@kernel.org>
> >> To: "Xiao Ni" <xni@redhat.com>
> >> Cc: "linux-raid" <linux-raid@vger.kernel.org>, "Jes Sorensen"
> >> <Jes.Sorensen@redhat.com>, "Neil Brown" <neilb@suse.de>
> >> Sent: Wednesday, March 30, 2016 5:37:31 AM
> >> Subject: Re: Unable to handle kernel NULL pointer dereference in
> >> super_written
> >>
> >> On Tue, Mar 29, 2016 at 08:22:00AM -0400, Xiao Ni wrote:
> >>> Hi all
> >>>
> >>> I encountered one NULL pointer dereference problem.
> >>>
> >>> The environment=EF=BC=9A
> >>> latest linux-stable and mdadm codes
> >>> aarch64 platform
> >>> the md device is created with loop devices
> >>>
> >>> It's a test case to check date integrity. I added the test script=
 as the
> >>> attachment.
> >> Could you please try this patch:
> > Thanks for the patch, I'm running test and will give the result. It=
 need to
> > run
> > more than 300 iterations to reproduce this.

Hi Shaohua

The test have run for more than 1000 times. The patch fixed the bug.

> >
> >>
> >>  From b86d9e1724184c79ad1ea63901aec802492b861c Mon Sep 17 00:00:00=
 2001
> >> Message-Id:
> >> <b86d9e1724184c79ad1ea63901aec802492b861c.1459285706.git.shli@fb.c=
om>
> >> From: Shaohua Li <shli@fb.com>
> >> Date: Tue, 29 Mar 2016 14:00:19 -0700
> >> Subject: [PATCH] MD: add rdev reference for super write
> >>
> >> md_super_write() and corresponding md_super_wait() generally are c=
alled
> >> with reconfig_mutex locked, which prevents disk disappears. There =
is one
> >> case this rule is broken. write_sb_page of bitmap.c doesn't hold t=
he
> >> mutex. next_active_rdev does increase rdev reference, but it decre=
ases
> >> the reference too early (eg, before IO finish). disk can disappear=
 at
> >> the window. We unconditionally increase rdev reference in
> >> md_super_write() to avoid the race.
> > In the path hot_remove_disk, the write_sb_page is protected by
> > reconfig_mutex.
> > It shouldn't submit bio to the leg which is already set FAULTY. Cou=
ld you
> > give
> > an example to show how the buy happen?
>=20
> Not sure if I understand your question correctly, but I try to answer=
=2E
> When a disk is reported faulty with md_error we don't immediately rem=
ove
> the disk as there is risk for example some IO is running in the rdev.=
 We
> increase rdev reference in every IO and decrease the reference after =
IO
> finishes. You can find this in raid5.c for example. We only delete th=
e
> rdev after the reference is 0, please see remove_and_add_spares(). So
> it's possible you will find disk with FAULTY set, but it's still in r=
dev
> list.

I'm sorry that I didn't describe clearly.

I just want to know how the bug happen. At first I just focus my attent=
ion
on the hot_remove_disk. I think it shouldn't write superblock to the de=
vice
which is already removed by md_kick_rdev_from_array.=20

I read the comments from the patch and the codes again. Now I think I u=
nderstand
clearly.

It's because the bitmap_deamon_work->write_page->write_sb_page->md_supe=
r_write
which is called by md_check_recovery. It doesn't protected by reconfig_=
mutex.=20
So there is a chance that the disk is removed (rdev->mddev =3D NULL) wh=
en the
super io is flighting. Is it right?

Regards
Xiao
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
