From: Peter Bartosch <peter@bartosch.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Thu, 6 Feb 2003 17:04:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030206160409.GA31726@bartosch.net>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu> <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net> <20030202004849.GA28521@willow.seitz.com>
Reply-To: peter@bartosch.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030202004849.GA28521@willow.seitz.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!


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

the problem with the feed back occurs when you connect the (e.g) +12V
lines of both PSU's, (and the GND offcourse) the PSU with more power
tries to supply the other and will get damaged

if you only connect the GND, and use the second supply for hdd's only it
will work. the resistance of the ICs (interface, etc) will prevent the
feet back 

Peter
