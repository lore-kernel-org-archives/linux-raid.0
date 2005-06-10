From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: 3Ware on 64bit Linux.
Date: Fri, 10 Jun 2005 08:36:20 -0700
Message-ID: <200506100836.20625.hjm@tacgi.com>
References: <602f2f2b050608100938ddad81@mail.gmail.com> <200506081156.31051.hjm@tacgi.com> <42A94E91.80009@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A94E91.80009@nsr500.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Friday 10 June 2005 1:25 am, Tim Moore wrote:

> The SD's are 100% duty cycle, 24x7, 1M hour MTBF commercial SATA II drives,
> whereas the JD's are SATA I with a "desktop" rating and a 'designed for
> Microsoft Windows' cert.  Why WD would trade a commercial drive for a
> desktop drive?

Dunno, but they did, altho the disks back were 'recertified', not new.  As to 
the 1M MTBF rating, I also dunno.  I got 9 're-certified SD drives' back from 
WD and 2 of them (oops, make that 3 of them) have failed in the past 24 
hours, which points to some underlying problem in the system.  It's on a UPS 
which should condition the voltage. The drives that went out were on 
different ports and one of them was direct-connected, not via a hotswap cage 
(due to previous suspicions about the hotswap cage).

Any insight into this failure rate would be appreciated.  About to open 
another support call to 3ware...

> Besides that I've used 3Ware controllers since the 6400 and have had zero
> problems with anything.  

I guess I'm the reason they say YMMV. :)

> The gui tool is nice but not suited to production 
> use.

It sounded like his problem was a one-off change in structure which the gui 
was well suited for. 

Unless you're going to script it into maint mode, the gui seems to have 
benefits.
-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
