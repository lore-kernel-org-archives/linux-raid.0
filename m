From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid10: unfair disk load?
Date: Sat, 22 Dec 2007 13:05:59 +0100
Message-ID: <20071222130559.68b773fd@absurd>
References: <476BA4FD.6080401@msgid.tls.msk.ru>
	<476BA942.40406@msgid.tls.msk.ru>
	<20071221174902.6fc02c4e@absurd>
	<476C2869.1080903@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476C2869.1080903@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev said:     (by the date of Fri, 21 Dec 2007 23:56:09 +0300)

> Janek Kozicki wrote:
> > what's your kernel version? I recall that recently there have been
> > some works regarding load balancing.
> 
> It was in my original email:
> The kernel is 2.6.23
>
> Strange I missed the new raid10 development you
> mentioned (I follow linux-raid quite closely).
> What change(s) you're referring to?

oh sorry it was a patch for raid1, not raid10:

  http://www.spinics.net/lists/raid/msg17708.html

I'm wondering if it could be adapted for raid10 ...

Konstantin Sharlaimov said:     (by the date of Sat, 03 Nov 2007
20:08:42 +1000)

> This patch adds RAID1 read balancing to device mapper. A read operation
> that is close (in terms of sectors) to a previous read or write goes to 
> the same mirror.
<snip>

-- 
Janek Kozicki                                                         |
