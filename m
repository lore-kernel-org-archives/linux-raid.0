From: Dan Christensen <jdc@uwo.ca>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 13:49:06 -0400
Message-ID: <87sk55mijx.fsf@uwo.ca>
References: <87k4qho723.fsf@uwo.ca>
	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk>
	<871vcpo0n6.fsf@uwo.ca> <4C069813.3010308@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Presumably something shows in the logs, that's the next place to look.

I believe my drives simply don't support adjusting the time it takes to
try to recover a read (CCTL).  Or did you mean the logs at the time of
failure?  If so, I posted those in the original message.

Have there been any kernel changes since 2.6.28 that might improve
reliability of my set-up?  It would be nice if md could be told to try
again before giving up on the drives.

Thanks for all of the help so far!

Dan

