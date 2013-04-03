From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 03 Apr 2013 16:24:21 -0500
Message-ID: <515C9E05.9070300@hardwarefreak.com>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <515C73B3.5060704@arcor.de> <loom.20130403T223431-541@post.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130403T223431-541@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Landmann <sfrazt@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/3/2013 3:36 PM, Peter Landmann wrote:

> I'm very sorry but now i can't confirm anymore that stripe_cache_size helps.
> 
> My test was to short. With every minute the IOPS decrease. So 
> stripe_cache_size does only help for very short tests. 

If you're running the tests for multiple minutes and many tens of GBs at
a time, then this slowdown is due to garbage collection, not stripe
cache sizing.

You are not performing proper testing methodologies, and you're jumping
to conclusions way too quickly, and likely incorrectly.

If you're not familiar with SSD garbage collection then you must learn
about it.  It will affect everything you do with SSDs, especially when
doing these kinds of tests where you're writing huge amounts of data to
the flash cells.  Wear leveling, part of garbage collection,
dramatically slows down SSD throughput.  And when you're pushing this
much data, TRIM won't help.  It'll actually slow the SDDs down even more.

-- 
Stan


