From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Md cache?
Date: Thu, 3 Jun 2004 12:10:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16574.34981.255417.263054@cse.unsw.edu.au>
References: <8125762.1086227309322.JavaMail.root@wamui05.slb.atl.earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brian Pontius on Wednesday June 2
To: Brian Pontius <linuxboy123@mindspring.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 2, linuxboy123@mindspring.com wrote:
> to all,
> 
> Is anyone aware of a way to cause the md devices to use some system memory as a write cache? (maybe through mdadm?).  I have looked everywhere and cannot seem to find anything about such a feature.
> 
> If not, anyone  know if this is a possibility for the future, Neil?

What is it exactly that you want.

All device IO is cached in memory before being written to the device.
The only real value of a cache with a RAID array is if it we a
non-volatile cache.  Is that what you were thinking of.

NeilBrown
