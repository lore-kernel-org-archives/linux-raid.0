From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 14:58:53 +0200
Message-ID: <20090426125852.GA14517@lazy.lzy>
References: <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy> <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com> <20090426121412.GA11921@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090426121412.GA11921@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 26, 2009 at 02:14:12PM +0200, Piergiorgio Sartor wrote:
> On Sun, Apr 26, 2009 at 07:52:15AM -0400, Doug Ledford wrote:
> >
> > I'm guessing that you didn't completely stop all usage of the hotplug  
> > devices before you removed them as this works fine for me.  If the  
> > devices aren't completely stopped before removal, then the stack can't  
> > delete the devices.
[...]

OK, so more clear info.
The /etc/udev/rules/70-mdadm.rules is:

# This file causes block devices with Linux RAID (mdadm) signatures to
# automatically cause mdadm to be run.
# See udev(8) for syntax

SUBSYSTEM=="block", ACTION=="add", ENV{ID_FS_TYPE}=="linux_raid*", \
	RUN+="/sbin/mdadm -I --auto=yes $root/%k"

This is the same F10 standard, but without the "change"
option in the "ACTION".

On hotplug, I get a mess in the arrays, not all and
not always they are properly added.
This is similar to what happen with "change" in place.
Already at this point, something is fishy.

The /dev/md contains:

vol00    vol00p4  vol01p3  vol02p2  vol03p1  vol04    vol04p4  vol05p3  vol06p2
vol00p1  vol01    vol01p4  vol02p3  vol03p2  vol04p1  vol05    vol05p4  vol06p3
vol00p2  vol01p1  vol02    vol02p4  vol03p3  vol04p2  vol05p1  vol06    vol06p4
vol00p3  vol01p2  vol02p1  vol03    vol03p4  vol04p3  vol05p2  vol06p1

Note that these arrays have no partitions and no
filesystem, since they are PV of LVM.
The vol0X are the names of the arrays.

I manually remove the arrays, with "mdadm --stop --scan".
Now, the files are still there after removing the arrays,
even if there is no sign of the RAID in /proc/mdstat.
After un-plug, they are still there.

If I hot plug again the device, nothing happens, the arrays
are not auto-started by udev.
If I remove the /dev/md/vol* files, then it does something,
even if not correctly, as mentioned above.

If I tried, from command line:

mdadm -I --auto=yes /dev/sdd1

I get:

mdadm: failed to open /dev/md/vol00: File exists.

If I delete the /dev/md/vol* files, and I do manually
the "-I" thing with all the proper devices, the array
is assembled properly.

mdadm -I --auto=yes /dev/sdd1
/dev/md_vol00p1: File exists
/dev/md_vol00p2: File exists
/dev/md_vol00p3: File exists
/dev/md_vol00p4: File exists
mdadm: /dev/sdd1 attached to /dev/md/vol00, not enough to start (1).

Note that the /dev/md/ was empty before the command
was given.

I tried, right now, to re-add "change", and I get the same
result, so it seems the "add|change" or "add" alone are
doing the same, but still there are two problems.
One is that the arrays are not assembled properly, the
other is that they're not assembled at all if the files
are there.

bye,

-- 

piergiorgio
