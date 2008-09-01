From: David Greaves <david@dgreaves.com>
Subject: Re: Create software RAID from active partition
Date: Mon, 01 Sep 2008 14:30:38 +0100
Message-ID: <48BBEE7E.8050406@dgreaves.com>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guyver <michael.guyver@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guyver wrote:
> Hi there,
> 
> I've got a question about creating a RAID-1 array on a remote server -
> ie: if the operation fails, it's going to be very expensive. The
> server has two 200 GB drives and during a hurried re-install of CentOS
> 5.2 the creation of software RAID partitions was omitted. This means
> that the array would include the currently active partition on which
> the kernel is installed. So my first question is as to the feasibility
> of this operation, and its safety: any comments?

It looks to me like you have a system that is (almost) setup to use lvm
mirroring, not md (raid) mirroring.

Are you sure you want to swap to using md mirroring? Or do you want to restore
the lvm mirror?

> # mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> /dev/sda1 on /boot type ext3 (rw)
> tmpfs on /dev/shm type tmpfs (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)

So there are no issues mirroring the / fs.
Simply make the /dev/mapper/VolGroup00-LogVol00 mirrored
lvconvert -m or something.

Bear in mind that /boot and possibly the mbr won't be replicated so if a disk
fails you may not lose your rootfs but you won't be booting either...

> Judging from the "Found duplicate " messages produced by pvdisplay and
> lvdisplay, as well as the mount output, it seems that the root
> partition is being loaded from /dev/sdb2. What /dev/sda2 is doing
> right now is, I guess, completely sweet FA.
> 
> Can anyone point me to the way of finding out a file's physical
> location on disc so that I can verify this is the case? So, for
> example, I would like to check that my latest edit to ~/somefile.txt
> is in fact on /dev/sdb1 at location xyz and that can be verified by
> using dd to copy those bytes to a file in /tmp.
This is a red herring.
Unless you are into block level data recovery in which case go to the
smartmontools pages - they have a solution for this for ext3. Once you start to
introduce raid/lvm/other fs then you are in a world of confusion.


> Having started reading the docs related to creating a RAID device, it
> seems likely that the order of the listed devices is significant when
> the array is initialised. However, I haven't yet been able to confirm
> that were I to write
> 
> mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/sdb1 /dev/sda1
> 
> that it would start to copy data from sdb1 to sda1 - or have I
> misunderstood the initialisation process?
Yes.
Initialising will likely destroy data unless you are careful about superblock
locations.
Even then you'd need to create the array degraded and grow it.

I'd create the array in degraded mode using the blank disk and then copy the
data and test boot (retaining the ability to boot the old system)
Then, once it worked I'd wipe add the old disk in.

David
