From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 19:48:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030202004849.GA28521@willow.seitz.com>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu> <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net>
To: Jeffrey Paul <sneak@datavibe.net>
Cc: Stephan van Hienen <stephan@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 01, 2003 at 01:30:10PM -0500, Jeffrey Paul wrote:
> You could try hacking together another powersupply to run some of the
> harddisks... I'm not sure of the ATX pinouts, but it shouldn't be too hard
> to hack up a 12vdc relay or array of relays to one of the 12VDC pins on a
> molex connector of the existing power supply to turn on the second power
> supply, kind of slaving it to the first.

I Am Not an Electrican Engineer, But My Boss Is.  I did this once, and
he had a cow.  There was some problem he yelled at me, having to do with
different PSUs pulling voltage up at a different rate.  There's someway
he said that the differential in voltages would feed back through the
IDE channels, for some reason....

The short of it was that someone qualified to judge said it was a really
bad idea to use multiple seperate power supplies.

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
