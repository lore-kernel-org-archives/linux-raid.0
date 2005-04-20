From: Alvin Oga <aoga@mail.Linux-Consulting.com>
Subject: RE: Questions about software RAID - red led
Date: Tue, 19 Apr 2005 21:47:02 -0700 (PDT)
Message-ID: <Pine.LNX.3.96.1050419214301.16955A-100000@Maggie.Linux-Consulting.com>
References: <200504200415.j3K4FWm29946@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504200415.j3K4FWm29946@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Wed, 20 Apr 2005, Guy wrote:

> Well, I agree with KISS, but from the operator's point of view!
> 
> I want the failed disk to light a red LED.
> I want the tray the disk is in to light a red LED.
> I want the cabinet the tray is in to light a red LED.
> I want the re-build to the spare to start.
> I want the operator du jour to notice the red LEDs.
> I want the operator to remove the failed disk.
> I want the operator to install the new disk.
> I want the re-build to the new disk to start.
> I want the re-build to not fail the current spare so data says redundant.
> I want the old spare to become the spare again. (optional)
> 
> The operator would log the event:
> "Disk xyz's LED went red, I replaced the disk, the red LED went out."
> 
> In my opinion, most operators would not be able to replace a disk on a md
> RAID system.  It is much too complex!  Most operators need written
> procedures.  They can't use independent thought to resolve problems.

if you want the above ... it is possible to do ... its just a few
hardware tweeking on the drive tray ... ( trivial to do if you have
access to the ide disk tray and backplane )

operator du jour does NOT need to do anyting ... software raid
can detect or be told that a disk went bad and it will rebuild
itself after the drive tray is removed and replaced with the
same disk or different disk

	- think usb .. you plug it in .. it comes up
	- think cdrom .. you put it in .. it comes up
	- think new disk tray .. you plug it in .. it comes up

- the bigger problem ..
	- disks should NOT be dying  in the first place

and yup.. building customizations is the fun part

c ya
alvin

