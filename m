From: Neil Brown <neilb@suse.de>
Subject: Re: Stripe dirty bitmap
Date: Mon, 5 Jul 2010 11:02:03 +1000
Message-ID: <20100705110203.01502ac1@notabene.brown>
References: <4C3126C0.4050709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C3126C0.4050709@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 04 Jul 2010 20:26:40 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Sure would be nice to have md track whole never written stripes, so 
> creating an array didn't have to be done over a three day weekend. When 
> any part of a virgin stripe was written it could then be initialized 
> properly, and when a virgin stripe was read zeros could be returned 
> without disk i/o. It doesn't matter that the reads are done in parallel, 
> with modern disk the bus is the bottleneck. With eSATA arrays the bus is 
> slow to start with, passing TB through it should be avoided if possible.
> 

Sure would.

NeilBrown
