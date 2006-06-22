From: Neil Brown <neilb@suse.de>
Subject: Re: Can't get drives containing spare devices to spindown
Date: Thu, 22 Jun 2006 15:32:10 +1000
Message-ID: <17562.11098.977454.507277@cse.unsw.edu.au>
References: <446395C0.5060502@debruin.org>
	<449A2152.2040906@debruin.org>
	<17562.9479.533427.960138@cse.unsw.edu.au>
	<449A28FF.20504@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc L. de Bruin on Thursday June 22
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 22, marc@debruin.org wrote:
> >
> Thanks Neil for your quick reply. Would it be possible to elaborate a 
> bit on the problem and the solution? I guess I won't be on 2.6.18 for 
> some time...
> 

When an array has been idle (no writes) for a short time (20 or 200
ms, depending on which kernel you are running) the array is flagged as
'clean'. so that a crash/power failure at that point will not require
a full resync.  The 'clean' flag is stored on all superblocks,
including the spares.  So this causes writes to all devices when there
is changes to activity status.

Even fairly quite filesystems see occasional updates (updating atime
on files, or such syncing the journal), and that causes all devices to
be touched.

Fix
 1/ don't set the 'dirty' flag on spares - there really is no need.

However whenever the dirty bit is changed, the 'events' count is
updated, so just doing the above will cause the spares to get way
behind the main devices in their 'events' count so they will no longer
be treated as part of the array.  So

 2/ When clearing the dirty flag (and nothing else has happened),
   decrement the events count rather than increment it.

Together, these mean that simple dirty/clean transitions do not touch
the spares.

NeilBrown
