From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid10: unfair disk load?
Date: Fri, 21 Dec 2007 23:56:09 +0300
Message-ID: <476C2869.1080903@msgid.tls.msk.ru>
References: <476BA4FD.6080401@msgid.tls.msk.ru>	<476BA942.40406@msgid.tls.msk.ru> <20071221174902.6fc02c4e@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071221174902.6fc02c4e@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Michael Tokarev said: (by the date of Fri, 21 Dec 2007 14:53:38 +0300)
> 
>>> I just noticed that with Linux software RAID10, disk
>>> usage isn't equal at all, that is, most reads are
>>> done from the first part of mirror(s) only.
> 
> what's your kernel version? I recall that recently there have been
> some works regarding load balancing.

It was in my original email:

> The kernel is 2.6.23 but very similar behavior is
> shown by earlier kernels as well.  Raid10 stripe
> size is 256Mb, but again it doesn't really matter
> other sizes behave the same here.

Strange I missed the new raid10 development you
mentioned (I follow linux-raid quite closely).
Lemme see...  no, nothing relevant in 2.6.24-rc5
(compared with 2.6.23), at least git doesn't show
anything interesting.  What change(s) you're
referring to?

Thanks.

/mjt
