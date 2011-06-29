From: NeilBrown <neilb@suse.de>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 20:45:19 +1000
Message-ID: <20110629204519.419474d2@notabene.brown>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 11:32:55 +0100 (BST) Tom De Mulder <tdm27@cam.ac.uk=
>
wrote:

> On Tue, 28 Jun 2011, Mathias Bur=E9n wrote:
>=20
> > IIRC md can already pass TRIM down, but I think the filesystem need=
s
> > to know about the underlying architecture, or something, for TRIM t=
o
> > work in RAID.
>=20
> Yes, it's (usually/ideally) the filesystem's job to invoke the TRIM=20
> command, and that's what ext4 can do. I have it working just fine on=20
> single drives, but for reasons of service reliability would need to g=
et=20
> RAID to work.
>=20
> I tried (on an admittedly vanilla Ubuntu 2.6.38 kernel) the same on a=
 two=20
> drive RAID1 md and it definitely didn't work (the blocks didn't get m=
arked=20
> as unused and zeroed).
>=20
> > There's numerous discussions on this in the archives of
> > this mailing list.
>=20
> Given how fast things move in the world of SSDs at the moment, I want=
ed to=20
> check if any progress was made since. :-) I don't seem to be able to =
find=20
> any reference to this in recent kernel source commits (but I'm a comp=
lete=20
> amateur when it comes to git).


Trim support for md is a long way down my list of interesting projects =
(and
no-one else has volunteered).

It is not at all straight forward to implement.

=46or stripe/parity RAID, (RAID4/5/6) it is only safe to discard full s=
tripes at
a time, and the md layer would need to keep a record of which stripes h=
ad been
discarded so that it didn't risk trusting data (and parity) read from t=
hose
stripes.  So you would need some sort of bitmap of invalid stripes, and=
 you
would need the fs to discard in very large chunks for it to be useful a=
t all.

=46or copying RAID (RAID1, RAID10) you really need the same bitmap.  Th=
ere
isn't the same risk of reading and trusting discarded parity, but a res=
ync
which didn't know about discarded ranges would undo the discard for you=
=2E

So is basically requires another bitmap to be stored with the metadata,=
 and a
fairly fine-grained bitmap it would need to be.  Then every read and re=
sync
checks the bitmap and ignores or returns 0 for discarded ranges, and ev=
ery
write needs to check and if the range was discard, clear the bit and wr=
ite to
the whole range.

So: do-able, but definitely non-trivial.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
