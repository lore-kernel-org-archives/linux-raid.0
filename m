From: Gordon Henderson <gordon@drogon.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sun, 2 Feb 2003 11:55:00 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0302021143540.17825-100000@unicorn.drogon.net>
References: <20030202004849.GA28521@willow.seitz.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030202004849.GA28521@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003, Ross Vandegrift wrote:

> On Sat, Feb 01, 2003 at 01:30:10PM -0500, Jeffrey Paul wrote:
> > You could try hacking together another powersupply to run some of the
> > harddisks... I'm not sure of the ATX pinouts, but it shouldn't be too hard
> > to hack up a 12vdc relay or array of relays to one of the 12VDC pins on a
> > molex connector of the existing power supply to turn on the second power
> > supply, kind of slaving it to the first.
>
> I Am Not an Electrican Engineer, But My Boss Is.  I did this once, and
> he had a cow.  There was some problem he yelled at me, having to do with
> different PSUs pulling voltage up at a different rate.  There's someway
> he said that the differential in voltages would feed back through the
> IDE channels, for some reason....
>
> The short of it was that someone qualified to judge said it was a really
> bad idea to use multiple seperate power supplies.

I've built many SCSI based systems where the disks are in a separate
enclosure with their own power supplies. There are many commercial system
built just like this. (eg. Sun used to supply separate external CD ROMs,
tapes and hard drive storage boxes all with their own PSU) I don't see why
it would be a problem with IDE drives - cable length would be the one
thing you might have a problem with though.

It's a lot of eggs in one basket though - do you really need contiguous
filespace, or might it be better split up into separate servers for each
'volume' ?

Good luck!

Gordon

