From: "Timothy Weaver" <timothyweaver@gmail.com>
Subject: Convert RAID1 to standard ext2
Date: Mon, 13 Aug 2007 18:14:49 +1000
Message-ID: <a85387af0708130114xab0edbfs9b521da6a19fd96a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had 2x750GB drives in a RAID1 configuration in a D-Link NAS
(DNS-323) device with embedded Linux as an ext2 volume. The
configuration was corrupted and the NAS no longer saw the RAID.

I put the drives in another Linux box and was able to use mdadm to
scan the drives. It recognized the RAID1 configuration and created the
RAID device at /dev/md0. Unfortunately, it says it is corrupt and
cannot be mounted. I tried using e2fsck / fsck but it says the
superblock is corrupt. Trying to use copies of the superblock were
unsuccessful.

I am confident the data is still there and want to get to it. Is there
a way to take one of the drives and convert it from being in the RAID1
set to just a standard ext2 partition in a non-destructive way? I
figured this should be possible with the second drive just to be sure
not to destroy both copies of the data.

Thanks.
