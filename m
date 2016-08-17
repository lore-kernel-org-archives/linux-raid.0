From: Tim Small <tim@buttersideup.com>
Subject: How to get md to attempt to scrub blocks in its bad blocks list
Date: Wed, 17 Aug 2016 15:59:16 +0100
Message-ID: <b6c01e91-9786-9705-a452-253794f65bc6@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have had a look around at the other md arrays I manage following the
problems I've recently written about...

I have a machine with a single local SATA disk (an old laptop which only
has capacity for a single disk, and is used for backups), and a remote
iSCSI disk.  Both devices are members of a RAID1, with the remote drive
having the write-mostly flag set.

The iSCSI device had a write error during a resync, due to a transient
memory allocation failure on the remote machine.

I've cleared the write_error and want_replacement flags for the device
according to the kernel md docs, but can't see how to provoke md into
attempting to scrub the bad blocks?

Also in general, are there any mechanisms to get md to retry for longer?
 I've done this so-far:

ISCSIDISK=$(basename `readlink
/dev/disk/by-id/wwn-0x60014059ba55d40d7fc416d928211f5b`)
echo 600 > /sys/block/${ISCSIDISK}/device/timeout

in an attempt to work-around transient write errors due to memory
allocation failures, target machine reboots, network errors etc.

Should I be doing anything else (e.g. can I configure retries for failed
writes)?

Cheers,

Tim.
