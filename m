From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sat, 02 Mar 2013 03:15:36 -0600
Message-ID: <5131C338.8010402@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5130D206.4090302@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First reply missed the list.

On 3/1/2013 10:06 AM, Adam Goryachev wrote:
> Hi all,

Hi Adam,

This is really long so I'll hit the important parts and try to be brief.

> THINGS STILL TO TRY/DO
> Could you please feel free to re-arrange the order of these, or let me
> know if I should skip/not bother any of them. I'll try to do as much as
> possible this weekend, and then see what happens next week.
> 
> 1) Make sure stripe_cache_size is as least 8192.  If not:
> ~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
> Currently using default 256.

Critical- a low value here may be severely limiting SSD write
throughput.  And I suspect this default 256KB is more than a minor
factor in your low FIO write performance.

> 2) Disable HT on the SAN1, retest write performance for single threaded
> write issue.
> top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file
> 
> 3) fio tests should use this test config:
> [global]
> filename=/dev/vg0/testlv (assuming this is still correct)
> zero_buffers
> numjobs=16
> thread
> group_reporting
> blocksize=256k
> ioengine=libaio
> iodepth=16
> direct=1
> size=8g
> 
> [read]
> rw=randread
> stonewall
> 
> [write]
> rw=randwrite
> stonewall

This test should provide a bit more realistic picture of your current
write throughput capability.  "zero_buffers" causes FIO to use a
repeating data pattern instead of the default random pattern.  The Intel
520 480 SSDs have the Sandforce 2281 controller which performs on the
fly compression, to both increase performance and increase effective
capacity.  Most user data is compressible.  This should show an increase
in throughput over previous tests.

Second, this test uses 16 write threads instead of one, which will make
sure we're filling the queue.  All FIO testing you've done has been
single threaded with AIO, which may or may not have been filling the queue.

Third, this test is fully random IO, which better mimics your real world
workload than your previous testing.  Depending on these Intel SSDs,
this may increase or decrease both the read and/or write throughput
results.  I'd guess you'll see decreased read but increased write.

> 4) Try to connect the SSD's direct to the HBA, bypassing the hotswap
> device in case this is limiting to SATA II or similar.

You don't have to touch the hardware.  Simply do:

~$ dmesg|grep "link up"
ata3: SATA link up 6.0 Gbps (SStatus 113 SControl 310)

This tells you the current data rate of each SAS/SATA link on all
controllers.  With a boot SSD on mobo and 5 on the LSI, you should see 6
at 6.0 Gbps and 1 at 3.0 Gbps.  Maybe another one if you have a DVD on SATA.

> 5) Configure the user LAN switch to prioritise RDP traffic. If SMB
> traffic is flooding the link, than we need the user to at least feel
> happy that the screen is still updating.

Can't hurt but only help.

> 6) SAN1 - Get rid of the bond0 with 8 x 1G ports, and use 8 IP
> addresses, (one on each port). Properly configure the clients to each
> connect to a different pair of ports using MPIO.

The connections are done with the iscsiadmin.  MPIO simply uses the
resulting two local SCSI devices.  Remember the iscsiadm command line
args to log each Xen client interface (IP) into only one san1 interface
(IP).

> 7) Upgrade DRBD to 8.4.3
> See https://blogs.linbit.com/p/469/843-random-writes-faster/

Looks good.

> 8) Lie to DRBD, pretend we have a BBU

Not a good idea.  Your Intel SSDs are consumer, not enterprise, and thus
don't have the power loss write capacitor.  And you don't have BBU in
the other SAN box.  Thus you have no capability like that of BBU.
Either box could crash, and UPS are not infallible, thus you'd better do
write-through instead of write-back, i.e. don't lie to DRBD.  Any added
performance isn't worth the potential disaster.

> 9) Check out the output of xm top
> I presume this is to ensure the dom0 CPU is not too busy to keep up with
> handling the iSCSI/ethernet traffic/etc.

One of those AMD cores should be plenty for the hypervisor at peak IO
load, as long as no VMs are allowed to run on it.  Giving a 2nd core to
the DC VM may help though.

> 10) Run benchmarks on a couple of LV's on the san1 machine, if these
> pass the expected performance level, then re-run on the physical
> machines (xen). If that passes, then run inside a VM.

For getting at client VM performance, start testing there.  Only if you
can't hit close to 100MB/s, then drill down through the layers.

> 11) Collect the output from iostat -x 5 when the problem happens

Not sure what this was for.  Given the link throughput numbers you
posted the user complaints are not due to slow IO on the SAN server, but
most likely a problem with the number of cores available to each TS VM
on the Xen boxen.

> 12) disable NCQ (ie putting the driver in native IDE mode or setting
> queue depth to 1).
>
> I still haven't worked out how to actually do this, but now I'm using
> the LSI card, maybe it is easier/harder, and apparently it shouldn't
> make a lot of difference anyway.

Yeah, don't bother with this-- would only slightly help, if at all.

> 13) Add at least a second virtual CPU (plus physical cpu) to the windows
> DC. It is still single CPU due to the windows HAL version. Prefer to
> provide a total of 4 CPU's to the VM, leaving 2 for the physical box,
> same as all the rest of the VM's and physicals.

Probably won't help much but can't hurt.  Give it a low to-do priority.

> 14) Upgrade windows 2000 DC to windows 2003, potentially there was some
> xen/windows issue with performance. Previously I had an issue with
> Win2003 with no service packs, and it was resolved by upgrade to service
> pack 4.

Good idea.  W2K was around long before the virtual machine craze.

> 15) "Make sure all LVs are aligned to the underlying md device geometry.
>  This will eliminate any possible alignment issues."
> What does this mean? The drive partitions are now aligned properly, but
> how does LVM allocate the blocks for each LV, and how do I ensure it
> does so optimally? How do I even check this?

I'm not an LVM user so I can't give you command lines.  But what I can
tell you follows, and it is somewhat critical to RMW performance, more
for rust but also for SSD to a lesser degree.

> 16) RAID5:
> md1 : active raid5 sdb1[7] sdd1[9] sde1[5] sdc1[8] sda1[6]
>       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
> [UUUUU]
>       bitmap: 2/4 pages [8KB], 65536KB chunk

Your md/RAID5 stripe width is 4 x 64KB = 256KB.  Thus every slice you
create for LVM should start on a sector that is a multiple of 256KB.
Say your first LVM slice of the md device is to be 25GB.  It starts at
sector 0 of the md device, so your ending sector of the slice would be,
assuming my math fu is up to the task:

(262,144 * 100,000)=(26,414,400,000 bytes / 512)= sector 51,590,625

So your next slice should start at sector 51,590,626.  What this does is
make sure your LVM blocks line up evenly atop the md/RAID stripes.  If
they don't and they lay over two consecutive md stripes you can get
double the RMW penalty.  For a typical single power user PC this isn't a
huge issue due to the massive IOPS of SSDs.  But for a server such as
yours with lots of random user IO and potentially snapshots and DRBD
mirroring, etc, it could cause significant slowdown due to the extra RMW IO.

> Is it worth reducing the chunk size from 64k down to 16k or even smaller?

64KB chunks should be fine here.  Any gains with a smaller chunk would
be small, and would pale in comparison to the amount of PITA required to
redo the array and everything currently sitting atop it.  Remember you'd
have to destroy it and start over.  You can't change chunk size of an
existing array.

> 17) Consider upgrading the dual port network card on the DC box to a
> 4port card, use 2 ports for iSCSI and 2 ports for the user lan.
> Configure the user lan side as LACP, so it can provide up to 1G for each
> of 2 SMB users simultaneously. Means total 2Gbps for iSCSI and total
> 2Gbps for SMB, but only 1Gbps SMB for each user.

Or simply add another single port $15 Realtek 8111/8168 PCIe x1 NIC,
which matches the onboard ethernet, for user traffic--user traffic on
Realtek, iSCSI on Intel.  This will allow the DC box to absorb sporadic
large SMB transfers without slowing all other users' SMB traffic.  Given
the cost per NIC you can easily do this on all Xen boxen so you still
have SC migration ability across all Xen.

> 18) Ability to request the SSD to do garbage collection/TRIM/etc at
> night (off peak)

This isn't possible.  GC is an SSD firmware function.  TRIM can only be
issued by a filesystem driver.  I doubt one will ever be able to pass
TRIM commands down from Windows guest SCSI layer through exported Xen
disks across iSCSI to iscsi-target to md to SSD.  Remember TRIM is a
filesystem function.  In your setup you must simply rely on the SSD
firmware to handle GC and without TRIM.

> 19) Check IO size, seems to prefer doing a lot of small IO instead of
> big blocks. Maybe due to drbd.

DRBD does cause the small IOs.  DRBD simply mirrors changes to the array
device.  Your client application dictate the size of IOs.

> Thanks again to everyone's input/suggestions.

Any time.  I have one more suggestion that might make a world of
difference to your users.

You did not mention the virtual CPU configuration on the Xen TS boxen.
Are you currently assigning 5 of 6 cores as vCPUs to both Windows TS
instances?  If not you should be.  You should be able to assign a vCPU
or an SMP group, to more than one guest, or vice versa.  Doing so will
allow either guest to use all available cores when needed.  If you
dedicate one to the hypervisor that leaves 5.  I'm not sure if Windows
will run with an asymmetric CPU count.  If not, assign cores 1-4 to one
guest and cores 2-5 to the other, assuming core 0 is dedicated to the
hypervisor.  If Xen won't allow this, the create one SMP group of 4
cores and assign it to both guests.  I've never used Xen so my
terminology is likely off.  This is trivial to do with ESX.

If you are currently only assigning 1 or 2 cores to each Windows TS
guest, the additional cores should make a huge difference to your users,
depending on the applications they run.  For example, a user viewing a
large and/or complex PDF in the horribly CPU inefficient Adobe Reader
(or $deity forbid the browser plugin) such as PDFs with embedded
engineering schematics, can easily eat all the cycles of one or even two
cores for 10-15 seconds or more at a time, multiple times while paging
through the file.

A perfect example: using Adobe Reader (not the plugin) with this
SuperMicro chassis manual:
http://www.supermicro.com/manuals/chassis/tower/SC417.pdf

eats 100% of one of my two 3GHz AMD cores for about 2-5 seconds each
time it renders one of the vector graphics chassis schematic pages.
With some of the schematics it eats all of BOTH cores for about 3-5
seconds as recent versions of Acrobat do threaded processing of vector
graphics.  This is with Acrobat 10.1.6 (latest) on WinXP, 3GHz AthlonII
x2, dual channel DDR3-1333, PCIe x16 nVidia GT240, Corsair SSD--not a
slow box.  Rendering something like this on Terminal Services would
likely increase CPU burn time and rendering times many fold over that of
my workstation.

If you have a TS user doing something like this with only 1-2 cores per
TS VM it will bring everyone to their knees for many seconds, possibly
minutes, at a time.  And this isn't limited to Adobe reader.  There are
many browser plugin apps that will do the same, or worse.  Flash comes
to mind.  I've come across some poorly written Flash web sites will eat
all of a CPU like this just idling on the index page.  Watching a Flash
movie trailer at 1080 or 720 HD will bring your TS to its knees as well.
 These are but two application examples that will bring a TS to its
knees.  If you already have cores for TS VMs covered my apologies for
the extra reading.  Maybe it will be helpful to others.

-- 
Stan



