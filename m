From: Martin Wilck <mwilck@arcor.de>
Subject: mdadm --fail on RAID0 array
Date: Tue, 06 Aug 2013 23:27:18 +0200
Message-ID: <52016A36.9090902@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, everyone,

I'd like to discuss the following "feature" I just discovered.
It is impossible to set devices faulty in a container if they
are only members of a RAID0:

mdadm -CR /dev/md/ddf -e ddf -l container -n 3 /dev/loop10  /dev/loop11
mdadm -CR /dev/md/vol1 -l raid0 -n 2 /dev/md/ddf
mdadm --fail /dev/md/vol1 /dev/loop11
mdadm: set device faulty failed for /dev/loop11:
   Device or resource busy

This is independent of DDF / external metadata; it happens with native
MD meta data, too. I don't quite understand why this is so; certainly
RAID0 has no way to recover from disk failure, but simply refusing to
ack the fact that a disk is broken doesn't seem right. IMO the array
should switch to read-only ASAP, and mark itself failed in the meta
data. But I may be missing something important for a native MD case.

However, in a container, it must be possible to set a disk failed, and
that's currently not the case if a disk is only member in a RAID0. In
the DDF case, we'd expect to set the array failed in the meta data and
update the disk state to "Failed". "mdadm --fail" on container devices
doesn't work, either, because the kernel refuses to do that without RAID
personality (actually, this is what I'd like to change in the first
place, but I don't oversee potential problems).

This has actually potential to cause severe breakage. Consider a DDF
container with 3 disks d0, d1, d2. A RAID0 array uses 50% of space on
d0, d1, and a RAID1 uses another 50% on d1, d2. Now d0 goes bad. mdmon
wouldn't notice. When d1 or d2 go bad, too, mdmon would try to use the
free space on d0 for rebuilding.

For this scenario to get fixed, it wouldn't be sufficient for the kernel
to accept mdadm --fail on RAID0. We'd also need to monitor the RAID0
(or, actually, all phys devices) with mdmon. In other words, this would
require to run mdmon on every container, not only on subarrays with
redundancy.

Thoughts?

Martin
