From: Jon Eisenstein <eisenstein@gmail.com>
Subject: Is mdadm guaranteed consistent after a sync/xfs_freeze?
Date: Mon, 9 Dec 2013 12:18:47 -0500
Message-ID: <CALSwqp8JSEApZkMwvOZJt4pUVZJOC5HYmVk+wnce51bDVo49QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been getting inconsistent answers to this through various
sources, so I figured I'd give this group a shot as a more legitimate
authority.

I'm using a set of EBS volumes on AWS in an mdadm RAID0 array. In
order to do an EBS (block-level) snapshot, we are currently stopping
the service, freezing the FS, disassembling the RAID and snapshotting
once the disks can't possibly be talking to each other anymore, for
safety.

Is all that necessary? If I stop writes from the service and sync +
xfs_freeze the filesystem, will those snapshots be point-in-time
consistent without having to tear it down and rebuild it every time?
Or should we be doing something else to further protect it, like
adding an LVM layer?

Thanks,
Jon
