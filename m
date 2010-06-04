From: Dan Christensen <jdc@uwo.ca>
Subject: Re: devices get kicked from RAID about once a month
Date: Fri, 04 Jun 2010 11:56:55 -0400
Message-ID: <87zkzalrjs.fsf@uwo.ca>
References: <628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk>
	<871vcpo0n6.fsf@uwo.ca> <4C069813.3010308@tmr.com>
	<87sk55mijx.fsf@uwo.ca> <4C07DA4E.70501@tmr.com>
	<87eigom5as.fsf@uwo.ca> <20100604073304.1d669f45@notabene.brown>
	<874ohjlyce.fsf@uwo.ca>
	<20100604135031.GA5092@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill <robin@robinhill.me.uk> writes:

> On Fri Jun 04, 2010 at 09:30:09AM -0400, Dan Christensen wrote:
>
>> what would the raid layer do when it got a read error? 
>> 
> It reconstructs the data and attempts a write.  A write failure will
> then fail the drive.
[...]
> It does exactly the same on the read timeout.  The problem is that when
> it sends the write, the drive is still busy attempting the read, so
> ignores the write request (until it's free).  This then times out as
> well, so the array assumes the drive has failed.
>
>> These questions are motivated from the following logic.  Since it is
>> generally recognized that quicker read errors (e.g. TLER) are good
>> for drives in a raid array, *increasing* the SATA timeouts seems like it
>> is going in the wrong direction.  Wouldn't it be better to have short
>> timeouts, but have the raid layer treat a timeout less seriously?
>> 
> As has been stated, the RAID layer doesn't have any timeouts.  It's the
> SCSI/ATA layer which is timing out the read/write and reporting a
> failure to the RAID layer.  If the timeout at this level is increased
> sufficiently then either the read will eventually succeed, or it'll
> still fail but the write will then succeed (as the drive is no longer
> busy) (or the write will fail and the disk is really failed).

Ok, I now understand the idea here.  Even if the SATA timeout were
reduced, there's nothing the raid layer can do until the drive is
ready to respond again.  So it makes sense to work around this by
increasing the SATA timeouts.

Thanks for the clarification!

Dan

