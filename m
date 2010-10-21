From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: problems with "LSISAS2008 6Gb/s SAS" kernel mpt2sas driver
Date: Thu, 21 Oct 2010 09:31:59 +0200
Message-ID: <20101021073159.GA30734@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I am setting up a new Dell T610 server with 8 WD Black Caviar sata3 1TB
disks on a LSISAS2008 controller:

	Oct 21 09:12:37 grml kernel: [   83.377388] mpt2sas0: LSISAS2008: FWVersion(02.1
5.63.00), ChipRevision(0x02), BiosVersion(07.01.09.00)

My layout is as follows:

- small un-encrypted raid1 boot partition on /dev/md0

- dm-crypt main partition on /dev/md1 (actuallly /dev/mapper/cmd1)

A recent grml64 is used to create the partitions, install the system and
run lilo.

When running lilo I get these errors from the controller:

	Oct 21 08:57:11 grml kernel: [40832.015207] mpt2sas0: fault_state(0x265d)!
	Oct 21 08:57:11 grml kernel: [40832.015210] mpt2sas0: sending diag reset !!
	Oct 21 08:57:12 grml kernel: [40833.209839] mpt2sas0: diag reset: SUCCESS
	Oct 21 08:57:12 grml ata_id[3570]: HDIO_GET_IDENTITY failed for '/dev/sde'
	Oct 21 08:57:13 grml kernel: [40833.407078] mpt2sas0: LSISAS2008: FWVersion(02.15.63.00), ChipRevision(0x02), BiosVersion(07.01.09.00)
	Oct 21 08:57:13 grml kernel: [40833.407084] mpt2sas0: Dell PERC H200 Integrated: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1E)
	Oct 21 08:57:13 grml kernel: [40833.407087] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)

etc.. and then all disks are kicked out of /dev/md1:

	Oct 21 08:57:20 grml kernel: [40840.361581] md: super_written gets error=-5, uptodate=0
	Oct 21 08:57:20 grml kernel: [40840.361586] md/raid:md1: Disk failure on sdd2, disabling device.
	Oct 21 08:57:20 grml kernel: [40840.361587] <1>md/raid:md1: Operation continuing on 0 devices.

But on another attempt /dev/md0 was stopped as well.

Any suggestion on fixing that problem would be welcome. I can send more
complete logs.

Thanks,
