From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Sun, 10 Apr 2011 23:50:07 -0700 (PDT)
Message-ID: <165228.90505.qm@web65113.mail.ac2.yahoo.com>
References: <20110408215000.15c881bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408215000.15c881bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 8/4/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 8 April, 2011, 23:50
> On Fri, 8 Apr 2011 02:59:52 -0700
> (PDT) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> >=20
> > --- On Fri, 8/4/11, NeilBrown <neilb@suse.de>
> wrote:
> >=20
> > > From: NeilBrown <neilb@suse.de>
> > > Subject: Re: RAID6 data-check took almost 2
> hours, clicking sounds, system unresponsive
[...]
> > > Obviously there is some sort of hardware issue -
> possible a
> > > drive, possibly a
> > > bus problem - I really don't know.
> > >=20
> > > Apart from that things look normal.
> > >=20
> > > What exactly did you want explained?
> > >=20
> > > NeilBrown
> >=20
> > I guess I was surprised that the RAID system appeared
> normal and that it did not register any errors.=A0 I was
> hoping to get an idea as to which drive was problematic.
>=20
> sdc2 was reporting read error.=A0 md/raid6 computed the
> data from the other
> devices and wrote it back to sdc2.=A0 This appeared to
> work so md/raid6 assumed
> everything was fine again.=A0 It reported this:
>=20
> Apr=A0 7 08:42:08 saturn kernel: [210414.109880]
> md/raid:md1: read error corrected (8 sectors at 17195840 on
> sdc2)=20
>=20
> but didn't fail anything.
>=20
>=20
> >=20
> > I get the feeling, from your reply, that this is not
> specifically a RAID problem, that it just happens to affect
> a RAID array.
>=20
> No, it was clearly a disk-drive problem.
> e.g.
> Apr=A0 7 14:42:12 saturn kernel: [231957.756023]
> ata3.00: failed command: READ FPDMA QUEUED
>=20
> a READ command sent to a n 'ata' device failed.=A0 i.e.
> disk error.
>=20
> >=20
> > I had thought that the RAID system should have been
> able to give me better diagnostics, but possibly I am being
> (inadvertently) unreasonable!
>=20
> Well.... it did tell you that it got a read error and
> corrected it.
>=20
>=20
> >=20
> > Not sure what the significance of this mismatch is,
> and what I should do about it.
> > # cat /sys/block/md2/md/mismatch_cnt=20
> > 28904=20
> > #=20
>=20
> I'm not sure if read errors end up counting as
> mismatches..=A0 They seem to for
> raid1.=A0 The raid6 code is more complex and I don't
> feel like decoding it
> right now.
>=20
> In terms of "what to do about it" - the first thing must be
> to fix sdc.
> Maybe there is a loose cable or a broken cable.=A0 Maybe
> the device needs to be
> replaced.
>=20
> Once you have resolved that and are fairly sure yours
> drives are all working,
> =A0 =A0 echo check >
> /sys/block/md2/md/sync_action
>=20
> once that finishes mismatch_cnt should ideally be
> zero.=A0 If it isn't, try
> =A0 =A0 echo repair >
> /sys/block/md2/md/sync_action
>=20
> but only do that if you are confident that your devices are
> good.
> This will result in the same mismatch_cnt.=A0 However a
> subsequent 'check'
> should then show zero.
>=20
> NeilBrown

Thanks,

I followed your suggestions and all 'appears' to be fine now.

Reality was a wee bit more dramatic than I would have liked!

Machine refused to boot this morning, complaining about disk errors.  F=
ortunately, I had arranged for a hardware capable friend to come around=
=2E He adjusted the cable on the offending drive and I ran fsck twice (=
lots of alarming messages first time). On rebooting, the system came up=
, but a video driver problem prevented the desktop from working.  Fortu=
nately I was able to log in from another machine and apply your suggest=
ed remedy.  After the repair, I rebooted and was able to get into my de=
sktop, subsequent checks revealed the mismatch counts to be all zero (I=
 checked the failed RAID array and the other 2)


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
