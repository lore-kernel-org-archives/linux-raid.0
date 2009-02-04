From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: bonnie++ on md device causes reboot on new motherboard
Date: Tue, 03 Feb 2009 19:02:58 -0600
Message-ID: <4988E942.1060402@gmail.com>
References: <20090203041450.GA2107@sewage.raw-sewage.fake>	<4988061B.2020904@dgreaves.com> <18824.24876.76210.433309@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18824.24876.76210.433309@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: David Greaves <david@dgreaves.com>, Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
> David> Matt Garman wrote:
>>> Anyone seen anything like this or have any ideas where I can start
>>> looking for more information?
> 
> David> netconsole?
> David> http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt
> 
> Or a serial console...
> 
> David> At least then you may see what the error is.  And for a crash
> David> like this I'd contact your distro kernel team too (not sure
> David> about lkml with 2.6.24 but probably)
> 
>>From the sounds of it, it's a Hardware problem of some sort.  I'd run
> a full memtest86 on the box, as well as some sort of CPU torture.
> Check all your cables, possibly remove two of the four disks, etc.
> 
> Remove as much memory as possible, re-seat memory board, etc.  Have
> you checked the BIOS version?  Have you reset the BIOS defaults to the
> 'safe' or 'default' settings?  Don't bother tweaking stuff to get more
> speed, go for stability.  The second you have porblems with stability,
> you've lost all that time you saved by tweaking things.  :]
> 
>

I would second the HW issue, if the machine is doing a full reset with 
no printout out of any type I would think PS, or some other serious HW 
issue, Linux generally does not crash without some error message.

How big of PS do you have?

I would try just dding the 4 disks at the same time and see if that 
also crashes.

And then if you can remove 2 disks from the machine and retest.


