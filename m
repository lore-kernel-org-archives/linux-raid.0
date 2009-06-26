From: Neil Brown <neilb@suse.de>
Subject: Re: reshape raid5 to raid6
Date: Fri, 26 Jun 2009 12:00:02 +1000
Message-ID: <19012.11170.110416.705413@notabene.brown>
References: <20090624102729.GY2828@rlogin.dk>
	<972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>
	<a43edf1b0906240910l50f564fbh942be94e9e7fb281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Billy Crook on Wednesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 24, billycrook@gmail.com wrote:
> On Wed, Jun 24, 2009 at 06:20, NeilBrown<neilb@suse.de> wrote:
> > On Wed, June 24, 2009 8:27 pm, Michael Ole Olsen wrote:
> >> Is it possible to reshape my /dev/md0 raid5 into raid6?
> >
> > If you are are using Linux 2.6.30, then you can
> >
> > =A0echo raid6 > /sys/block/md0/md/level
> >
> > and it will instantly be sort-of-raid6.
> > It is exactly like raid6 except that the Q blocks are all one
> > the one drive, and drive that previously didn't exist.
> > If you have a spare, it will start building the Q blocks
> > on that drive and when it finishes you will have true raid6
> > redundancy, though possibly a little less than raid6 performance,
> > as a real raid6 has the Q block distributed.
> >
> > When mdadm-3.1 is released, you will be able to tell the raid6
> > to re-stripe with a more traditional layout. =A0This will take quit=
e
> > a while, but you can continue to use the array (though a bit more
> > slowly) will it progresses.
> > Of course you don't need to do that step if you don't want to.
>=20
> I have a raid5 array on 2.6.18 that I'd like to grow like this.  I
> might wait until mdadm-3.1 so I can stripe Q from the git-go.  I'd
> like to --stop the array on the 2.6.18 machine, and export the
> individual disks over iscsi to a 2.6.30 machine, and use the newer
> mdadm there to grow the array from raid5 to raid6.  Then --stop it on
> the 2.6.30 machine, unexport the disks, and --start the array again o=
n
> the 2.6.18 machine.  Disclaimers aside, should that work?  My main
> concern is 2.6.18's ability to work with this 'creative' raid6
> implementation that currently results from the grow from raid5 to
> raid6.

2.6.18 will not understand the raid6 created by simply echoing 'raid6'
in to the 'level' file.  It will need to be restriped with the help of
mdadm-3.1 first.

>=20
> I've also got a few disks to add, so maybe the better solution would
> be to add one and get the unstriped Q, then add another and let Q
> stripe with everything else during the reshape.  That is, if it will
> stripe Q during the reshape.

Your best bet would be to wait for mdadm-3.1 and do it all at once,
something like:
  mdadm --grow /dev/md0 --level=3Draid6 --raid-disks=3D8

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
