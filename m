From: Peter Landmann <sfrazt@googlemail.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 21:29:30 +0000 (UTC)
Message-ID: <loom.20130403T232551-938@post.gmane.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <515C73B3.5060704@arcor.de> <loom.20130403T223431-541@post.gmane.org> <515C9E05.9070300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If you're running the tests for multiple minutes and many tens of GBs at
> a time, then this slowdown is due to garbage collection, not stripe
> cache sizing.

You are right. I wrote about that in another post.
> 
> You are not performing proper testing methodologies, and you're jumping
> to conclusions way too quickly, and likely incorrectly.

See above.
> 
> If you're not familiar with SSD garbage collection then you must learn
> about it.  It will affect everything you do with SSDs, especially when
> doing these kinds of tests where you're writing huge amounts of data to
> the flash cells.  Wear leveling, part of garbage collection,
> dramatically slows down SSD throughput.  And when you're pushing this
> much data, TRIM won't help.  It'll actually slow the SDDs down even more.

In a shortage of time i was to fast .. I'm sorry for the trouble but at least 
some people and i could learn something about md :)

Peter



