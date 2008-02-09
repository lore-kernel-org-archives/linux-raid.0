From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: RAID5 how chage chunck size from 64 to 128, 256 ? is it
 possible ?
Date: Sat, 9 Feb 2008 23:31:59 +0100
Message-ID: <20080209233159.659ce16d@szpak>
References: <1498963728.20080209074300@j8.com.ru>
	<alpine.DEB.1.00.0802090414310.27612@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0802090414310.27612@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz said:     (by the date of Sat, 9 Feb 2008 04:14:51 -0500 (EST))

> When you reate the array its --chunk or -c -- I found 256 KiB to 1024 KiB 
> to be optimal.

Hello Justin,

what is your typical bonnie++ invocation, to test your configuration?
Which fields are meaningful for you from this benchmark?

Do you use anything else for benchmarks? 
eg: 'zcav /dev/sda > result' ?


I'm asking becuase I want to make some local benchmarks to determine
best chunk size in my HDD setup.

thanks in advance
-- 
Janek Kozicki                                                         |
