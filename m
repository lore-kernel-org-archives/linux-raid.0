From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Tue, 11 May 2010 18:59:11 -0500
Message-ID: <3D.64.20763.25FE9EB4@cdptpa-omtalb.mail.rr.com>
References: <1273616411.5140.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273616411.5140.25.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > remote access.  This is a headless system, and I really can't
> effectively
> > work with a local console, plus I need to mount the /boot array in order
> to
> > properly edit the initrd.  I suppose I could mount the drive as a non-
> array
> > and then force a sync to the second drive, but I'd rather not.
> 
> The debian install discs should do most of that,

	Yeah, but ssh is a bit of a pain to work with from a live CD when
one must repeatedly reboot the system.  I'm using an Ubuntu live CD right
now, but I have to run `sudo apt-get install openssh-server` on the
workstation every time I boot (and as I mentioned, any console access on the
machine is rather difficult), and then I have to run `ssh -o
UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@backup`
from one of my workstations.  Once or twice isn't all that bad, but more
than that gets old in a hurry.

> and lenny or later
> allows you to setup a ssh server if you select expert mode.

	"Lenny" isn't really a good option.  I'd much rather have a later
kernel.  By "Setup", do you mean install the OS, or enter recovery mode?  I
don't want to try to install the OS: that could be a disaster.  BTW, the
2.6.32 kernel is moving the IDE disks all the way from /hda and /hdb to /sdj
and /sdk.  I think that's part of why it's breaking: the existing mdadm.conf
doesn't scan that high.

> If that's not complete enough then I believe http://www.sysresccd.org/
> is what you are after.

	Thanks.  I may check it out if I don't get this working in a couple
of more boot cycles.

