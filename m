From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 11:55:26 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0510241148180.10404@twinlark.arctic.org>
References: <E1EU16u-0002ZK-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU16u-0002ZK-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Oct 2005, Jeff Breidenbach wrote:

> >First of all, if the data is mostly static, rsync might work faster.
> 
> Any operation that stats the individual files - even to just look at
> timestamps - takes about two weeks. Therefore it is hard for me to see
> rsync as a viable solution, even though the data is mostly
> static. About 400,000 files change between weekly backups.

taking a long time to stat individual files makes me wonder if you're
suffering from atime updates and O(n) directory lookups... have you tried
this:

- mount -o noatime,nodiratime
- tune2fs -O dir_index  (and e2fsck -D)
  (you need recentish e2fsprogs for this, and i'm pretty sure you want
  2.6.x kernel)

a big hint you're suffering from atime updates is write traffic when your
fs is mounted rw, and your static webserver is the only thing running (and
your logs go elsewhere)... atime updates are probably the only writes
then.  try "iostat -x 5".

a big hint you're suffering from O(n) directory lookups is heaps of system
time... (vmstat or top).


On Mon, 24 Oct 2005, Brad Campbell wrote:

> mount -o remount,ro /dev/md0 /web
> mdadm --fail /dev/md0 /dev/sdd1
> mdadm --remove /dev/md0 /dev/sdd1
> mount -o ro /dev/sdd1 /target
> 
> <do backup here>
> 
> umount /target
> mdadm -add /dev/md0 /dev/sdd1
> mount -o remount,rw /dev/md0 /web

the md event counts would be out of sync and unless you're using bitmapped 
intent logging this would cause a full resync.  if the raid wasn't online 
you could probably use one of the mdadm options to force the two devices 
to be a sync'd raid1 ... but i'm guessing you wouldn't be able to do it 
online.

other 2.6.x bleeding edge options are to mark one drive as write-mostly
so that you have no read traffic competition while doing a backup... or
just use the bitmap intent logging and a nbd to add a third, networked,
copy of the drive on another machine.

-dean
