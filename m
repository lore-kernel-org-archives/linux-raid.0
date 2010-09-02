From: "Martin Lui" <linuxdevel@martian111.net>
Subject: Setting /sys/block/mdX/md/rdY/size caps to half the true value of
 the component device size
Date: Wed, 1 Sep 2010 23:59:47 -0700
Message-ID: <5a6e17cae4572bddfdb55865a43b2c7b.squirrel@webmail.martian111.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org, linuxdevel@martian111.net
List-Id: linux-raid.ids

Hi Neil/Chris,

I ran into a similar situation as described in your thread (ack in Jun 2008):
http://marc.info/?l=linux-raid&m=121381509915920&w=2

First off, thank you both for your time to make this feature work.  Since
I've increased the partition size of my RAID partition, I too needed to
grow my array and component devices.  To do that, I attempted to use the
feature implemented in this patch:
http://marc.info/?l=linux-raid&m=121434960912711&w=2

However, it seems that the value applied by this method is half the
actual/correct value.  For example:

Before Change:
# mdadm --examine /dev/sda2
<snip>
 Avail Dev Size : 41495751 (19.79 GiB 21.25 GB)
     Array Size : 41495751 (19.79 GiB 21.25 GB)

# cat /sys/block/md127/md/dev-sda2/size
20747875

The size here is in 1K blocks (also consistent with the documentation in
md.txt).

After Change:
# echo "0" > /sys/block/md127/md/dev-sda2/size
# cat /sys/block/md127/md/dev-sda2/size
121889135

# mdadm --examine /dev/sda2
<snip>
 Avail Dev Size : 487556541 (232.49 GiB 249.63 GB)
     Array Size : 41495751 (19.79 GiB 21.25 GB)
  Used Dev Size : 41495751 (19.79 GiB 21.25 GB)

When attempting to grow the array, it's capped to the value stored in the
component device's size:
# mdadm --grow /dev/md127 --size=max
mdadm: component size of /dev/md127 has been set to 121889135K

# mdadm --examine /dev/sda2
<snip>
 Avail Dev Size : 487556541 (232.49 GiB 249.63 GB)
     Array Size : 243778270 (116.24 GiB 124.81 GB)
  Used Dev Size : 243778270 (116.24 GiB 124.81 GB)

Here is the partition table:
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          33      265041   fd  Linux raid autodetect
/dev/sda2              34       30382   243778342+  fd  Linux raid autodetect


The bright side is that a reboot fixes the problem.  After reboot, all the
values show up correctly:
# cat /sys/block/md127/md/dev-sda2/size
243778270
# mdadm --grow /dev/md127 --size=max
mdadm: component size of /dev/md127 has been set to 243778270K


With that in place, it seems that this is a very minor bug.  However, it
does prevent one from doing everything online (I assume that was the
original intent of this feature/patch).  Skimming at the code, it seems
that the correct value is written to the superblock, but the value
returned is divided 2.  Per the comments, it seems that is what gets set
to in sysfs.  If on boot it reads the superblock, that may explain why it
self-corrects.  (Didn't dig too much into the code, so this is a
hypothesis).

Anyways, my problem is resolved by a reboot.  Just want to pass this along
so others don't spend time figuring this out.

Thanks,
Martin

