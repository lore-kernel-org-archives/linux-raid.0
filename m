From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 3Ware 7506-8, anyone have any luck?  I don't...
Date: Fri, 15 Oct 2004 21:28:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041015192848.GD3035@inara.maison.net>
References: <ckoj1a$pls$1@sea.gmane.org> <Pine.CYG.4.58.0410151323230.2068@buggz4> <1097862002.13597.57.camel@tinny.home.foo> <20041015181205.GB3035@inara.maison.net> <1097864507.13828.70.camel@tinny.home.foo> <20041015184410.GC3035@inara.maison.net> <1097866503.13982.81.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097866503.13982.81.camel@tinny.home.foo>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Scott T. Smith (scott@gelatinous.com) [20041015 11:55]:

> then filter out email based on duplicate message-ids! :-P

I would if the corporate Exchange would _let_ me have duplicates.
It does not.  Moreover, I'm setting Mail-Followup-To: which _you_
are not honoring.

> When issueing random reads of 1 megabyte each, I get 2
> gigabits/sec from the Highpoint, and 1.5 gigabits/sec from the
> 3ware, when using a single controller and 8 disks (WD 250GB).
> No RAID, just JBOD mode, all disks in use at once.

Cannot comment on this one, haven't done measurements myself.  We
don't use random I/O much.

> the 8506 won't even let me set the disk up as a JBOD.  In order
> to zap it, I need yet another controller!

Do it with the 9xxx.  Interesting though... did you let 3ware know
about it?  (We do not have 8506s yet.)

> That's the funny thing about the 3ware 12 disk controllers; they
> don't even have the bandwidth to support all 12 disks!

Theoretically you could get 12*50 MiB/s out from the disks.  PCI
limit is just 12% lower.  Add processing overhead you are about to
go.

> It truly depends on what you want to use it for.  If you want
> RAID5, you most likely want a hardware solution, so yeah, 3ware
> would be the way to go.

Agreed.

> If you want JBOD though, I'd go with Highpoint.

Thanks for the data point.

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
