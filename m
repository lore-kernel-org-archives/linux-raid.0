From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Good news / bad news - The joys of RAID
Date: Tue, 30 Nov 2004 13:05:18 +1100
Message-ID: <16811.54622.500830.508054@cse.unsw.edu.au>
References: <200411192142.iAJLgRN12792@www.watkins-home.com>
	<41A9CF7E.4000804@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robin Bowes on Sunday November 28
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 28, robin-lists@robinbowes.com wrote:
> Guy wrote:
> > I use mdadm's monitor mode to send me email when events occur.
> 
> Guy,
> 
> I've been meaning to write this for a while...
> 
> I tried monitoring once but had a problem when shutting down as the 
> arrays were reported as "busy" because mdadm --monitor was running on 
> them. I guess it needs to be killed earlier in the shutdown process.

That bug was fixed in mdadm 1.6.0

NeilBrown


 From the ChangeLog:
Changes Prior to 1.6.0 release
...
    -   Fix bug in --monitor where an array could be held open and so
	could not be stopped without killing mdadm.
...

