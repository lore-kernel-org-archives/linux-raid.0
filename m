From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 -> RAID6 conversion, please help
Date: Wed, 11 May 2011 13:29:35 +1000
Message-ID: <20110511132935.0438143a@notabene.brown>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu>
	<20110511093155.5b1a203e@notabene.brown>
	<4DC9CCAF.9010709@crc.id.au>
	<20110511102116.494bf0fd@notabene.brown>
	<BANLkTimwg94Bz22q5J7FJTcuFvX4BpRECg@mail.gmail.com>
	<20110511104730.175372fe@notabene.brown>
	<BANLkTimYWfT_Vr7ZUnNUhOqW2JOyLHHNQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimYWfT_Vr7ZUnNUhOqW2JOyLHHNQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 May 2011 21:04:29 -0400 Dylan Distasio <interzone@gmail.com>=
 wrote:

> It's possible I did use different versions but I thought I had
> upgraded both of them right before the reshapes.  Sorry if this is an
> elementary question, but does writing the 2nd parity block always to
> the last drive instead of rotating it increase the odds of a total
> loss of the array since the one specific drive always has the 2nd
> parity block?

No.  The only possibly impact is a performance impact, and even that wo=
uld be
hard to quantify.

The reason that parity is rotated is to avoid a 'hot disk'.  Every upda=
te has
to write the parity block and if they are all on one disk then every wr=
ite
will generate a write to that one disk.

Because of the way md implements RAID6, every write involves either a r=
ead or
a write to every device, so there is no real saving in rotating parity.

I think (but am open to being corrected) that rotating parity is only
important for RAID6 if the code implements 'subtraction' as well as
'addition' for the Q syndrome (which md doesn't) and if you have at lea=
st 5
drives, and you probably wouldn't notice until you get to 7 or more dri=
ves.

=2E.. so it might make sense to make mdadm default to converting to the=
 -6
layout...
You can request it with "--layout=3Dpreserve".


>=20
> If so, do you think normalizing would be worth the risk of something
> going wrong with that operation?  I'm just trying to get a feel for
> how much of a difference this makes.

Not worth the risk.

NeilBrown



>=20
>=20
> > mdadm first converts the RAID5 to RAID6 in an instant atomic operat=
ion which
> > results in the "-6" layout. =A0It then starts a restriping process =
which
> > converts the layout.
> >
> > If you end up with a -6 layout then something when wrong starting t=
he
> > restriping process.
> >
> > Maybe you used different version of mdadm? =A0There have probably b=
een bugs in
> > some versions..
> >
> > NeilBrown
> >
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
