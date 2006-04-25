From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 1/2] raid6_end_write_request() spinlock fix
Date: Tue, 25 Apr 2006 16:50:10 +1000
Message-ID: <17485.50850.9186.130696@cse.unsw.edu.au>
References: <20060425033542.GA4087@localhost.localdomain>
	<17485.45069.692725.551853@cse.unsw.edu.au>
	<20060425064310.GA29950@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Coywolf Qi Hunt on Tuesday April 25
Sender: linux-raid-owner@vger.kernel.org
To: Coywolf Qi Hunt <qiyong@fc-cn.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 25, qiyong@fc-cn.com wrote:
> On Tue, Apr 25, 2006 at 03:13:49PM +1000, Neil Brown wrote:
> > On Tuesday April 25, qiyong@fc-cn.com wrote:
> > > Hello,
> > > 
> > > Reduce the raid6_end_write_request() spinlock window.
> > 
> > Andrew: please don't include these in -mm.  This one and the
> > corresponding raid5 are wrong, and I'm not sure yet the unplug_device
> > changes.
> 
> I am sure with the unplug_device. Just look follow the path...
> 

What path?  There are probably several.  If I follow the path, will I
see the same things as you see?  Who knows, because you haven't
bothered to tell us what you see.

> 
> Yes. Let's fix the error(). In any case, the current code is broken. (see raid5/6_end_read_request)

What will I see in raidX_end_read_request.  Surely it isn't that hard
to write a few more sentences?


> Comments? Thanks.

conf->working_disks isn't atomic_t and so decrementing without a
spinlock isn't safe.  So lets just leave it all inside a spinlock.

Also I have a vague memory that clearing In_sync before Faulty is
important, but I'm not certain of that.

Remember: the code is there for a reason.  It might not be a good
reason, and the code could well be wrong.  But it would be worth your
effort trying to find out what the reason is before blithely changing
it (as I discovered recently with a change I suggested to
invalidate_mapping_pages).

NeilBrown
