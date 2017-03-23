From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] percpu-refcount: support synchronous switch to atomic
 mode.
Date: Wed, 22 Mar 2017 19:20:20 -0700
Message-ID: <20170323022020.buq4us3lvp2jbyes@kernel.org>
References: <87o9wuaxm3.fsf@notabene.neil.brown.name>
 <20170322150029.GA7532@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170322150029.GA7532@htj.duckdns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.com>, Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 22, 2017 at 11:00:29AM -0400, Tejun Heo wrote:
> On Wed, Mar 22, 2017 at 12:50:12PM +1100, NeilBrown wrote:
> > 
> > percpu_ref_switch_to_atomic_sync() schedules the switch
> > to atomic mode, then waits for it to complete.
> > 
> > Also export percpu_ref_switch_to_* so they can be used from modules.
> > 
> > This will be used in md/raid to count the number of pending write
> > requests to an array.
> > We occasionally need to check if the count is zero, but most often
> > we don't care.
> > We always want updates to the counter to be fast, as in some cases
> > we count every 4K page.
> > 
> > Signed-off-by: NeilBrown <neilb@suse.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Please feel free to route through other patches through md tree.  If
> preferable, I can route it through percpu/for-4.12.

Thanks, Tejun. I applied it to md tree, that will avoid a lot of troubles.

Thanks,
Shaohua
