From: greg@enjellic.com
Subject: MD sysfs/kobject issues in SAN environment.
Date: Fri, 22 Feb 2008 10:11:50 -0600
Message-ID: <200802221611.m1MGBo45005323@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: gregkh@suse.de, neilb@suse.de, viro@zeniv.linux.org.uk
List-Id: linux-raid.ids

Good morning, hope the end of the week is going well for everyone.
Apologies for the rather wide coverage on this note but I wanted to
make sure all involved parties were in the loop.

We've been chasing a series of anomalies in a large production SAN
environment involving MD/RAID1 and the sysfs/kobject system.  I was
able to get full instrumentation and logging on the issues during a
systems failure early this morning and wanted to get a report out on
what was found.

The SAN initiators use RAID1 mirrors to access SAN targets in two
geographically isolated data-centers.  We've been having issues with
SAN targets periodically failing which present as I/O's never
completing to the RAID1 driver.  As has been discussed earlier on
linux-raid this is an error scenario which the RAID1 driver cannot
address short of a timer based solution which arguably involves a
layering violation.

As processes on the initiators attempt to do I/O they go into D state
which eventually produces very high load levels.  Our response to this
is to restart the hung target.  This generates a LIP in the affected
zone which the HBA's can of course detect which in turn results in the
underlying device being failed from the mirror.

For completeness sake and for anyone GOOGLEing this issue the RHEL5.1
kernel (2.6.18-53.1.13.el5) gets the situation completely wrong.  The
RAID1 driver detects the anomaly, kicks the device and indicates its
continueing on one device but then throws an I/O error up through LVM
and into the overlying filesystem.  This causes the filesystem to go
read-only but in some cases not before generating filesystem
corruption which needs to be corrected by a full ext3 filesystem
check.

To make this somewhat more relevant to the kernel developers a couple
of initiators were platformed on the most recent 2.6.22/2.6.23
kernels.  I know even these kernels are dated but these are full
production systems which has kept us off 2.6.24 for the time being.

The 2.6.22.x/2.6.23.x kernels see the same I/O stalls when the targets
hang but they do handle the failure scenario correctly.  The MD device
picks up on the target reboot induced LIP, fails out the device and
the machines go forward as they should.

On these kernels we do see a problem which I'm interpreting as
secondary to lifetime issues between the MD driver and kobject/sysfs.

Here is an exerpt from logging at 'info' and 'notice' priority levels
for the event:

---------------------------------------------------------------------------
Feb 22 01:36:54 rsg1 kernel: qla2xxx 0000:03:09.0: scsi(3:0:1): Abort command issued -- 1 3818fa 2002.
Feb 22 01:37:20 rsg1 hotplug: Event 871 requested remove for device: scsi_disk
Feb 22 01:37:20 rsg1 hotplug: Event 870 requested remove for device: scsi_device
Feb 22 01:37:20 rsg1 hotplug: Event 872 requested remove for device: block
Feb 22 01:37:20 rsg1 hotplug: Event 873 requested remove for device: block
Feb 22 01:37:20 rsg1 hotplug: Event 874 requested remove for device: scsi
Feb 22 01:37:24 rsg1 kernel: qla2xxx 0000:03:09.0: scsi(3:0:1): Abort command issued -- 1 3818fb 2002.
Feb 22 01:37:24 rsg1 kernel: scsi 3:0:0:1: scsi: Device offlined - not ready after error recovery
Feb 22 01:37:24 rsg1 kernel: scsi 3:0:0:1: [sdd] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Feb 22 01:39:24 rsg1 kernel: scsi scan: INQUIRY result too short (5), using 36
Feb 22 01:39:24 rsg1 kernel: scsi 3:0:0:1: Direct-Access     FCTARGET lvm(58,6)
       0.9  PQ: 0 ANSI: 3
Feb 22 01:39:24 rsg1 kernel: sd 3:0:0:1: [sde] 418775040 512-byte hardware sectors (214413 MB)
Feb 22 01:39:24 rsg1 kernel: sd 3:0:0:1: [sde] Write Protect is off
Feb 22 01:39:24 rsg1 kernel: sd 3:0:0:1: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 22 01:39:24 rsg1 hotplug: Event 876 requested add for device: scsi_disk
Feb 22 01:39:24 rsg1 hotplug: Event 875 requested add for device: scsi
Feb 22 01:39:24 rsg1 kernel:  sde: sde1
Feb 22 01:39:24 rsg1 hotplug: Event 877 requested add for device: block
Feb 22 01:39:24 rsg1 hotplug: Event 878 requested add for device: block
Feb 22 01:39:24 rsg1 kernel: sd 3:0:0:1: [sde] Attached SCSI disk
---------------------------------------------------------------------------

Which corresponds to the following messages at 'warn' priority:

---------------------------------------------------------------------------
Feb 22 01:37:20 rsg1 kernel:  rport-3:0-1: blocked FC remote port time out: removing target and saving binding
Feb 22 01:37:24 rsg1 kernel: end_request: I/O error, dev sdd, sector 418774920
Feb 22 01:37:24 rsg1 kernel: md: super_written gets error=-5, uptodate=0
Feb 22 01:37:24 rsg1 kernel: raid1: Disk failure on sdd1, disabling device.
Feb 22 01:37:24 rsg1 kernel: ^IOperation continuing on 1 devices
Feb 22 01:37:24 rsg1 kernel: scsi 3:0:0:1: rejecting I/O to dead device
Feb 22 01:37:24 rsg1 kernel: md: super_written gets error=-5, uptodate=0
Feb 22 01:37:24 rsg1 kernel: scsi 3:0:0:1: rejecting I/O to dead device
Feb 22 01:37:24 rsg1 kernel: md: super_written gets error=-5, uptodate=0
Feb 22 01:37:24 rsg1 kernel: RAID1 conf printout:
Feb 22 01:37:24 rsg1 kernel:  --- wd:1 rd:2
Feb 22 01:37:24 rsg1 kernel:  disk 0, wo:0, o:1, dev:sdc1
Feb 22 01:37:24 rsg1 kernel:  disk 1, wo:1, o:0, dev:sdd1
Feb 22 01:37:24 rsg1 kernel: RAID1 conf printout:
Feb 22 01:37:24 rsg1 kernel:  --- wd:1 rd:2
Feb 22 01:37:24 rsg1 kernel:  disk 0, wo:0, o:1, dev:sdc1
Feb 22 01:39:26 rsg1 kernel: kobject_add failed for 3:0:0:1 with -EEXIST, don't
try to register things with the same name in the same directory.
Feb 22 01:39:26 rsg1 kernel:  [<c01bddde>] kobject_shadow_add+0x101/0x10a
Feb 22 01:39:26 rsg1 kernel:  [<c01edc5d>] device_add+0x7c/0x374
Feb 22 01:39:26 rsg1 kernel:  [<c020cb47>] scsi_sysfs_add_sdev+0x27/0x148
Feb 22 01:39:26 rsg1 kernel:  [<c020b09f>] scsi_add_lun+0x2b7/0x2cc
Feb 22 01:39:26 rsg1 kernel:  [<c020b228>] scsi_probe_and_add_lun+0x174/0x206
Feb 22 01:39:26 rsg1 kernel:  [<c020b37d>] scsi_sequential_lun_scan+0xc3/0xda
Feb 22 01:39:26 rsg1 kernel:  [<c020b98e>] __scsi_scan_target+0xd1/0xe8
Feb 22 01:39:26 rsg1 kernel:  [<c020ba4d>] scsi_scan_target+0xa8/0xc2
Feb 22 01:39:26 rsg1 kernel:  [<c0213529>] fc_scsi_scan_rport+0x0/0x73
Feb 22 01:39:26 rsg1 kernel:  [<c021357e>] fc_scsi_scan_rport+0x55/0x73
Feb 22 01:39:26 rsg1 kernel:  [<c01227f9>] run_workqueue+0x77/0xf3
Feb 22 01:39:26 rsg1 kernel:  [<c0122875>] worker_thread+0x0/0xb1
Feb 22 01:39:26 rsg1 kernel:  [<c012291c>] worker_thread+0xa7/0xb1
Feb 22 01:39:26 rsg1 kernel:  [<c01256e9>] autoremove_wake_function+0x0/0x33
Feb 22 01:39:26 rsg1 kernel:  [<c01256e9>] autoremove_wake_function+0x0/0x33
Feb 22 01:39:26 rsg1 kernel:  [<c0122875>] worker_thread+0x0/0xb1
Feb 22 01:39:26 rsg1 kernel:  [<c0125307>] kthread+0x34/0x55
Feb 22 01:39:26 rsg1 kernel:  [<c01252d3>] kthread+0x0/0x55
Feb 22 01:39:26 rsg1 kernel:  [<c01030c7>] kernel_thread_helper+0x7/0x10
Feb 22 01:39:26 rsg1 kernel:  =======================
---------------------------------------------------------------------------

As can be seen from the first set of logs the /dev/sdd device is what
gets kicked out of the RAID1 device.  The SAN target coming back
on-line triggers an event which results in the same device being
re-discovered as /dev/sde.

My assumption is device discovery is forced as the 'next' SCSI device
due to the fact the RAID1 MD device is still holding a reference to
the failed /dev/sdd device, thus preventing its re-use.  Thats at
least how I interpret the:

Feb 22 01:39:26 rsg1 kernel: kobject_add failed for 3:0:0:1 with -EEXIST, don't
try to register things with the same name in the same directory.

And the resultant stack trace.

The interaction of this with udev tends to complicate the situation
from a systems administration point of view.  The loss of the /dev/sdd
device is picked up by udevd which causes node entries for the block
device and its associated partitions to be removed.

This tends to violate the premise of 'least surprise' when the systems
staff logs in to recover the situation and can't remove the failed
device from the RAID1 device and are potentially forced to add a
completely different device back into the MD device to recover from
the event.

Neil/Greg our production SUSE boxes running the 2.6.16.54-0.2.5-smp
kernel get all this completely right.  They handle the device failure
and don't end up re-discovering the target as the next SCSI device.
If the issues we are seeing are due to a change in block device or
sysfs/kobject behavior since 2.6.16 future SUSE releases may be
affected.  If the behavior is due to better udev rules you guys
win... :-)

Is it correct to assume in the 'do everything in userspace world' that
the way to deal with this is to trap device removal with hotplug
scripts and automatically remove the failed component from whatever MD
device it may be in?  If so I don't currently see any type of support
for this in current RHEL5.1 or SUSE userspace.

If the answer to the latter question is yes it would seem much easier
to have some type of DEVICE=md hotplug event triggered in order to
more precisely target the needed intervention.  Currently the only
solution seems to be to grope through all the configured MD devices to
try and figure out what to do with a device removal event.

Al sorry to force you to wade through this but if my analysis is
correct you can add this as fodder to your sysfs locking/lifetime
rants... :-)

Once again I apologize for bringing this up against 'old' kernels but
since we needed to instrument this on production systems we were
somewhat limited in our choices.  If all this has been fixed in 2.6.2[45]
let me know since we would obviously want to use those kernels as
replacements on the RHEL5.1 platforms.

Let me know if additional information or clarification is needed.

Best wishes for a pleasant weekend.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Given a choice between a complex, difficult-to-understand,
 disconcerting explanation and a simplistic, comforting one, many
 prefer simplistic comfort if it's remotely plausible, especially if it
 involves blaming someone else for their problems."
                                -- Bob Lewis
                                   _Infoworld_
