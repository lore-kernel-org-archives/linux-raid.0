From: John Lange <john.lange@bighostbox.com>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 02:15:05 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085037305.10232.32.camel@localhost>
References: <Pine.LNX.4.44.0405200018170.15906-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0405200018170.15906-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-05-19 at 23:39, Mark Hahn wrote:
> the fact is that disks are dirt cheap now, so whining about their=20
> robustness is kind of silly.

On this point I can't agree with you. Sure, hardware is dirt cheap but
DATA is not. So long as the drive makers are up-front about it so
end-users know that they MUST have mirroring then fine, but they aren't=
=2E
Users are lead to believe the products are "ultra reliable" and
therefore are not as careful with their storage and backup solutions as
they should be.

At this point I must correct myself. I had said the drive was a Maxtor
but I was wrong. Just checked smartctl and in fact it is a Segate
ST3120026A. A google turns up the drives home page:

http://www.seagate.com/cda/products/discsales/marketing/detail/0,1081,5=
80,00.html

Quotes from the product data sheet (PDF on that page):

"The worlds toughest and Quietest High-Performance desktop drive with
=2E.."

"A proven rugged design for increased reliability"

"Best-Fit Applications
=C2=B7 Mainstream and High-Performance PCs
=C2=B7 Entry-Level ATA Servers, including RAID
=C2=B7 Cost-Effective Network Attached Storage"

I don't seem to see a footnote that says "50% of drives will fail in a
year or less..."

Going by the product sheet and the fact the drive has a 3 year warranty
you'd think you would be relatively safe. Nope...

>   if you don't like trusting a single=20
> disk, use raid: that's what it's for.  yes, it's less of a clean
> solution on small machines, but there is *no* reliability problem
> on servers, since raid5 is fast and cheap and you get to choose
> your comfort level of bomb-proof-ness.

I don't totally disagree but there are many other considerations. I may
have RAID 5 on my server but the server is in a data-center thats 2000k=
m
away. Shipping new drives and having a support call to install them can
get very expensive not to mention down time.

Never the less I believe we are all slowly coming to the realization
that mirroring is now the minimum we should deploy even on the desktop.

Its not really fair to the consumer though. Basically if they make the
drives really bad then we will buy twice as many of them. Of course thi=
s
only works for a while until a competitor destroys them (witness what
happened to the American auto makers when the Japanese started making
cars.)

> diskless PCs make HUGE amounts of sense;

AMEN! Having a hard drive in a PC on your desktop is completely
senseless in any office with more than about 2 desktops. LTSP (
www.ltsp.org ) all the way!

John Lange


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
