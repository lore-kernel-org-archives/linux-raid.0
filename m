From: greg@wind.enjellic.com (Dr. Greg Wettstein)
Subject: Anyone clueful on forcing 3ware drive discovery?
Date: Thu, 8 Sep 2005 14:14:32 -0500
Message-ID: <200509081914.j88JEWgr008704@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon, I hope the day is going well for everyone.

We are using a number of 3Ware 75xx and 8xxx controller cards to build
high capacity storage solutions on top of Linux with commodity drives.
We use the cards in JBOD mode and build software RAID5 on top of the
individual disks.  As a result we have reasonably good field
experience with the typical problems everyone faces with bad block
remapping et. al, double-faulted drives etc.

Last week we had a 7508 kick a drive on an AEN, presumably tripped by
a SMART event on the drive.  After the error the controller disavowed
all knowledge of the drive and we had to power cycle the machine to
get the controller card to recognize the drive.

The smartctl utility reported the drive as HEALTHY.  We ran a short
SMART test on the drive which passed.  We then ran a long test which
passed.  We re-wrote the entire drive with dd after which we ran
another long test which passed.  All this convinced us it was safe to
stick the drive back into the RAID5 volume.  Parity reconstruction was
successful and things have been fine since.

My question for the cumulative wisdom of the list is over whether or
not anyone knows how to force a rediscovery of a 'failed' drive by the
3Ware controller.  I'm not sure if a bad block read forced this event
but if it did it seems problematic to have the drive permanently
kicked thus forcing a power cycle.

We haven't had to deal with the problem on our SATA platforms yet but
this is potentially a big issue for our 8xxx implementations which
have SATA drives in hot-swap caddies.  The utility of this hardware is
minimal if there is no mechanism to get the controller to
're-discover' the drive.

I'm sending this note to the list after a bit of frustration with the
3ware trouble reporting and support system.  The entire system is a
bit cumbersome and obviously not geared towards high level support.
Perhaps another reason to begin considering the Areca cards everyone
is talking about...

Thanks much for any pointers or suggestions.

Best wishes for a productive week to everyone.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Extensive interviews show that not one alcoholic has ever actually seen
a pink elephant."
                                -- Yale University
                                   Center of Alcohol Studies
