From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: raid1 error handling and faulty drives
Date: Fri, 07 Sep 2007 18:03:43 -0400
Message-ID: <22375.1189202623@mdt.ecitele.com>
References: <18143.36574.398690.36732@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Thu, 06 Sep 2007 06:23:42 BST."
             <18143.36574.398690.36732@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown writes:

> On Wednesday September 5, maccetta@laurelnetworks.com wrote:
> > ...
> > 
> > 2) It adds a threshold on the level of recent error acivity which is
> >    acceptable in a given interval, all configured through /sys.  If a
> >    mirror has generated more errors in this interval than the threshold,
> >    it is kicked out of the array.
> 
> This is probably a good idea.  It bothers me a little to require 2
> separate numbers in sysfs...
> 
> When we get a read error, we quiesce the device, the try to sort out
> the read errors, so we effectively handle them in batches.  Maybe we
> should just set a number of seconds, and if there are a 3 or more
> batches in that number of seconds, we kick the drive... just a thought.
> 

I think I was just trying to be as flexible as possible.  If we were to
use one number, I'd do the opposite and fix the interval but allow the
threshold to be configured just because I would tend to think about a
disk being bad in terms of it having a "more than" an expected number of
errors in some fixed interval rather than because it had a fixed number
of errors in "less than" some expected interval.  Mathematically the
approaches ought to be equivalent.

> > One would think that #2 should not be necessary as the raid1 retry
> > logic already attempts to rewrite and then reread bad sectors and fails
> > the drive if it cannot do both.  However, what we observe is that the
> > re-write step succeeds as does the re-read but the drive is really no
> > more healthy.  Maybe the re-read is not actually going out to the media
> > in this case due to some caching effect?
> 
> I have occasionally wondered if a cache would defeat this test.  I
> wonder if we can push a "FORCE MEDIA ACCESS" flag down with that
> read.  I'll ask.

I looked around for something like this but it doesn't appear to
be implemented that I could see.  I couldn't even find an explicit
mention of read caching in any drive specs to begin with.  Read-ahead
seems to be the closest concept.

> Thanks.  I agree that we do need something along these lines.  It
> might be a while before I can give the patch the brainspace it
> deserves as I am travelling this fortnight.

Looking forward to further discussion.  Thank you!
--
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
