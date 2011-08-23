From: NeilBrown <neilb@suse.de>
Subject: Re: Rotating RAID 1
Date: Tue, 23 Aug 2011 13:58:12 +1000
Message-ID: <20110823135812.62c56cee@notabene.brown>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
	<4E497FB5.3030109@ivitera.com>
	<CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
	<4E49849E.4030604@ivitera.com>
	<20110816084251.2d8e7831@notabene.brown>
	<CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
	<20110816095517.757afc07@notabene.brown>
	<CALJXSJqYXmvfoperm10XCLnGNA4WgMt_y7UoUSgPv3xjqScNcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJqYXmvfoperm10XCLnGNA4WgMt_y7UoUSgPv3xjqScNcg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 22 Aug 2011 23:45:53 -0400 J=E9r=F4me Poulin <jeromepoulin@gmai=
l.com>
wrote:

> On Mon, Aug 15, 2011 at 7:55 PM, NeilBrown <neilb@suse.de> wrote:
> > Yes, add another one later would be difficult. =A0But if you know u=
p-front that
> > you will want three off-site devices it is easy.
> >
> > You could
> >
> > =A0mdadm -C /dev/md0 -l1 -n2 -b internal /dev/A missing
> > =A0mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 missing
> > =A0mdadm -C /dev/md2 -l1 -n2 -b internal /dev/md1 missing
> > =A0mdadm -C /dev/md3 -l1 -n2 -b internal /dev/md2 missing
> >
> > =A0mkfs /dev/md3 ; mount ..
> >
> > =A0So you now have 4 "missing" devices.
>=20
> Alright, so I tried that on my project, being a low-end device is
> resulted in about 30-40% performance lost with 8 MDs (planning in
> advance), I tried disabling all bitmap to see if it helps and I get
> minimal performance gain. Is there anything I should tune in this
> case?

More concrete details would help...

So you have 8 MD RAID1s each with one missing device and the other devi=
ce is
the next RAID1 down in the stack, except that last RAID1 where the one =
device
is a real device.

And in some unspecified test the RAID1 at the top of the stack gives 2/=
3 the
performance of the plain device?  This the same when all bitmaps are
removed.

Certainly seems strange.

Can you give details of the test and numbers etc.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
