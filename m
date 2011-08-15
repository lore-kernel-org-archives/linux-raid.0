From: NeilBrown <neilb@suse.de>
Subject: Re: Rotating RAID 1
Date: Tue, 16 Aug 2011 09:55:17 +1000
Message-ID: <20110816095517.757afc07@notabene.brown>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
	<4E497FB5.3030109@ivitera.com>
	<CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
	<4E49849E.4030604@ivitera.com>
	<20110816084251.2d8e7831@notabene.brown>
	<CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: Pavel Hofman <pavel.hofman@ivitera.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 15 Aug 2011 19:32:04 -0400 J=E9r=F4me Poulin <jeromepoulin@gmai=
l.com>
wrote:

> On Mon, Aug 15, 2011 at 6:42 PM, NeilBrown <neilb@suse.de> wrote:
> > So if there are 3 drives A, X, Y where A is permanent and X and Y a=
re rotated
> > off-site, then I create two RAID1s like this:
> >
> >
> > mdadm -C /dev/md0 -l1 -n2 --bitmap=3Dinternal /dev/A /dev/X
> > mdadm -C /dev/md1 -l1 -n2 --bitmap=3Dinternal /dev/md0 /dev/Y
>=20
> That seems nice for 2 disks, but adding another one later would be a
> mess. Is there any way to play with slots number manually to make it
> appear as an always degraded RAID ? I can't plug all the disks at onc=
e
> because of the maximum of 2 ports.

Yes, add another one later would be difficult.  But if you know up-fron=
t that
you will want three off-site devices it is easy.

You could

 mdadm -C /dev/md0 -l1 -n2 -b internal /dev/A missing
 mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 missing
 mdadm -C /dev/md2 -l1 -n2 -b internal /dev/md1 missing
 mdadm -C /dev/md3 -l1 -n2 -b internal /dev/md2 missing

 mkfs /dev/md3 ; mount ..

 So you now have 4 "missing" devices.  Each time you plug in a device t=
hat
 hasn't been in an array before, explicitly add it to the array that yo=
u want
 it to be a part of and let it recover.
 When you plug in a device that was previously plugged in, just "mdadm
 -I /dev/XX" and it will automatically be added and recover based on th=
e
 bitmap.

 You can have as many or as few of the transient drives plugged in at a=
ny
 time as you like.

 There is a cost here of course.  Every write potentially needs to upda=
te
 every bitmap, so the more bitmaps, the more overhead in updating them.=
  So
 don't create more than you need.

 Also, it doesn't have to be a linear stack.  It could be a binary tree
 though that might take a little more care to construct.  Then when an
 adjacent pair of leafs are both off-site, their bitmap would not need
 updating.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
