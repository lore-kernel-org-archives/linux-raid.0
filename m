From: Terry Barnaby <terry1@beam.ltd.uk>
Subject: Raid 5 on Fedora 4 working with SATA ?
Date: Wed, 01 Feb 2006 13:27:15 +0000
Message-ID: <43E0B733.6050505@beam.ltd.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have just set up a Raid 5 disk array using 4 SATA disks on Fedora 4.
To test the setup I unplugged the SATA cable from one of the disk drives.
I was expecting the system to carry on with messages from the Raid system
indicating that there was a disk drive down.

However the Raid 5 partition became completely inaccessable after un-plugging
the drive. The kernel reported disk errors but there was no error messages
from the Raid system and "mdadm -Q --detail /dev/md2" reported that there
was no problems with the Raid array.

When I rebooted the system (needed a reset) the Raid system reported that
one disk was down and the partition became readable again.

It appears that the default configuration of the Raid 5 system does not
handle a complete drive failier during up-time. I presume it may respond to
disk errors from a disk drive that is connected but once disconnected the
Raid system appears to ignore errors.

Is there a configuration option to allow the Raid system to respond to
a completely broken drive or cable ?

Terry
