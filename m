From: Neil Brown <neilb@suse.de>
Subject: Re: Mismatches
Date: Mon, 3 Jan 2011 12:35:35 +1100
Message-ID: <20110103123535.4eda6f6f@notabene.brown>
References: <A3.34.13137.F02212D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A3.34.13137.F02212D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2 Jan 2011 19:10:38 -0600 "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 
> 	OK, I asked this question here before, and I got no answer
> whatsoever.  I wasn't too concerned previously, but now that I lost the
> entire array the last time I tried to do a growth, I am truly concerned.
> Would someone please answer my question this time, and perhaps point me
> toward a resolution?  The monthly array check just finished on my main
> machine.  For many months, this happened at the first of the month and
> completed without issue and with zero mismatches.  As of a couple of months
> ago, it started to report large numbers of mismatches.  It just completed
> this afternoon with the following:
> 
> RebuildFinished /dev/md0 mismatches found: 96614968
> 
> 	Now, 96,000,000 mismatches would seem to be a matter of great
> concern, if you ask me.  How can there be any, really, when the entire array
> - all 11T - was re-written just a few weeks ago?  How can I find out what
> the nature of these mismatches is, and how can I correct them without
> destroying the data on the array?  How can I look to prevent them in the
> future?  I take it the monthly checkarray routine (which basically
> implements ` echo check > /sys/block/md0/md/sync_action`) does not attempt
> to fix any errors it finds?
> 
> 	I just recently found out md uses simple parity to try to maintain
> the validity of the data.  I had always thought it was ECC.  With simple
> parity it can be difficult or even impossible to tell which data member is
> in error, given two conflicting members.  Where should I go from here?  Can
> I use `echo repair > /sys/block/md0/md/sync_action` with impunity?  What,
> exactly, will this do when it comes across a mismatch between one or more
> members?
> 
> RAID6 array
> mdadm - v2.6.7.2
> kernel 2.6.26-2-amd64
> 

96,000,000 is certainly a big number.  It seems to suggest that one of your
devices is returning a lot of bad data to reads.
If this is true, you would expect to get corrupt data when you read from the
array.  Do you?  Does 'fsck' find any problems?

The problem could be in a drive, or in a cable or in a controller.  It is
hard to know which.
I would recommend not writing to the array until you have isolated the
problem as writing can just propagate errors.

Possibly:
  shut down array
  compute the sha1sum of each device
  compute the sha1sum again

If there is any difference, you are closer to the error
If every device reports the same sha1sum, both times, then it is presumably
just one device which has consistent errors.

I would then try assembling the array with all-but-one-drive (use a bitmap so
you can add/remove devices without triggering a recovery) and do a 'check'
for each config and hope that one config (i.e. with one particular device
missing) reports no mismatches.  That would point to the missing device being
the problem.

'check' does not correct any mismatches it finds, though if it hits a read
error it will try to correct that.

RAID6 can sometimes determine which device is in error, but that has not been
implemented in md/raid6 yet.

I wouldn't use 'repair' as that could hide the errors rather than fixing
them, and there would be no way back.  When it comes across a mismatch it
generates the Parity and the Q block from the data and writes them out.  If
the P or Q block were wrong, this is a good fix.  If one data block was
wrong, this is bad.

NeilBrown
