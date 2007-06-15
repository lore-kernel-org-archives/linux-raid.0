From: Neil Brown <neilb@suse.de>
Subject: Re: raid5: coding style cleanup / refactor
Date: Sat, 16 Jun 2007 08:39:34 +1000
Message-ID: <18035.5414.680663.405523@notabene.brown>
References: <1181670063.12913.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday June 12
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry for not getting to this soon...

On Tuesday June 12, dan.j.williams@intel.com wrote:
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Most of the raid5 code predates git so the coding style violations have
> been present for a long time.  However, now that major new patches are
> arriving, checkpatch.pl complains about these old violations.  Instead of
> attempting to justify the warnings as "this is what raid5 used to do", this
> patch brings the code in line with the current style.

I general I would rather just fix things as they break.  i.e. when you
change a line that violates the style, fix it then.
And some of the changes you make, I don't like.  e.g. Everything
inside parentheses should be to the right of the opening parenthesis.

> 
> Note that this is more than a simple reformatting.  The majority of the
> 80-column violations were in the handle_stripe5 and handle_stripe6
> routines.  By introducing the 'stripe_head_state' and 'r6_state' objects
> large portions of the logic could be moved to sub-routines, reclaiming a
> column's worth of indentation.

This refactoring, however, is a good idea.  We have some very deep
functions in there and breaking them out is a good idea.  So a patch
that just does this would be very welcome.

> 
> 'stripe_head_state' consumes all of the automatic variables that previously
> stood alone in handle_stripe.  'r6_state' contains the handle_stripe6
> specific variables like p_failed and q_failed.  
> 
> One of the nice side effects of the 'stripe_head_state' change is that it
> allows for further reductions in code duplication between raid5 and raid6
> (note: unfortunately the other 80-column violations hide the code
> duplication-removal effect in the diffstat).  The following new routines
> are shared between raid5 and raid6:
> 
> 	handle_completed_write_requests
> 	handle_requests_to_failed_array
> 	handle_stripe_expansion
> 
> Trivia:
> * PRINTK and RAID5_DEBUG is replaced with pr_debug

Good idea...  Am I asking too much to have separate things in separate
patches?  It makes review easier.

> * struct field comments moved to the top (kernel-doc format)

I guess...  though moving the documentation away from the code means
that it is less likely to be kept up-to-date.

NeilBrown
