From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like 2.16.19.2
Date: Mon, 22 Jan 2007 13:37:35 +0000
Message-ID: <20070122133735.GB4493@ucw.cz>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sun 2007-01-21 14:27:34, Justin Piszcz wrote:
> Why does copying an 18GB on a 74GB raptor raid1 cause the kernel to invoke 
> the OOM killer and kill all of my processes?
> 
> Doing this on a single disk 2.6.19.2 is OK, no issues.  However, this 
> happens every time!
> 
> Anything to try?  Any other output needed?  Can someone shed some light on 
> this situation?

Is it highmem-related? Can you try it with mem=256M?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
