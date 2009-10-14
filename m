From: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Subject: "mdadm --remove" fails if it is too soon after "mdadm --fail"
Date: Wed, 14 Oct 2009 09:32:36 -0600 (MDT)
Message-ID: <alpine.DEB.1.00.0910131748110.8815@darius>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I need to automate removing of a device from a raid 1.  The way to do
this is

       mdadm <raid1> --fail <device>

followed by

       mdadm <raid1> --remove <device>

The problem is that if these commands are issued by, say, compiled C
code, the --remove can fail, apparently because it is too soon after
the --fail.  Doing retries in a loop with sleep() calls seems to work
around most instances, but it seems that in very exceptional
circumstances, waiting a few seconds is not enough.  In that case, the
--fail fails because the HOT_REMOVE_DISK ioctl failed with EBUSY.
Digging into the source in the kernel tree, it looks like the relevant
code is in drivers/md/md.c::hot_remove_disk(), and the only way this
returns EBUSY appears to be if the "raid_disk" field in the mdk_rdev_t
struct for the device is non-negative, i.e., is a valid index into the
array of devices for the raid1.

The --fail operation issues a SET_DISK_FAULTY ioctl, which looks like
it winds up in drivers/md/md.c::set_disk_faulty(), which calls
drivers/md/md.c::md_error(), which calls an error_handler specific to
the type of raid.  In the raid1 case, that winds up bing
drivers/md/raid1.c::error(), which (among other things) sets the
"Faulty" bit in the device.  And it looks like this "Faulty" bit is
translated into "raid_disk" being -1 in
drivers/md/md.c::remove_and_add_spares().  This function (i.e.,
remove_and_add_spares()) is only called from
drivers/md/md.c::md_check_recovery().  And, finally,
md_check_recovery() has comments indicating that it is "regularly
called by all per-raid-array threads".

I.e., it seems that the ioctl invoked by --fail doesn't directly set
up the device to be ready for --remove, but some other kernel thread
completes that state change.  I'm wondering if it could be the case
that when the system is very, very busy, it could take long enough for
that kernel thread to run that it would cause what I see, i.e.,
--remove fails with EBUSY, even though I've already waited about 20
seconds for the device to be ready to be removed.  If this is so, what
shall I do?  Here are the options I can think of:

1) sleep() for even longer, perhaps by increasing the sleep() on each retry

2) run a later version of the md system and/or kernel in which this
      timing window is eliminated (or reduced to a reasonably short length)

3) something else?


-- 
Darius S. Naqvi
dnaqvi@datagardens.com
http://www.datagardens.com
