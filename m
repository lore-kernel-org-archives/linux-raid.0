From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: AARGH! Please help. IDE controller fsckup
Date: Thu, 3 Oct 2002 22:52:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021003205231.GA14585@unthought.net>
References: <20021003132349.GE7350@unthought.net> <Pine.LNX.4.10.10210031249210.10557-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.10.10210031249210.10557-100000@master.linux-ide.org>
To: Andre Hedrick <andre@linux-ide.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[snipping CC]

On Thu, Oct 03, 2002 at 01:05:44PM -0700, Andre Hedrick wrote:
>=20
> One of the observed issues under raid-tools is not looking at all the
> devices' superblocks.  This would allow for out of order initializati=
on.
> Treating the devices as domino chips and stuffing them back in random
> order and it working.

Have you seen this happening?  With non-development kernels?  ;)

There was one issue with raid startup that wouldn't start up arrays if
the first disk of the array was missing, or something like that. It was
a long-standing bug but it has been fixed.

I have not heard of the problem you're reporting.

>=20
> If I am wrong here, great.  Somebody please make the correction.

Now is the time for someone out there to actually point out that error
which I blissfully ignored and which ruined their TB array of medical
records...   ;)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
