From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active
	devices)
Date: Tue, 15 Jul 2008 02:05:39 +0200
Message-ID: <20080715000539.GT4314@kiste.smurf.noris.de>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com> <20080625161357.GH23944@skl-net.de> <18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com> <g5fam0$8oe$1@ger.gmane.org> <487B7B74.3010903@dgreaves.com> <20080714225816.GS4314@kiste.smurf.noris.de> <487BE74C.8050004@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487BE74C.8050004@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Richard Scobie:
> This is why scheduled "check" or "repairs" should be done - see  
> Documentation/md.txt in the kernel source for details.
>
While I agree with that idea in general, the time required for such
checks tends to grow faster than the time to read a whole disk.

Besides: even if you regular checks, your data is still going to be
safer when you keep the disk online until its replacement is ready.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Cartoon Law IV: The time required for an object to fall twenty stories
is greater than or equal to the time it takes for whoever knocked it off
the ledge to spiral down twenty flights to attempt to capture it unbroken.
