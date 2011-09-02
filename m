From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 to another raid level??
Date: Fri, 2 Sep 2011 22:49:38 +1000
Message-ID: <20110902224938.74c30811@notabene.brown>
References: <-7094796685559591664@unknownmsgid>
	<CAFsPQ_97jNixHoYbMfxg9=FqXPWrsz_F1ZPSu1LTdGJA7N7Zcg@mail.gmail.com>
	<20110902121959.173a1aa9@notabene.brown>
	<CAFsPQ_8dA6B9yA4ZWZgAjZggNCBbcprAZrdHeJbPv+UvRz17mA@mail.gmail.com>
	<20110902202235.0194d779@notabene.brown>
	<CAFsPQ_-CfsAbqj-m3biVas0Cyv_+gkrNhHWWR_FkVNSDPB6dMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_-CfsAbqj-m3biVas0Cyv_+gkrNhHWWR_FkVNSDPB6dMg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: john.robinson@anonymous.org.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Sep 2011 11:35:30 +0100 Michael Busby <michael.a.busby@gmail.=
com>
wrote:

> Great, will test that in a bit
>=20
> will mdadm 3.2.2 support converting raid4 to raid5
>=20
> "A RAID4 can change the number of devices or the size of individual
> devices. It cannot be converted to RAID5 yet (though that should be
> trivial to implement)"

I guess the man page needs updating.  You would need a reasonably recen=
t
kernel... 2.6.30 or later.  I guess that isn't so recent any more.

NeilBrown


>=20
> On 2 September 2011 11:22, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 2 Sep 2011 10:12:32 +0100 Michael Busby <michael.a.busby@gm=
ail.com>
> > wrote:
> >
> >> Thanks Neil
> >>
> >> Is there anyway back from raid0 to raid4 as i know once at raid0 i
> >> will no longer be able to add any disks, in theory i could change
> >> echo raid0 > /sys/block/md0/md/level,but this would require adding=
 a
> >> missing disk to the raid4 at the same time, not sure how easy that
> >> would be todo
> >>
> >
> > Yes, you can switch from RAID0 to RAID4 in much the same way as you=
 switch
> > from RAID4 to RAID0.
> > You can then freeze/add-disk/change-size/unfreeze/wait/switch-back-=
to-RAID0
> > to add more devices.
> >
> > mdadm-3.2.2 should be able to do all this for you. =A0i.e. you ask =
it to --grow
> > a RAID and --add some disks at the same time, and it will do all th=
e required
> > magic.
> >
> > This hasn't been tested extensively, but should work in simple case=
s.
> >
> > Of course the more devices you have in a RAID0, the less reliabilit=
y you have
> > - but e.g. as a cache for a tape backup system a large RAID0 is fin=
e.
> >
> > NeilBrown
> >
> >
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
