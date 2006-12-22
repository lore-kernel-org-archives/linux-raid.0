From: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Subject: Re: [patch] latency problem in md driver
Date: Fri, 22 Dec 2006 16:40:18 +0100
Message-ID: <20061222154017.GA8199@soda.linbit>
References: <20061222143215.GD7477@soda.linbit> <458BF799.6010703@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <458BF799.6010703@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

/ 2006-12-22 10:19:53 -0500
\ Jeff Garzik:
> Lars Ellenberg wrote:
> >md raidX make_request functions strip off the BIO_RW_SYNC flag,
> >this introducing additional latency.
> >below is a suggested patch for the raid1.c .
> >other suggested solutions would be to let the bio_clone do its work,
> >and not reassign thereby stripping off all flags.
> >at most strip off known unwanted flags (the BARRIER flag).
> 
> It sounds like a major bug to strip the barrier flag.  I quite understand that a barrier to a RAID device as a 
> whole behaves differently from a barrier to an ATA or SCSI device, but that's no excuse to avoid the problem.

sorry for being ambiguous.

this is not about the BARRIER flag.
this is about the BIO_RW_SYNC flag.

> If MD does not pass barriers, it is unilaterally dropping the "data made it to the media" guarantee.

MD _does_ pass barriers, unless one of the managed devices reported
EOPNOTSUPP, in which case this is solved differently (reporting EOPNOTSUPP
itself).

the issue at hand is:
because md does special case the barrier bit, it strips off everything
else by re-assigning only the io direction and the barrier bit.

 ==> I'd like it to also pass at least the sync bit.

I think the better solution would be to _not_ re-assign bi_rw after
bio_clone, and then special case every other bit, but to only strip
off unwanted bits, if at all.
barrier bit was a bad example, because it either is not set,
or gets passed, or is errored as EOPNOTSUPP first thing.

	Lars

-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
