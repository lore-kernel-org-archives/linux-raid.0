From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
Date: Sat, 06 Dec 2008 16:55:41 +0000
Message-ID: <493AAE8D.8070607@yuiop.co.uk>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan> <493A5E62.1020508@msgid.tls.msk.ru> <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/2008 12:11, Justin Piszcz wrote:
> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece, 

These are the 2.5" drives, yes? Even then, I think that's very unlikely; 
they don't even claim any better than 6W operating, I think 8-10W is 
more likely. Even if they are running as low as 5-6W, they're so much 
smaller than 3.5" drives that heat could still cause problems. Can you 
check what temps the drives have reached, using smartctl?

> my entire system used ~100-120watts with all 12 velociraptors on a 650 
> watt PSU (now moved into a test system).

Do you have your dozen drives on a staggered start or all at power-on? I 
could see 12 drives starting at once causing damage to almost any 650W 
PSU unless it's designed specifically for hard drive enclosures, due to 
the relatively enormous current draw at startup - called inrush current.

Cheers,

John.
-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
