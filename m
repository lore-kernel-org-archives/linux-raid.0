From: whollygoat@letterboxes.org
Subject: Re: --examine contradicts --create and --detail, again
Date: Sun, 15 Feb 2009 22:22:20 -0800
Message-ID: <1234765340.31599.1300576011@webmail.messagingengine.com>
References: <1234349289.21577.1299744243@webmail.messagingengine.com>
 <20090211135917.GA7295@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090211135917.GA7295@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

On Wed, 11 Feb 2009 13:59:17 +0000, "Robin Hill" <robin@robinhill.me.uk>
said:
> On Wed Feb 11, 2009 at 02:48:09AM -0800, whollygoat@letterboxes.org
> wrote:
> 
[snip]

> > # mdadm -E /dev/hde1
> > 
> >     Array Slot : 0 (0, 1, 2, 3, failed, empty, 4)
> >    Array State : Uuuuu 1 failed
> > 
> > Sorry for bringing up this new instance of the same old 
> > problem yet one more time.
> >
> I'd say this is just an artifact of how the array creation works,
> Because it starts as a degraded array, initially one of the RAID devices
> is flagged as missing/faulty (so you have member numbers 0, 1, 2 and 3
> in the array, 4 flagged as missing/faulty, and 5 & 6 as spares).  When
> it does the initial build, it uses member number 6, leaving 5 as the
> spare.  This leaves you with 1 "failed" member and one "empty" (the
> spare - it's not part of the array so doesn't have a Device Number).
> 
> Unfortunately I don't have any RAID5 arrays around now to check whether
> I see the same here.  However, if the system's working fine otherwise
> then I certainly wouldn't worry about it.

Thanks for the reply.  Unfortunately, I can't claim to be enjoying a
finely working system.  Since your reply, I've tried unplugging the ide
expansion cards from the pci but, and playing around with the ide
cables.

I've managed to pull off one create run where the end result showed no
"failed" or "empty" slots for --examine.  Unfortunately, I have not been
able to reproduce that "clean" run, even with the same card removed.  So
I 
am guessing that it is either an ide cable or the sole ide card I have
not
been able to remove (kernel oopses when this card is not plugged into
the 
bus).

Ta,

wg
some bad h/w somewhere.
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - The way an email service should be

