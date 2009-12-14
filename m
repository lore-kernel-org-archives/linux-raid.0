From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/1] md: expose behind writes counter
Date: Tue, 15 Dec 2009 08:32:09 +1100
Message-ID: <20091215083209.1ea23291@notabene.brown>
References: <4B266E40.4080202@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B266E40.4080202@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 14 Dec 2009 11:56:32 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> This is a very simple patch that exposes the behind_writes counter of an 
> md array via a sysfs entry. This is helpful when tuning the value of 
> behind_writes. Knowing, for instance, the maximum value over time allows 
> one to set a proper upper value for an array.
>

Hi Paul,
 while I can see that this information could be useful, I wonder if this is
 the best way of accessing it.
 I imagine that the count of behind_writes would change quite quickly, so you
 would need to sample it at quite a high rate to get a meaningful number.

 I'm very conscious that the 'active_stripes' number provided by RAID5 is
 close to useful as it almost always reads a 'zero' even when the array is
 quite busy.

 Maybe having a sysfs attribute that reports the maximum value, and allow
 that maximum to be reset by writing to the attribute?

 Or possibly a counter reporting the number of requests that were not
 treated as 'write_behind' because the max had been reached.  Then you could
 increase the max_write_behind until the counter stopped increasing - or it's
 rate of increase dropped to an acceptable level.

 Does any of that work for you?

NeilBrown
