From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 16:55:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407072055.i67Kti309497@watkins-home.com>
References: <2446.66.230.1.97.1089232643.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2446.66.230.1.97.1089232643.squirrel@exitwound.org>
To: stephen@exitwound.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That would be fine.  But we don't yet know which disk was trashed by the
re-build.  But as long as you have 1 missing disk it will not rebuild over
any more data.
If your command does not work try again with a different missing disk.

-----Original Message-----
From: Stephen Hargrove [mailto:stephen@exitwound.org] 
Sent: Wednesday, July 07, 2004 4:37 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Should I Start Over?

Guy said:
> Humm.  I would guess it would re-build to the last disk on the command
> line.
> Maybe just enter the command again.  Can't do any more damage!  Then do
> the
> 2 commands and send the output.

Ok, I want to be perfectly clear on this.  I'm going to enter the
following command, right?

# mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/hdg1 /dev/hdd1
missing

> Did the original array have 3 disks and 1 spare?  If so, ignore the spare
> until things are working again.

Yes.  /dev/hde1 was the spare.  The array was comprised of /dev/hdg1,
/dev/hdd1, and /dev/hdc1.

--
Steve

