From: NeilBrown <neilb@suse.de>
Subject: Re: Software RAID and TRIM
Date: Thu, 30 Jun 2011 10:27:08 +1000
Message-ID: <20110630102708.6e443bd5@notabene.brown>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
	<20110629204519.419474d2@notabene.brown>
	<87d3hwah9v.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d3hwah9v.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 22:39:24 +0900 Namhyung Kim <namhyung@gmail.com> wr=
ote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > On Wed, 29 Jun 2011 11:32:55 +0100 (BST) Tom De Mulder <tdm27@cam.a=
c.uk>
> > wrote:
> >
> >> On Tue, 28 Jun 2011, Mathias Bur=E9n wrote:
> >>=20
> >> > IIRC md can already pass TRIM down, but I think the filesystem n=
eeds
> >> > to know about the underlying architecture, or something, for TRI=
M to
> >> > work in RAID.
> >>=20
> >> Yes, it's (usually/ideally) the filesystem's job to invoke the TRI=
M=20
> >> command, and that's what ext4 can do. I have it working just fine =
on=20
> >> single drives, but for reasons of service reliability would need t=
o get=20
> >> RAID to work.
> >>=20
> >> I tried (on an admittedly vanilla Ubuntu 2.6.38 kernel) the same o=
n a two=20
> >> drive RAID1 md and it definitely didn't work (the blocks didn't ge=
t marked=20
> >> as unused and zeroed).
> >>=20
> >> > There's numerous discussions on this in the archives of
> >> > this mailing list.
> >>=20
> >> Given how fast things move in the world of SSDs at the moment, I w=
anted to=20
> >> check if any progress was made since. :-) I don't seem to be able =
to find=20
> >> any reference to this in recent kernel source commits (but I'm a c=
omplete=20
> >> amateur when it comes to git).
> >
> >
> > Trim support for md is a long way down my list of interesting proje=
cts (and
> > no-one else has volunteered).
> >
>=20
> Just out of curiosity, what are there in your list? :)
>=20
>=20

   http://neil.brown.name/blog/20110216044002

I have code for the first - the bad block log - and it seems to work.  =
But I
really need to design and then perform some more testing.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
