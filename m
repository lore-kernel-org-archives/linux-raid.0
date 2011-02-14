From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: mdadm: recovering from an aborted reshape op - to ensure at least one email gets through!
Date: Sun, 13 Feb 2011 22:35:48 -0800 (PST)
Message-ID: <89286.66236.qm@web65101.mail.ac2.yahoo.com>
References: <20110214130733.6e9ab345@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214130733.6e9ab345@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

It completed without apparent error (I did see errors in my very quick =
look!) - so I rebooted.

Unfortunately, it stopped in the same place.  It ran for over an hour b=
efore I went out, it had stopped by the time I got back a couple of hou=
rs late.

I should have captured dmesg before I rebooted, but I didn't (I blame w=
alking for almost an hour in the hot Sun...).

I will follow this with email with hopefully useful diagnostics...


Cheers,
Gavin
--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


--- On Mon, 14/2/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: mdadm: recovering from an aborted reshape op - to ensure=
 at least one email gets through!
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Monday, 14 February, 2011, 15:07
> On Sun, 13 Feb 2011 16:36:15 -0800
> (PST) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> > Hi Neil,
> >=20
> > You last command seems to be doing something useful,
> after I had given it the original backup file.
> >=20
> > I will update you when it finishes...
> >=20
> > Will you still want the diagnostic output?=A0 I am
> happy to send it, if you think it will be useful.
>=20
> No, not necessary.
>=20
> I guess whatever boot script tried to assemble the device
> didn't know
> to tell it about a backup file and so the assembly didn't
> complete,
> leaving you to pick up the pieces, but with no clear
> message explaining
> what the pieces were...
>=20
>=20
> I hope that in a few releases we can largely do away with
> the backup
> file so I probably won't put much effort into trying to
> make this all
> run more seamlessly.
>=20
>=20
> >=20
> > If you want me to run other diagnostics, please let me
> know.
> >=20
> > You deserve a huge bonus on top of the exorbitant (of
> zero dollars and zero cents) fee I am paying you! -)
>=20
> :-)
>=20
>=20
> Thanks,
> NeilBrown
>=20
>=20
> >=20
> >=20
> > Thanks,
> > Gavin
> > --
> > All Adults share the Responsibility
> > to help Raise Today's Children,
> > for they are Tomorrow's Society!
> >=20
> >=20
> > --- On Mon, 14/2/11, NeilBrown <neilb@suse.de>
> wrote:
> >=20
> > > From: NeilBrown <neilb@suse.de>
> > > Subject: Re: mdadm: recovering from an aborted
> reshape op - to ensure at least one email gets through!
> > > To: "Gavin Flower" <gavinflower@yahoo.com>
> > > Cc: linux-raid@vger.kernel.org
> > > Date: Monday, 14 February, 2011, 13:00
> > > On Sun, 13 Feb 2011 15:10:36 -0800
> > > (PST) Gavin Flower <gavinflower@yahoo.com>
> > > wrote:
> > >=20
> > > > Hi Neil,
> > > >=20
> > > > I'll send this now.
> > > >=20
> > > > My previous 2 attempts failed.
> > > >=20
> > > > I had the first bounce due to HTML, but no
> errors
> > > reported for my second attempt.
> > > >=20
> > > > I replied to you blog post.
> > > >=20
> > >=20
> > > Yes - vger.kernel.org doesn't like html.
> > > Normal attachments should work - and you should
> get a
> > > bounce-message
> > > if there is something odd.
> > > But this and the following messages did get
> through.
> > >=20
> > > For those on linux-raid: the background is that a
> reshape
> > > for a RAID6
> > > to change chunksize was interrupted by the admin
> killing
> > > the mdadm
> > > which monitors the reshape.=A0 Then after a reboot
> the
> > > array isn't working=20
> > > properly.
> > >=20
> > > When I asked for "mdadm -Evs" I should have asked
> for an
> > > extra 'v' - I keep
> > > forgetting that.
> > > However for now:=A0 what would help is:
> > >=20
> > >=A0 mdadm -S /dev/md1
> > >=A0 mdadm -E /dev/md[abcde]2
> > >=A0 mdadm -Av /dev/md1 /dev/sd[abcde]2
> > >=A0 dmesg | tail -50
> > >=20
> > > capture all of the output and post that.
> > >=20
> > > Thanks,
> > > NeilBrown
> > >=20
> > >=20
> >=20
> >=20
> >=A0 =A0 =A0=A0=A0
>=20
>=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
