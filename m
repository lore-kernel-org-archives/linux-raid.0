From: Neil Brown <neilb@suse.de>
Subject: Re: Moved drives between machines... now, MIA.
Date: Mon, 8 Feb 2010 16:55:02 +1100
Message-ID: <20100208165502.13e53fd8@notabene.brown>
References: <a2feb7a4a744445965be6fc943fe34e7.squirrel@webmail.jots.org>
	<290032.65343.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <290032.65343.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: jd_hardcastle@yahoo.com, Ryan Wagoner <rswagoner@gmail.com>, Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Feb 2010 08:35:23 -0800 (PST)
Jon Hardcastle <jd_hardcastle@yahoo.com> wrote:

> --- On Tue, 2/2/10, Ken D'Ambrosio <ken@jots.org> wrote:
>=20
> > From: Ken D'Ambrosio <ken@jots.org>
> > Subject: Re: Moved drives between machines... now, MIA.
> > To: "Ryan Wagoner" <rswagoner@gmail.com>
> > Cc: linux-raid@vger.kernel.org
> > Date: Tuesday, 2 February, 2010, 15:36
> > > You did make a new mdadm.conf
> > with the correct devices for each array
> > > right? If not try running and seeing if your arrays
> > come up. If they do
> > > then copy /tmp/mdadm.conf to /etc/mdadm/mdadm.conf
> > >
> > > mdadm --examine --scan --config=3Dpartitions >
> > /tmp/mdadm.conf mdadm
> > > --assemble --scan --config=3D/tmp/mdadm.conf
> >=20
> > Hmmm.=C2=A0 I was hoping what I'd been doing had been
> > "wrong" somehow, but what
> > you've got is pretty much what I did.=C2=A0 And here's the
> > output (which
> > confuses the living Hell out of me):
> >=20
> > ARRAY /dev/md0 level=3Draid1 num-devices=3D2
> > UUID=3Df2de81aa:ccd40fc9:01dc0b99:e8df86c1
> > ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> > UUID=3D837925b3:f9f0e1b1:02f450c9:474613c9
> > ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> > UUID=3Db6af942c:119cd1fc:02f450c9:474613c9
> >=20
> > (Note how the second half of the last two UUIDs is the
> > same, and the last
> > two UUIDs are both for /dev/md1.)
> >=20
> > Guess it's time to go to the tapes, huh?
> >=20
> > Thanks,
> >=20
> > -Ken
> >=20
> >=20
>=20
> So basically all you have done is remove the drives from 1 machine an=
d insert in another? I would really hope that, that would not trash dat=
a... I have never tried it mind. i did recently change my drive order t=
hough just unplugged and re-plugged in a completely new order.
>=20

No, that in itself would not cause a problem.
If you have two machines each with /dev/md1, and you move the devices f=
rom
one to the other, that other will appear to have two different  /dev/md=
1
which would be confusing.  mdadm tries to be careful and will only asse=
mble
one of them, or will assemble them both with different names.

The commonality in the tail of the uuid of the two /dev/md1 array is si=
mply
because they were created with the same HOMEHOST.

You can assemble the arrays manually with something like

 mdadm -As /dev/md1 --uuid=3D.......
 mdadm -As /dev/md1a --uuid=3D...there-other-one....

Then look at the contents.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
