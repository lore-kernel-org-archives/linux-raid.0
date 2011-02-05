From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Temporarily Disable Array
Date: Fri, 4 Feb 2011 22:44:12 -0600
Message-ID: <CC.BC.19545.0A5DC4D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	In a few days, I am going to be upgrading Linux on one of my servers
from Debian "Lenny" to "Squeeze".  I've gone through this upgrade a handful
of times, and it can be pretty tricky.  It would be best if the data array
were not assembled over and over again during the process.  I know it really
shouldn't make a difference, but in the real world stability issues have
raised their ugly heads more than once causing additional time and heartache
associated with the array to be required to complete the task.  With this in
mind, I would like to temporarily disable the assembly of the array until
the upgrade is complete and the system stable.  Do I have the following
checklist correct, or is there something wrong or missing?  Are there better
alternatives?  I'm not missing something about the "homehost" utility, am I?

1.  Edit /etc/mdadm/mdadm.conf and comment out the line specifying the
array.  Also comment out the line "HOMEHOST <system>"

2.  Edit /etc/fstab and comment out the line specifying the mount point for
the array.

3.  Issue the command `update-initramfs -u`

4.  Reboot the system, making sure the array does not assemble.

5.  Perform the OS upgrade.

6.  Edit mdadm.conf and fstab, removing the comment markers placed in steps
1 and 2.

7.  Issue the command `update-initramfs -u`

8.  Reboot the system, making sure the array assembles and mounts.



