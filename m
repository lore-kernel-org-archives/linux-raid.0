From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: RAID1, hot-swap and boot integrity
Date: Fri, 02 Mar 2007 09:04:40 -0500
Message-ID: <45E82EF8.9000106@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We are using a RAID1 setup with two SATA disks on x86, using the whole
disks as the array components.  I'm pondering the following scenario.
We will boot from whichever drive the BIOS has first in its boot list
(the other drive will be second).  In the steady state this choice is
immaterial.  However, if after we boot that first drive fails and has
to be hot-swapped *and* the system crashes or is rebooted while the
re-sync operation is still running, it seems possible (perhaps even
likely) that the BIOS will to choose to boot from the same disk slot.
However, the drive in that slot is still being recovered and may not be
intact enough to boot from yet.

I've been considering trying something like having the re-sync algorithm
on a whole disk array defer the copy for sector 0 to the very end of the
re-sync operation.  Assuming the BIOS makes at least a minimal consistency
check on sector 0 before electing to boot from the drive, this would keep
it from selecting a partially re-sync'd drive that was not previously bootable.
Another wrinkle might be to also have re-sync zap sector 0 initially so that
a previously bootable disk added as the replacement would not be booted
in an inconsistent state, although this could not eliminate the window
in which a crash or reboot before the re-sync even started could cause
the replacement disk with who knows what contents to be booted.    This
also seems a fairly x86 centric solution, although that is fine for our
current application which is x86-based.

Thoughts or other suggestions anyone?
-- 
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
