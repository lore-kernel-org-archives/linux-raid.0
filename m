From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/9] replace printk() with pr_*()
Date: Fri, 4 Nov 2016 14:36:48 -0700
Message-ID: <20161104213648.phh55ov534hkk6py@kernel.org>
References: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147805657658.23566.1748253447749986766.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2016 at 02:16:48PM +1100, Neil Brown wrote:
> This series removes all printk() calls from md code, preferring
> pr_warn(), pr_err() etc.
> 
> All strings that were split over multiple lines are not joined
> back together because being able to search for a message is more
> important that not having long lines in the code.
> Lots of printk(KERN_DEBUG... are not pr_debug() which means the
> messages won't get printed unless they are explicitly disabled.
> 
> I included some rough guidelines on which pr_* to choose in md.c.
> Many things became pr_debug(), most of the rest are pr_warn().
> pr_err() and pr_crit() are used sparingly.
> 
> I simplified some code in multipath.c too.
> 
> A particular benefit of this is that the various "print_conf()"
> functions are not silent by default.
> On very large arrays (raid10 with hundreds of devices), these can
> be very noisy.

Thanks for doing this, applied.
