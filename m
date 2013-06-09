From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: RAID1 growth of version 1.1/1.2 metadata violates least surprise.
Date: Sun, 9 Jun 2013 09:33:05 -0500
Message-ID: <201306091433.r59EX51u021372@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi, hope the week is starting out well for everyone.

We ran into an interesting issue secondary to the growth of a RAID1
volume with version 1.1 metadata.  We are interested in reflections
from Neil and/or others as to whether the problem can be addressed.

We grew a RAID1 mirror which had its two individual legs provided by
SAN volumes from an SCST based target server.  We provisioned
additional storage on the targets and then updated the advertised size
of the two block devices.

Following that we carried out a rescan of the block devices on the
initiator and then used mdadm to 'grow' the size of the RAID1 mirror.
That was about 4-5 months ago and we ended up running into issues when
the machine was just recently rebooted.

The RAID1 mirror refused to assemble secondary to the superblocks on
the individual devices having a different idea of the volume size as
compared to the actual volume size.  The mdadm manpage makes reference
to this problem in the section on the '-U' (update) functionality.

It would seem to violate the notion of 'least surprise' for a grow
command to work only to end up with a device which would not assemble
without external intervention at some distant time in the future.  It
isn't uncommon to have systems up for a year or more which tends to
result in this issue being overlooked on systems which have been
resized.

I'm assuming there is no technical reason why the superblocks on the
individual devices cannot be updated as part of the grow.  Events such
as adding/removing persistent bitmaps suggest this is a possibility.
If its an issue of needing code we could investigate doing the
legwork since it is an issue we would like to see addressed.

This behavior was experienced on a largely stock RHEL5 box with the
following versions:

	Kernel: 2.6.18-348.6.1.el5
	mdadm:	v2.6.9

Obviously running Oracle.... :-)

Any thoughts/suggestions would be appreciated.

Have a good week.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Have you got your computer switched on?  Are you sure you've got all
 the latest patches?
                                -- Microsoft Technical Support

"Of course, you idiot!  Just put me through to someone who knows what
 they're doing."
                                -- Andrew Tridgell
