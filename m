From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
Date: Fri, 23 Feb 2007 14:11:50 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0702231411130.9736@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 23 2007 06:41, Justin Piszcz wrote:
>
> I was able to Alt-SysRQ+b but I could not access the console/X/etc, it appeared
> to be frozen.

No sysrq+t? (Ah, unblanking might hang.) Well, netconsole/serial to the rescue,
then ;-)


Jan
-- 
