From: Troy Cauble <troycauble@gmail.com>
Subject: problem growing raid-1
Date: Sun, 1 Feb 2009 00:34:58 -0500
Message-ID: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to replace both disks in a RAID-1 with larger ones using the
instructions here:
http://linux-raid.osdl.org/index.php/Growing#Extending_an_existing_RAID_array

It looks straightforward: mdadm -f, mdmadm -r, swap a drive, etc., etc.

Except if I -f & -r a drive, I won't know which physical drive to pull.
(And I have no spare SATA ports.)

So I figure I'll pull a drive first, then -f & -r whatever mdadm tells
me is missing.
But when I pull the drive, connect a new one and boot, I get dropped
into a repair
shell with:

fsck.ext3: Unable to resolve 'UUID=806153bf-6917-440d-ae48-553418cfbbeb'

which is the UUID of the raid filesystem.

I put the drive back in and reboot, and everything is fine.

1)  So why doesn't my RAID-1 survive pulling a drive?
Seems like a standard failure mode.

2)  How do I proceed with the upgrade?

Thanks,
-troy
