From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: When does RAID synchronization status update?
Date: Tue, 26 Feb 2013 12:15:49 -0600
Message-ID: <201302261815.r1QIFnDb015519@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning, hope the week is going well for everyone.

We've noted an issue which spans several kernel releases which I
wanted to bounce off the group collective.  We are currently observing
the issue all the way from 2.6.32 to 3.4.x so if it is a legitimate
problem it has been around for a long time.

In our spare time we've been working on putting together the mythical
'incremental scrubber' which Neil has been talking about for a long
time.  A utility which will start a 'check' run on an MD device and
then capture the completion state after a pre-determined amount of
time so the scrub can be halted and then re-started during the next
evening's session.

When a synchronization or check run of an MD device starts the status
of the check which is found in the following pseudo-file:

	/sys/block/mdN/md/sync_completed

Seems to stall and only update at intermittent times while the
/proc/mdstat pseudo-file provides continuous updates.

I'm currently watching a 2.6.32.24 machine which had a RAID5
synchronization started about 25 minutes ago.  The contents of the
/proc/mdstat pseudo-file indicate its 6% completed while the
/sys/block/mdN/md/sync_completed file for the device has yet to move
from zero.

I'm also watching a RAID5 synchronization on a 3.4.10 kernel and while
/proc/mdstat is continuously updating the
/sys/block/mdN/md/sync_completed file hasn't budged in about a half
hour.

As I was writing this I just noticed on the 2.6.32.24 machine the
contents of the /sys/block/mdN/md/sync_completed file moved, in one
swoop, from:

	0 / 1463746176

To:

	91484144 / 1463746176

With respect to providing status information for the re-start of a
check scrub the behavior seems to be anomolous.

Would be interested in experience from others or reflections from Neil.

Have a good afternoon.

Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"A distributed system is one on which I cannot get any work done because 
 a machine I have never heard of has crashed."
                                -- Leslie Lamport
