From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like 2.16.19.2
Date: Thu, 25 Jan 2007 01:32:42 +0100
Message-ID: <20070125003242.GA23343@elf.ucw.cz>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan> <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Hi!

> > Is it highmem-related? Can you try it with mem=256M?
> 
> Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
> 2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
> use an onboard graphics controller that has 128MB of RAM allocated to it 
> and I believe the ICH8 chipset also uses some memory, in any event mem=256 
> causes the machine to lockup before it can even get to the boot/init 
> processes, the two leds on the keyboard were blinking, caps lock and 
> scroll lock and I saw no console at all!

Okay, so try mem=700M or disable CONFIG_HIGHMEM or something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
