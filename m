From: "Grantham, Ewan R." <egrantham@swri.org>
Subject: RAID-5 on Firewire problems after initial troublefree operation
Date: Fri, 21 May 2004 15:43:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <AF4CBD49C827BA4F9BDD00E297CD804802624618@adsms01.dyn.datasys.swri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Setup is a Debian-based distribution running a 2.4.24 shell that has
been patched to support RAID and to add 1394 support into the kernel
(rather than as modules).

Have been running for a week as a RAID-5 using mdadm. When turning the
machine off I would use:
mdadm -S /dev/md0

then upon booting I would first run the rescan-scsi-bus.sh script from
the Linux1394.org site (to bring up all 4 drives) and then bring up the
array using:

mdadm -A /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

and finally mount the array as:

mount -t reiserfs /dev/md0 /disks/RAID

Again, this seemed to work just fine for a little over a week until last
night. When I went to bring up the system with the mdadm -A command it
would complain that it could only load two of the drives and that wasn't
enough to bring up the array. The rescan script showed all four, but to
be safe I did the "modprobe sbp2" to see if there was an issue.

Trying to bring up the array after that I keep getting a message that
the drives are missing a superblock.

What research I've been able to do on the archives here leads me to
think that getting a newer version of mdadm that supports the
--update=summaries option might allow me to bring up the array. Will
that work, or is that going to seriously "munge" my data? Any other
suggestions on what to do?

Thanks,
Ewan Grantham

