From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: drive failing on same bus every couple weeks
Date: Mon, 4 May 2015 07:34:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505040728360.32169@uplift.swm.pp.se>
References: <CAAugdn6aaXZ45pbODiUp+3E74fXsgxWHKd6Dc7tuy77dqxhMNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAugdn6aaXZ45pbODiUp+3E74fXsgxWHKd6Dc7tuy77dqxhMNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Burke <steve.burke.56@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 3 May 2015, Stephen Burke wrote:

> Any ideas as to what could be going wrong?  The only other thing I can 
> think of hardware wise is I have a small power supply from a different 
> computer.  It seems to run everything fine.  I'm wondering if that 
> doesn't have enough power would random drive failures occur like this or 
> would they not power on?

The errors you pasted doesn't indicate a read or write error. Use 
"smartctl -a /dev/sdX" to check the drive hardware status, that'll give 
you a better indication if you're actually seeing read/write error or not.

The errors could indicate anything from bad cable, bad power or anything 
else, but moving the drive to another power socket, change the sata cable 
and move it to another controller port, are all very valid next steps, so 
is swapping out the PSU if you feel that that's close to the limit.

For instance, there are single and multi "rail" PSUs. If they're not 
single rail, then they have internal "partitions" that will each only give 
for instance half of the rated power output. If you put all your drives on 
one of the rails, then you're effectively just using half of the rated 
capacity. So that might be another thing to investigate. Personally, I 
would buy a single rail PSU and not have to worry about this.

http://www.overclock.net/t/761202/single-rail-vs-multi-rail-explained

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
