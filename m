From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 23:16:45 -0500
Message-ID: <200412030416.iB34Go913239@www.watkins-home.com>
References: <Pine.LNX.4.44.0412022229420.23412-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412022229420.23412-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'TJ' <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The ECC is not the low level data.  The servo tracks are.  I bet there are
start of track/sector header marks also.  I believe a low level format will
not re-write the servo tracks.  Some drives reserve 1 side of 1 platter for
servo data.  Others mix the servo data with user data.  I don't know the
full details, just tidbit I have read over the years.

If your drives were cooled better than most, that may explain why you did
not have the "substrate had heat expansion issues".  Just a guess.

If the problem was a firmware issue, why didn't IBM release a firmware
update?

You said:
"the firmware theory is supported by the fact that many deathstars 
performed perfectly well for many years"

Are you saying some drives had good firmware, while others had bad firmware?
Otherwise, I don't understand your logic, since a drive not failing does not
prove a firmware bug.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Thursday, December 02, 2004 10:37 PM
To: TJ
Cc: linux-raid@vger.kernel.org
Subject: Re: Good news / bad news - The joys of RAID

> not. It is my belief that formatting was inneffective at fixing the drive 
> because the cross writing probably hit some of the low level data, which
the 
> drive cannot repair on a format.

the ecc *is* the low-level data.  without performing a controlled experiment
that recreates the power-off scenario, there's no way to distinguish a block
whose media is actually bad from one whose ecc fails because the ecc is bad.

the firmware theory is supported by the fact that many deathstars 
performed perfectly well for many years.  I have at least one that lasted
for 4+ years, and was powered off only a few times, and all of those
cleanly.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

