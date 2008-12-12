From: Pavel Machek <pavel@suse.cz>
Subject: Re: Intel X25-E running Linux using XFS
Date: Fri, 12 Dec 2008 19:58:03 +0100
Message-ID: <20081212185803.GE11974@elf.ucw.cz>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids


Hi!

> Due to the 100k write cycle lifetime, I will not be performing any more 
> benchmarks on the SSD itself, such benchmarks are available on  
> techreport.com but just wanted to send out the smart data for the  
> smartmontools list and point out it is working with linux+ich7+xfs.
>
> Overall, whenever I do anything now its just like the entire machine is
> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>
> The techreport benchmarks are here:
> http://techreport.com/articles.x/15931

Actually I'd like to know... how does it behave during powerfails
while it is being written to?

Flashes I seen (USB / SD) developed bad sectors in that case, and
ext2/ext3 can't handle that. (And I don't think xfs can handle that
either).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
