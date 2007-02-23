From: "Colin Simpson" <csimpson@csl.co.uk>
Subject: Linux Software RAID a bit of a weakness?
Date: Fri, 23 Feb 2007 19:19:38 +0000
Message-ID: <1172258378.21648.51.camel@cowie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

We had a small server here that was configured with a RAID 1 mirror,
using two IDE disks. 

Last week one of the drives failed in this. So we replaced the drive and
set the array to rebuild. The "good" disk then found a bad block and the
mirror failed.

Now I presume that the "good" disk must have had an underlying bad block
in either unallocated space or a file I never access. Now as RAID works
at the block level you only ever see this on an array rebuild when it's
often catastrophic. Is this a bit of a flaw? 

I know there is the definite probability of two drives failing within a
short period of time. But this is a bit different as it's the
probability of two drives failing but over a much larger time scale if
one of the flaws is hidden in unallocated space (maybe a dirt particle
finds it's way onto the surface or something). This would make RAID buy
you a lot less in reliability, I'd have thought. 

I seem to remember seeing in the log file for a Dell perc something
about scavenging for bad blocks. Do hardware RAID systems have a
mechanism that at times of low activity search the disks for bad blocks
to help guard against this sort of failure (so a disk error is reported
early)?

On Software RAID, I was thinking apart from a three way mirror, which I
don't think is at present supported. Is there any merit in say, cat'ing
the whole disk devices to /dev/null every so often to check that the
whole surface is readable (I presume just reading the raw device won't
upset thing, don't worry I don't plan on trying it on a production
system). 

Any thoughts? As I presume people have thought of this before and I must
be missing something.

Colin


This email and any files transmitted with it are confidential and are intended solely for the use of the individual or entity to whom they are addressed.  If you are not the original recipient or the person responsible for delivering the email to the intended recipient, be advised that you have received this email in error, and that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. If you received this email in error, please immediately notify the sender and delete the original.


