From: Trevor Morrison <trevor@hailix.com>
Subject: removing RAID 1 from a RH 7.1 box
Date: Mon, 19 May 2003 11:18:46 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC911F6.B1797953@hailix.com>
Reply-To: trevor@hailix.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HI,

I have a RH 7.1 box with a Software RAID 1 setup.  I am trying to
upgrade the box to RH 9 using RH upgrade feature.  When
I boot the system off the CD-ROM all works well until I try to upgrade.
The system tells me that it "cannot find a valid RH
installation."  It does not see the /dev/md/0 structure.  I have tried
various boot prompt command, but to no avail.  Does
anyone know a way around this?

Or, does any one know how to remove the RAID 1 setup from my system.  I
followed the example for the the "Software RAID HOWTO" and it worked
fine the first time.  Now, it looks like I may have to reverse it, but
I don't know how.

TIA

--
Trevor Morrison
Hailix, LLC
trevor@hailix.com



