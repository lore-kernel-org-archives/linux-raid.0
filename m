From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 3/3] raid5: only wakeup necessary threads
Date: Tue, 30 Jul 2013 08:46:55 -0400
Message-ID: <20130730124655.GB2599@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055425.056034691@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130730055425.056034691@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Hello,

On Tue, Jul 30, 2013 at 01:52:10PM +0800, shli@kernel.org wrote:
> If there are no enough stripes to handle, we'd better now always queue all
> available work_structs. If one worker can only handle small or even none
> stripes, it will impact request merge and create lock contention.
> 
> With this patch, the number of work_struct running will depend on pending
> stripes number. Not some statistics info used in the patch are accessed without
> locking protection. Yhis should doesn't matter, we just try best to avoid queue
> unnecessary work_struct.

I haven't really followed the code but two general comments.

* Stacking drivers in general should always try to keep the bios
  passing through in the same order that they are received.  The order
  of bios is an important information to the io scheduler and io
  scheduling will suffer badly if the bios are shuffled by the
  stacking driver.  It'd probably be a good idea to have a mechanism
  to keep the issue order intact even when multiple workers are
  employed.

* While limiting the number of work_struct dynamically could be
  beneficial and it's upto Neil, it'd be nice if you can accompany it
  with some numbers so that whether such optimization actually is
  worthwhile or not can be decided.  The same goes for the whole
  series, I suppose.

Thanks.

-- 
tejun
