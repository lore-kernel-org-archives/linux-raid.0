From: Gordon Henderson <gordon@drogon.net>
Subject: RE: 4 questions. Chieftec chassis case CA-01B, resync times, selecting
 ide driver module loading,  raid5 :2 drives on same ide channel
Date: Mon, 17 Jan 2005 11:41:36 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501171057160.21510@lion.drogon.net>
References: <200501161628.23034.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501161628.23034.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 16 Jan 2005, Mitchell Laks wrote:

> Thank you to Gordon, Maarten and Guy for your helpful responses. I learned
> much from each of  your comments.
>
> Gordon: I get the same output on 2.6.8 sarge kernel for hpt366 driver. I
> notice that running hdparm /dev/hde that the IO_support is set at
> default 16 bit while on the other hard drive on the natice ide bus
> /dev/hdb has IO_support at 32bit.  I wondered if I get the other driver
> whether that will improve things...

I get the same - 16-bit, however on that particular box, I also get 16-bit
for the on-board controller too (it is 6 years old though with a single
32-bit, 33MHz PCI bus!)

On other servers with a much more modern modo (dual Athlon systems) I see
32-bit for the on-board controller and 16-bit for the PCI Promise
controllers they have (I don't have anything else with a Highpoint card)

I'm not really up on PCI bus, etc. arcitecture, but I suspect the only
impact will be a doubling of the number of transactions going over the PCI
bus - probably not really an issue unless you have lots of PCI devices on
the same bus which all need to talk to each other, or to something
external (eg. Ethernet)

FWIW: I got a reply back from HighPoint about my question to run it under
2.6.10...

  Thanks for your contacting us!
  Our current OpenSource driver doesn't support kernel 2.6.10.

And that was all they had to say. Ho hum.


> I notice that according to the man page the settings you describe are the
> defaults. Why did you have to adjust them?
> Moreover When I cat
>  /proc/sys/dev/raid/speed_limit_max  -> i get ->200000
> /proc/sys/dev/raid/speed_limit_min  -> i get -> 1000.
>
> interesting is i didnt adjust them up myself.... Should I adjust the
> speed+limit_max down to 100000???
> I wonder where in debian it got adjusted up?

I don't think this is a distribution issue at all - certianly Debian
doesn't do anything with it at all and nothing appears to be inserted into
/etc/sysctl.conf

100000 seems to have been the default since at least 2.4.22 (the oldest
kernel I have running s/w RAID)

Gordon
