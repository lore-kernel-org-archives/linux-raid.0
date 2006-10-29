From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 0 breakage (maybe)
Date: Mon, 30 Oct 2006 10:18:18 +1100
Message-ID: <17733.14010.849986.403732@cse.unsw.edu.au>
References: <1162163175.17928.14.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matt Thrailkill on Sunday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Matt Thrailkill <matt@modestolan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 29, matt@modestolan.com wrote:
> Actually I kind of fixed it last night.  I found a posting by someone
> on an older Ubuntu release with a similar problem, and he resolved it
> by making loopback devices pointing at his constituent drives, and then
> assembled the array using those.  That works for me also, so the array
> is running now.. but off of loopback devices instead of the direct raw
> disks.  Before I did that, proc/mdstat was empty.  I just now looked in
> /sys/block/hde/holders, but I don't know how to read it.

Using loop-back doesn't sound like a good long-term solution.
Maybe if you should us
   ls -la /sys/block/hde/holders
we can interpret it for you....

NeilBrown
