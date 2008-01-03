From: Neil Brown <neilb@suse.de>
Subject: Re: stopped array, but /sys/block/mdN still exists.
Date: Fri, 4 Jan 2008 08:32:50 +1100
Message-ID: <18301.21634.336162.394199@notabene.brown>
References: <cccedfc60801021315l63b2123du3b1267ebd51cc633@mail.gmail.com>
	<18300.26657.7543.315722@notabene.brown>
	<477D3D76.3000803@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday January 3
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 3, davidsen@tmr.com wrote:
> 
> So what happens if I try to _use_ that /sys entry? For instance run a 
> script which reads data, or sets the stripe_cache_size higher, or 
> whatever? Do I get back status, ignored, or system issues?

Try it:-)

The stripe_cache_size attributes will disappear (it is easy to remove
attributes, and stripe_cache_size is only meaningful for certain raid
levels).
Other attributes will return 0 or some equivalent, though I think
chunk_size will have the old value.

NeilBrown

