From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 23 Jul 2008 09:45:39 +0200
Message-ID: <20080723074539.GA13549@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <487CEF1A.6050402@wasp.net.au> <20080715201221.GB26439@rap.rap.dk> <4884BF7B.6030206@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4884BF7B.6030206@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Brad Campbell <brad@wasp.net.au>, Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 21, 2008 at 12:55:23PM -0400, Bill Davidsen wrote:
> Keld J=F8rn Simonsen wrote:
> >On Tue, Jul 15, 2008 at 10:40:26PM +0400, Brad Campbell wrote:
> > =20
> >>Keld J=F8rn Simonsen wrote:
> >>
> >>   =20
> >>>I would also welcome test with mobo HW RAID - Many mobo's today co=
me
> >>>with some HW raid functionality, and many people would be in the
> >>>situation of whether to choose a HW or SW configuration.
> >>>     =20
> >>Do you have some pointers for information on motherboards that come=
 with=20
> >>hardware raid? I'd be interested to have a look at them. I've certa=
inly=20
> >>seen plenty of "fakeraid" systems, but I've not yet come across har=
dware=20
> >>raid on an MB.
> >>   =20
> >
> >It is possible that I am thinking of what you call fakeraid.
> > =20
>=20
> I like "firmware raid" better, but the bottom line here is that the r=
aid=20
> is still done in the system CPU. These often have little or no hardwa=
re=20
> support, such as cache so that multiple drives can be written without=
=20
> passing the data through the system bus more than once (and chancing=20
> change while that happens).

OK, if the definition on these controllers is that they must have suppo=
rt
from the OS, then I think most of the mobos today come with hardware
raid, that is there needs to be no support in Linux for this. Everythin=
g
is set up via the bios, and from the linux kernel it looks like an
ordinary disk.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
