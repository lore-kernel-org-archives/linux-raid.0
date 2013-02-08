From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Fri, 08 Feb 2013 11:22:20 -0800
Message-ID: <csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
References: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again everyone,

On 2013-02-07, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>
> # mdadm /dev/md127  --remove /dev/sdg
> mdadm: hot remove failed for /dev/sdg: Device or resource busy

In poking around a little bit more, I have noticed something strange
about sdg.  While the controller does not think that the device exists,
it seems like udev still does (see below).  Could this be the root of
the problem, and if so, what would be the canonical way of cleaning up
after the device failure?  I realize that this may be a udev issue, not
md, so feel free to point me elsewhere if that's the case.  (I stumbled
across this when I tried to do mdadm --remove detached; when it failed,
I wondered whether sdg had not been completely and cleanly detached.)

I do feel like it would be handy to be able to tell mdadm that the
device is really gone, and remove it even if it still seems available.
From my reading of man mdadm --remove does not accept the --force
switch; would it make sense to apply it to a scenario like this?

udevadm output below.  Thanks for any help you can provide!

--keith

# udevadm info --name=sdg --query=all
P: /devices/pci0000:00/0000:00:0b.0/0000:01:03.0/host2/target2:0:5/2:0:5:0/block/sdg
N: sdg
W: 62
S: block/8:96
S: disk/by-id/scsi-1AMCC_A39978163451AD0014B2
S: disk/by-path/pci-0000:01:03.0-scsi-0:0:5:0
E: UDEV_LOG=3
E: DEVPATH=/devices/pci0000:00/0000:00:0b.0/0000:01:03.0/host2/target2:0:5/2:0:5:0/block/sdg
E: MAJOR=8
E: MINOR=96
E: DEVNAME=/dev/sdg
E: DEVTYPE=disk
E: SUBSYSTEM=block
E: MPATH_SBIN_PATH=/sbin
E: ID_SCSI=1
E: ID_VENDOR=AMCC
E: ID_VENDOR_ENC=AMCC\x20\x20\x20\x20
E: ID_MODEL=9550SX-16M_DISK
E: ID_MODEL_ENC=9550SX-16M\x20DISK\x20
E: ID_REVISION=3.08
E: ID_TYPE=disk
E: ID_SERIAL_RAW=1AMCC    A39978163451AD0014B2
E: ID_SERIAL=1AMCC_A39978163451AD0014B2
E: ID_SERIAL_SHORT=AMCC_A39978163451AD0014B2
E: ID_SCSI_SERIAL=A39978163451AD0014B2
E: ID_BUS=scsi
E: ID_PATH=pci-0000:01:03.0-scsi-0:0:5:0
E: ID_FS_UUID=f660639e-5b75-83ae-4c69-519fea7c8c31
E: ID_FS_UUID_ENC=f660639e-5b75-83ae-4c69-519fea7c8c31
E: ID_FS_UUID_SUB=ac6554bb-e745-6f14-db0f-131e06df8990
E: ID_FS_UUID_SUB_ENC=ac6554bb-e745-6f14-db0f-131e06df8990
E: ID_FS_LABEL=XXXXX:0
E: ID_FS_LABEL_ENC=XXXXX:0
E: ID_FS_VERSION=1.2
E: ID_FS_TYPE=linux_raid_member
E: ID_FS_USAGE=raid
E: LVM_SBIN_PATH=/sbin
E: DEVLINKS=/dev/block/8:96 /dev/disk/by-id/scsi-1AMCC_A39978163451AD0014B2 /dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:5:0



-- 
kkeller@wombat.san-francisco.ca.us


