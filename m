From: Kirill Malkin <malkin@reldata.com>
Subject: changing major/minor numbers
Date: Thu, 16 May 2002 19:34:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <56D0E60C58BF6F4C8E5AB3EBF24599DC0157CF@ruby.reldata.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a basic question about Linux RAID implementation: how to recover or
restart a RAID set when the individual disks are moved to a different SCSI
ID, i.e. when their minor (or major or both) number(s) change?

I've experimented with a RAID-1 configuration and found that whenever I move
one of the disks to a different SCSI ID, the set must be recovered manually
(i.e. raidhotadd) and the kernel initiates a full copy, even if raidtab is
manually updated (I guess the system simply looks at the superblocks as the
first choice). Is it possible to restart the set automatically or at least
avoid the full copy?

Another question: is there a utility that could identify RAID sets before
they are started, such as display the superblock contents and verify whether
any devices are missing or have been moved? There seems to be a considerable
amount of code, both in kernel and in raidtools, that prints out the content
of the superblocks, but only if there is a problem or debug mode is on.

The main reason behind these questions is the emergence of iSCSI devices
that could be connected in a random order thus breaking RAID functionality.
It would be nice to identify such devices up-front, make necessary
configuration changes and restart complete RAID sets without the full copy,
even if the disks come up as different major/minor numbers. Please let me
know if there's been any thinking in this direction.

Thank you in advance,
Kirill


