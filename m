From: Dan Christensen <jdc@uwo.ca>
Subject: Re: devices get kicked from RAID about once a month
Date: Fri, 04 Jun 2010 09:30:09 -0400
Message-ID: <874ohjlyce.fsf@uwo.ca>
References: <87k4qho723.fsf@uwo.ca>
	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk>
	<871vcpo0n6.fsf@uwo.ca> <4C069813.3010308@tmr.com>
	<87sk55mijx.fsf@uwo.ca> <4C07DA4E.70501@tmr.com>
	<87eigom5as.fsf@uwo.ca> <20100604073304.1d669f45@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Thu, 03 Jun 2010 12:47:39 -0400 Dan Christensen <jdc@uwo.ca> wrote:
>
>> That could be useful.  And, as Neil said, if the SATA driver could be
>> told to use longer timeouts, that might help.  Neil, if you think that's
>> a good idea, maybe you could put the request in with the SATA folks?
>
> It might be a good idea.

After thinking about it more, I'm not sure I fully understand the
situation.  

If I was able to turn on something like TLER on the drives, so read
errors failed more quickly, what would the raid layer do when it got
a read error? 

If the raid layer handles this in a clever way (and I recall some
discussions about this), e.g. by reconstructing the data and rewriting
the sector allowing the drive to remap it, then what I don't fully
understand is why it doesn't also do this when there is a timeout on a
read.  Is it because timeouts can indicate more serious problems?  Even
so, wouldn't it be reasonable for the raid layer to give the drive a
second chance before assuming it has failed?

These questions are motivated from the following logic.  Since it is
generally recognized that quicker read errors (e.g. TLER) are good
for drives in a raid array, *increasing* the SATA timeouts seems like it
is going in the wrong direction.  Wouldn't it be better to have short
timeouts, but have the raid layer treat a timeout less seriously?

Dan

