From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 9 Dec 2004 00:21:09 +0000 (UTC)
Message-ID: <cp85pl$ds5$1@terminus.zytor.com>
References: <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk>
By author:    "A. James Lewis" <james@fsck.co.uk>
In newsgroup: linux.dev.raid
> 
> I'd like to put raid6 to use, and after reading through the process of
> tracking down this bug, it seems that a rational explanation was found for
> the data corruption, and the fix well tested... but being new to a lot of
> the process here, what is the process for this to get into the standard
> kernel... perhaps 2.6.10 will have this patch??
> 
> Obviously I could apply the patch to raid6main.c on my system, but it
> would be  good to use a standard kernel...
> 
> The problem is only when writing to a degraded array, but most of us are
> impatient and want to write a filesystem and get it mounted before the
> first sync is complete... and those, like me cursed with bad hardware will
> have 2 drives fail at the same time (last week!) and hence raid6 is very
> appealing :).
> 

Hi James,

This patch got integrated in, I believe, 2.6.10-rc2.

Please let me know what your experience is.  It would be good to get
the EXPERIMENTAL tag taken off at some point.

	-hpa
