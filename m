From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Mismatches
Date: Sun, 2 Jan 2011 19:10:38 -0600
Message-ID: <A3.34.13137.F02212D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	OK, I asked this question here before, and I got no answer
whatsoever.  I wasn't too concerned previously, but now that I lost the
entire array the last time I tried to do a growth, I am truly concerned.
Would someone please answer my question this time, and perhaps point me
toward a resolution?  The monthly array check just finished on my main
machine.  For many months, this happened at the first of the month and
completed without issue and with zero mismatches.  As of a couple of months
ago, it started to report large numbers of mismatches.  It just completed
this afternoon with the following:

RebuildFinished /dev/md0 mismatches found: 96614968

	Now, 96,000,000 mismatches would seem to be a matter of great
concern, if you ask me.  How can there be any, really, when the entire array
- all 11T - was re-written just a few weeks ago?  How can I find out what
the nature of these mismatches is, and how can I correct them without
destroying the data on the array?  How can I look to prevent them in the
future?  I take it the monthly checkarray routine (which basically
implements ` echo check > /sys/block/md0/md/sync_action`) does not attempt
to fix any errors it finds?

	I just recently found out md uses simple parity to try to maintain
the validity of the data.  I had always thought it was ECC.  With simple
parity it can be difficult or even impossible to tell which data member is
in error, given two conflicting members.  Where should I go from here?  Can
I use `echo repair > /sys/block/md0/md/sync_action` with impunity?  What,
exactly, will this do when it comes across a mismatch between one or more
members?

RAID6 array
mdadm - v2.6.7.2
kernel 2.6.26-2-amd64

