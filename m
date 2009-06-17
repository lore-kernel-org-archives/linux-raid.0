From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: Raid0 Reshape . Preface
Date: Thu, 18 Jun 2009 08:31:25 +1000
Message-ID: <19001.28349.151553.26110@notabene.brown>
References: <1245189072.3478.92.camel@raz>
	<19000.55700.831349.967378@notabene.brown>
	<51950.194.105.184.77.1245241039.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Robinson on Wednesday June 17
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 17, john.robinson@anonymous.org.uk wrote:
> On Wed, June 17, 2009 12:55 pm, Neil Brown wrote:
> >  The more I think about it, the more I feel I would prefer to use the
> >  raid5 module for all restriping.
> 
> That doesn't make sense to me, for various reasons including those for
> having separate RAID personality modules in the first place. On the other
> hand, if you're keeping the raid0 module simple, perhaps the raid5 module
> could also be simplified and all objectives could be served by shipping
> out all restriping to a new, separate restriping module? Or even to
> userspace?

The enhancements needed to raid5 to make is able to handle reshaping a
raid0 are either minor, or are ones that we want eventually any way.
Given that, there seems little point implementing the same thing in
two different ways.

I have occasionally thought that it would be nice if all the "Reshape"
code could be separated out of raid5 as it is not used very often.
However I suspect that you would find that it isn't very much code as
it shares a lot with resync and normal raid5 processing.

Striping it out into user-space is also tempting.  The tricky bit
would be deciding on the interface - exactly how much to leave in the
kernel and how much to takeout.  It might be an interesting exercise.
It's hard to know if it would be productive or not.

NeilBrown
