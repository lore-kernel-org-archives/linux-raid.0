From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID problems
Date: Wed, 31 Jul 2002 05:42:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <30738.2608451464$1028087098@news.gmane.org>
References: <20020730175505.GI11129@unthought.net> <Pine.LNX.3.96.1020730223102.6974A-100000@gatekeeper.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1020730223102.6974A-100000@gatekeeper.tmr.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 30, 2002 at 10:46:55PM -0400, Bill Davidsen wrote:
=2E..
> I think you misread my comment, it was not "why doesn't the documenta=
tion
> say this" but rather "why does software RAID have this problem?"

Ok, my bad.

 - btw. I CC'ed linux-raid as this is getting a little OT for
   linux-kernel.  Let's let the thread migrate to linux-raid instead...

> I know
> this can happen in theory, but it seems that the docs imply that this
> isn't a surprise in practice. I've been running systems with SCSI RAI=
D and

I would say it's not a surprise as such, but it's something that really
should be a very very rare occurrance.

I've seen it maybe once on a production system, having run MD on quite =
a
few computers for the past half decade.  And I've had a few handfulls o=
f
people asking me about it over the years.

=2E..
> I just surprised that the software RAID doesn't have better luck with
> this, I don't see any magic other than maybe a bus reset the firmware
> would be doing, and I'm wondering why this seems to be common with Li=
nux.

I don't have the impression that it is common on stable hardware.  Can
anyone who runs SW RAID on a number (greater than 1) of machines commen=
t
on this ?

However, some people run their RAID-5 arrays on the same SCSI busses as
their Zip drives, their scanners, and five other el-cheapo almost-scsi
devices, and that is just *bound* to cause this kind of mess when one o=
f
the devices decide to lock up the bus.

You don't see this with HW raid because you don't put your $15
almost-scsi magic-foo device on your $2k HW RAID controller.

There might be other simple reasons why some HW cards don't show this
behaviour - they might simply maintain their superblocks differently
from Linux SW RAID.   I have *no* idea how current controllers do this.

> Or am I misreading the frequency with which it happens?

I hope  ;)

At least in the "stable hardware" situation.  Comments, please...

=2E..
> Thye words are clear, I'm surprised at the behaviour. Yes, I know tha=
t's
> not your thing.

I *will* be surprised if it turns out that this is really a common
occurrence for people.   :)

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
