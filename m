From: "Andre' Breiler" <andre.breiler@null-mx.org>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sun, 2 Feb 2003 11:52:26 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302021147480.535-100000@pegasus.teamwerk.com>
References: <Pine.LNX.4.43.0302021143540.17825-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0302021143540.17825-100000@unicorn.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: Ross Vandegrift <ross@willow.seitz.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Sun, 2 Feb 2003, Gordon Henderson wrote:

> On Sat, 1 Feb 2003, Ross Vandegrift wrote:
>
> > On Sat, Feb 01, 2003 at 01:30:10PM -0500, Jeffrey Paul wrote:
> > > You could try hacking together another powersupply to run some of the
> > > harddisks... I'm not sure of the ATX pinouts, but it shouldn't be too hard
> > > to hack up a 12vdc relay or array of relays to one of the 12VDC pins on a
> > > molex connector of the existing power supply to turn on the second power
> > > supply, kind of slaving it to the first.
> >
> > I Am Not an Electrican Engineer, But My Boss Is.  I did this once, and
> > he had a cow.  There was some problem he yelled at me, having to do with
> > different PSUs pulling voltage up at a different rate.  There's someway
> > he said that the differential in voltages would feed back through the
> > IDE channels, for some reason....
> >
> > The short of it was that someone qualified to judge said it was a really
> > bad idea to use multiple seperate power supplies.
>
> I've built many SCSI based systems where the disks are in a separate
> enclosure with their own power supplies. There are many commercial system

SCSI is different as it was designed with this in mind (you drive the
lines against termination power which is supplied by _one_ source).

> built just like this. (eg. Sun used to supply separate external CD ROMs,
> tapes and hard drive storage boxes all with their own PSU) I don't see why
> it would be a problem with IDE drives - cable length would be the one
> thing you might have a problem with though.

I'd think IDE isn't designed for this (even that it works most times if
the powersupplies are close enough in terms of voltage and grounding).
So here is a risk that you would overstress something but usally it works
well.

Bye Andre'
-- 

