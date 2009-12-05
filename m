From: Asdo <asdo@shiftmail.org>
Subject: Re: Random IO with md raid
Date: Sat, 05 Dec 2009 15:20:24 +0100
Message-ID: <4B1A6C28.20800@shiftmail.org>
References: <4B198DBA.5000906@matws.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B198DBA.5000906@matws.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthieu Patou <mat@matws.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matthieu Patou wrote:
> * 1 raid 1 volume of 2 1TB hard drive
Are these drives also on the 3ware? Are they exported as jbod?
> * 2 single volume of 1 TB hard drive each
> ...
> Does anyone has an any idea ?

Try anticipatory, deadline and noop schedulers on disks (not CFQ)
Try setting readahead to exactly 4K, or set it to lowest possible value 
(I'm not sure what is best), since this is random access...
Increase stripe_cache_size as high as you can, p
Let us/me know the results afterwards...
Thank you
Asdo

