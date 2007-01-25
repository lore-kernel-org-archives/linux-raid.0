From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
Date: Thu, 25 Jan 2007 11:36:01 +1100
Message-ID: <45B7FB71.5030603@yahoo.com.au>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122115703.97ed54f3.akpm@osdl.org> <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933149AbXAYAgo@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701241909120.2930@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> On Mon, 22 Jan 2007, Andrew Morton wrote:

>>After the oom-killing, please see if you can free up the ZONE_NORMAL memory
>>via a few `echo 3 > /proc/sys/vm/drop_caches' commands.  See if you can
>>work out what happened to the missing couple-of-hundred MB from
>>ZONE_NORMAL.
>>
> 
> Running with PREEMPT OFF lets me copy the file!!  The machine LAGS 
> occasionally every 5-30-60 seconds or so VERY BADLY, talking 5-10 seconds 
> of lag, but hey, it does not crash!! I will boot the older kernel with 
> preempt on and see if I can get you that information you requested.

It wouldn't be a bad idea to recompile the new kernel with preempt on
and get the info from there.

It is usually best to be working with the most recent kernels. We can
always backport any important fixes if we need to.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
