From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Fri, 8 Apr 2011 21:50:00 +1000
Message-ID: <20110408215000.15c881bb@notabene.brown>
References: <20110408193426.028b0f00@notabene.brown>
	<1215.67697.qm@web65110.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215.67697.qm@web65110.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Apr 2011 02:59:52 -0700 (PDT) Gavin Flower <gavinflower@yahoo=
=2Ecom>
wrote:

>=20
> --- On Fri, 8/4/11, NeilBrown <neilb@suse.de> wrote:
>=20
> > From: NeilBrown <neilb@suse.de>
> > Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds,=
 system unresponsive
> > To: "Gavin Flower" <gavinflower@yahoo.com>
> > Cc: linux-raid@vger.kernel.org
> > Date: Friday, 8 April, 2011, 21:34
> > On Thu, 7 Apr 2011 18:32:04 -0700
> > (PDT) Gavin Flower <gavinflower@yahoo.com>
> > wrote:
> >=20
> > > Hi Neil,
> > >=20
> > > My original email may have been eaten: as it did not
> > appear on the list, nor did I get an error message
> > back.=A0 So perhaps there was a problem with the attached
> > files.
> > >=20
> > > I will resend the attachments one at a time in
> > separate emails.
> > >=20
> > >=20
> > > Cheers,
> > > Gavin
> > >=20
> > > [begin original]
> > > Hi Neil,
> > >=20
> > > Your help (or anybody else's) would be greatly
> > appreciated, yet again
> >=20
> > Hi Gavin,
> >  it isn't clear to me what help you want.
> >=20
> > Obviously there is some sort of hardware issue - possible a
> > drive, possibly a
> > bus problem - I really don't know.
> >=20
> > Apart from that things look normal.
> >=20
> > What exactly did you want explained?
> >=20
> > NeilBrown
>=20
> I guess I was surprised that the RAID system appeared normal and that=
 it did not register any errors.  I was hoping to get an idea as to whi=
ch drive was problematic.

sdc2 was reporting read error.  md/raid6 computed the data from the oth=
er
devices and wrote it back to sdc2.  This appeared to work so md/raid6 a=
ssumed
everything was fine again.  It reported this:

Apr  7 08:42:08 saturn kernel: [210414.109880] md/raid:md1: read error =
corrected (8 sectors at 17195840 on sdc2)=20

but didn't fail anything.


>=20
> I get the feeling, from your reply, that this is not specifically a R=
AID problem, that it just happens to affect a RAID array.

No, it was clearly a disk-drive problem.
e.g.
Apr  7 14:42:12 saturn kernel: [231957.756023] ata3.00: failed command:=
 READ FPDMA QUEUED

a READ command sent to a n 'ata' device failed.  i.e. disk error.

>=20
> I had thought that the RAID system should have been able to give me b=
etter diagnostics, but possibly I am being (inadvertently) unreasonable=
!

Well.... it did tell you that it got a read error and corrected it.


>=20
> Not sure what the significance of this mismatch is, and what I should=
 do about it.
> # cat /sys/block/md2/md/mismatch_cnt=20
> 28904=20
> #=20

I'm not sure if read errors end up counting as mismatches..  They seem =
to for
raid1.  The raid6 code is more complex and I don't feel like decoding i=
t
right now.

In terms of "what to do about it" - the first thing must be to fix sdc.
Maybe there is a loose cable or a broken cable.  Maybe the device needs=
 to be
replaced.

Once you have resolved that and are fairly sure yours drives are all wo=
rking,
    echo check > /sys/block/md2/md/sync_action

once that finishes mismatch_cnt should ideally be zero.  If it isn't, t=
ry
    echo repair > /sys/block/md2/md/sync_action

but only do that if you are confident that your devices are good.
This will result in the same mismatch_cnt.  However a subsequent 'check=
'
should then show zero.

NeilBrown



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
