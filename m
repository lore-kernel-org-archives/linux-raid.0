From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Wed, 9 Mar 2005 16:07:16 +1100
Message-ID: <16942.33924.232086.822210@cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
	<6jj0g2-c27.ln1@news.it.uc3m.es>
	<422DDA99.60608@steeleye.com>
	<9k91g2-vss.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Peter T. Breuer on Tuesday March 8
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 8, ptb@lab.it.uc3m.es wrote:
> 
> But I digress. My immediate problem is that writes must be queued
> first. I thought md traditionally did not queue requests, but instead
> used its own make_request substitute to dispatch incoming requests as
> they arrived.
> 
> Have you remodelled the md/raid1 make_request() fn?

Somewhat.  Write requests are queued, and raid1d submits them when
it is happy that all bitmap updates have been done.

There is no '1/100th' second or anything like that.
When a write request arrives, the queue is 'plugged', requests are
queued, and bits in the in-memory bitmap are set.
When the queue is unplugged (by the filesystem or timeout) the bitmap
changes (if any) are flushed to disk, then the queued requests are
submitted. 

Bits on disk are cleaned lazily.


Note that for many applications, the bitmap does not need to be huge.
4K is enough for 1 bit per 2-3 megabytes on many large drives.
Having to sync 3 meg when just one block might be out-of-sync may seem
like a waste, but it is heaps better than syncing 100Gig!!

If a resync without bitmap logging takes 1 hour, I suspect a resync
with a 4K bitmap would have a good chance of finishing in under 1
minute (Depending on locality of references).  That is good enough for
me.

Of course, if one mirror is on the other side of the country, and a
normal sync requires 5 days over ADSL, then you would have a strong
case for a finer grained bitmap.

> 
> And if so, do you also aggregate them? And what steps are taken to
> preserve write ordering constraints (do some overlying file systems
> still require these)?

filesystems have never had any write ordering constraints, except that
IO must not be processed before it is requested, nor after it has been
acknowledged.  md continue to obey these restraints.

NeilBrown
