From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 15:37:23 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2446.66.230.1.97.1089232643.squirrel@exitwound.org>
References: <2354.66.230.1.97.1089229246.squirrel@exitwound.org>
    <200407072016.i67KGT309307@watkins-home.com>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407072016.i67KGT309307@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
