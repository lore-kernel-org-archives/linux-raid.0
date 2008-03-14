From: Neil Brown <neilb@suse.de>
Subject: Re: sysfs Kernel BUG when RAID bitmap file has IO errors
Date: Fri, 14 Mar 2008 15:34:48 +1100
Message-ID: <18394.104.595461.995367@notabene.brown>
References: <47D7A502.6020701@wpkg.org>
	<47D7A7AA.8000302@wpkg.org>
	<20080312153618.b3e0612a.akpm@linux-foundation.org>
	<20080312154358.e9d16668.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Wednesday March 12
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mangoo@wpkg.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, balajirrao@gmail.com
List-Id: linux-raid.ids

On Wednesday March 12, akpm@linux-foundation.org wrote:
> On Wed, 12 Mar 2008 15:36:18 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I assume this is the BUG_ON(count >= (ssize_t)PAGE_SIZE) in
> > fill_read_buffer().

That's a new "BUG_ON".
Before commit 8118a859dc7abd873193986c77a8d9bdb877adc8
it was 
       BUG_ON(count > (ssize_t)PAGE_SIZE);

But I've been looking for an excuse to remove the "super" file from
sysfs for a while.
It doesn't really fit the sysfs model, and now clearly breaks it.  And
it isn't really all that useful (you can just read from the raw device
if you want to see the superblock.
It was a "seems like a good idea at the time" thing which I now
regret.

So:  I'll just remove it. (with apologies to anyone who actually uses
it, but I suspect there are only two of you :-)

Patch to follow

NeilBrown

