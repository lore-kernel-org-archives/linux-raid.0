From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Good news / bad news - The joys of RAID
Date: Wed, 01 Dec 2004 11:50:37 +0000
Message-ID: <41ADB00D.7080709@robinbowes.com>
References: <200411192142.iAJLgRN12792@www.watkins-home.com>	 <41A9CF7E.4000804@robinbowes.com>	 <16811.54622.500830.508054@cse.unsw.edu.au> <1101872071.3815.135.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1101872071.3815.135.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> 
> If I recall correctly, this fixes the primary symptom, but not the whole
> problem.  When in --monitor mode, mdadm will reopen each device every 15
> seconds to scan its status.  As such, a shutdown could still fail if
> mdadm is still running and the timing is right.  In that instance,
> retrying the shutdown on failure would likely be enough to solve the
> problem, but that sounds icky to me.  Would be much better if mdadm
> could open a control device of some sort and query about running arrays
> instead of opening the arrays themselves.

Wouldn't simply killing the "mdadm --monitor" process early on in the 
shutdown process achieve the same result?

R.
-- 
http://robinbowes.com
