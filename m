From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 3Ware 7506-8, anyone have any luck?  I don't...
Date: Fri, 15 Oct 2004 20:44:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041015184410.GC3035@inara.maison.net>
References: <ckoj1a$pls$1@sea.gmane.org> <Pine.CYG.4.58.0410151323230.2068@buggz4> <1097862002.13597.57.camel@tinny.home.foo> <20041015181205.GB3035@inara.maison.net> <1097864507.13828.70.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097864507.13828.70.camel@tinny.home.foo>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[ Please do not address answers directly to me; I read the list. ]

* Scott T. Smith (scott@gelatinous.com) [20041015 11:21]:

> You know what, I think I was wrong -- we have the 8506.  Sorry,
> my bad.  And ours is SATA, not PATA (is that the difference
> between the 7xxx and 8xxx?)

Yes.

> There are other reasons the Highpoint is better than the 3ware,
> including the fact that it instantly recognizes when you yank a
> disk, unlike the 3ware which sits there for a while, and then
> hard resets the entire controller (thus halting all disk io to
> that controller for a couple of seconds).  3ware wrote me back
> and told me it's supposed to do that!

Cannot comment on this one, never was a problem for us.

> Is the 9500 a PCI-X card?

No, it's 64-bit 66 MHz PCI.
http://www.3ware.com/products/pdf/9000DS_041904.pdf

> [...] and we get the same crappy performance from that one too.

Define `crappy': I get 770 MiB/s read with 3x 3ware 9500S-8MI.
(RAID00 hw-sw)

> Worse yet, the 9xxx series wants to hijack your disks unless you
> go out of your way to enable 'export JBOD' mode.  You can't take
> a disk from a 9xxx controller and put it in a box with an 8506
> -- the controller won't recognize it!

Have you tried zapping the first and the last megabyte of the
disk?

> BTW I'm not talking about RAID or filesystem performance, I'm
> talking about direct disk access, JBOD mode, using rather large
> blocks.

Direct disk access gives me nominal disk throughput on 3ware.

> So really all I want is multiple controllers on a single card.
> To that end, the 1820a works great.  I figure we'd all be
> running software RAID anyways ;-)

As I said, attractive pricing.  Cannot get stellar hardware RAID
performance with crappy chipsets. :-)  There's a turnover point
where you are killed by PCI bandwith limit when using a lot of
disks.

Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=C3=A9ter     /       \       /       \     Peter.Kelemen@cer=
n.ch
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
