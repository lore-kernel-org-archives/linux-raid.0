From: Dale Stephenson <dale.stephenson@quantum.com>
Subject: RE: SV: RAID-6 support in kernel?
Date: Mon, 3 Jun 2002 12:03:23 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2D0AFEFEE711D611923E009027D39F2B02F17E@nasexs1.meridian-data.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Kasper Dupont' <kasperd@daimi.au.dk>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Christian Vik <cvik@vanadis.no>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Dupont wrote:
> Roy Sigurd Karlsbakk wrote:
> > 
> > Below is a (patented?)
> 
> No problem for me I live in Europe.
> 
> > version that works. This is from the linux-raid list
> > 
> > >  A1   A2  (P1) (PA)
> > > (P2) (PB)  B2   B1
> 
> Nice, looks like it works.
> 
> > >  C4   C3  (PC) (P3)
> > > (PD) (P4)  D3   D4
> 
> In this encoding the roles of disk one and two are
> switched, and three and four are also switched. Are
> there any reason for this?
> 
I liked spreading the row-based and column-based parity across all disks.
Would that matter?  It could, depending on implementation.

Consider an access pattern to the RAID which writes full stripes, and only
the first two lines (repeating) are used as an access pattern.  This might
go something like this:

write A1 & A2 (Reads P1 & P2, calculates P1, PA, P2, writes A1, A2, P1, PA,
P2)
write B2 & B1 (Reads P1 & P2, calculates P1, P2, PB, writes P1, P2, PB, B2,
B1)

Repeat this a bunch of times, and you'll find you are writing twice as many
blocks to Drives 1 & 3 as you are to Drives 2 & 4.  However, if you add the
C and D rows to the scheme, the full-stripe writes spread the column parity
writes evenly across all drives.

Of course, for a 4 drive setup there's no reason to use RAID 6 at all (RAID
10 will withstand any two drive failure if you only use 4 drives), but
that's the reasoning.  I think the best way to deal with the read-modify
write problem for RAID 6 is to use a small chunk size and deal with NxN
chunks as a unit.  But YMMV.

Dale Stephenson
steph@snapserver.com
