From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Wed, 31 Aug 2011 10:54:55 +1000
Message-ID: <20110831105455.04fd585e@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy4PCVCDuxiwC1BSo7Hj=_RNVoKdRRB_+NgkPA8+FsOy0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4PCVCDuxiwC1BSo7Hj=_RNVoKdRRB_+NgkPA8+FsOy0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Aug 2011 18:18:11 +0300 Alexander Lyakas <alex.bolshoy@gmail=
=2Ecom>
wrote:

> Thanks, Neil.
>=20
> Although according to udev documentation: "the udev events are sent
> out after udev has finished its event processing, all rules have been
> processed, and needed device nodes are created."
>=20
> Also looking at udev-worker code of udevd, the
> udev_monitor_send_device() call is done after all the rules have been
> processed.
>=20
> Nevertheless, I looked at udevadm_settle.c and did some equivalent of
> that in my code, and it looks like the issue is resolved. Perhaps
> there is something md-specific here?

I cannot see how it would be md-specific.  mdadm doesn't create or remo=
ve
devices when udev is active - it leaves all that to udev.
If you are curious I suggest you ask the udev developers.

>=20
> Another thing, since you are reading this thread, I wanted to ask
> whether you have any advice on the "RAID5: failing an active componen=
t
> during spare rebuild - arrays hangs" thread I opened some time ago.
> Since you were not answering, I assume there is nothing additional yo=
u
> can advise about, correct? I apologize if this off-topic was
> inappropriate.

It could mean that I had nothing extra to say, but it could also mean t=
hat I
got distracted, forgot, and never got back to it.  I live in a world of
distractions :-(

But a reminder never hurts - it shows that it is important to you, so t=
hat
makes it at least a little bit important to me.  I'll go back and have =
a look
and see if I have anything useful to add.

NeilBrown


>=20
> Thanks for the help,
>   Alex.
>=20
>=20
>=20
> On Tue, Aug 30, 2011 at 12:25 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bolshoy@g=
mail.com>
> > wrote:
> >
> >> Greetings everybody,
> >>
> >> I issue
> >> mdadm --stop /dev/md0
> >> and I want to reliably determine that the MD devnode (/dev/md0) is=
 gone.
> >> So I look for the udev 'remove' event for that devnode.
> >> However, in some cases even after I see the udev event, I issue
> >> mdadm --detail /dev/md0
> >> and I get:
> >> mdadm: md device /dev/md0 does not appear to be active
> >>
> >> According to Detail.c, this means that mdadm can successfully do
> >> open("/dev/md0") and receive a valid fd.
> >> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENOD=
EV
> >> from the kernel.
> >>
> >> Can somebody suggest an explanation for this behavior? Is there a
> >> reliable way to know when a MD devnode is gone?
> >
> > run "udevadm settle" after stopping /dev/md0 =A0is most likely to w=
ork.
> >
> > I suspect that udev removes the node *after* you see the 'remove' e=
vent.
> > Sometimes so soon after that you don't see the lag - sometimes a bi=
t later.
> >
> > NeilBrown
> >
> >>
> >> Thanks,
> >> =A0 Alex.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
