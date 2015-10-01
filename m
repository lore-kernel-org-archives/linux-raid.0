From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: mdraid + dm-multipath - non-dm-mulitpath boot md coexisting with
 dm-multi md data volume?
Date: Thu, 1 Oct 2015 11:55:16 -0700
Message-ID: <560D8194.2000502@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings,

I'm looking for advice on configuring mdadm.conf to allow for the 
coexisting of a non dm-multipath boot/root md device and a dm-multipath 
configured md device data volume.

The issue I am running into is that on boot mdraid assumes control of 
all disks with md superblocks on them before multipath starts. This 
appears to be due to the boot/root being md devices, multipath never 
gets to own the other disks in the system and then assemble on mpath 
devices in /dev/disk/by-id.

I have tried using DEVICE declarations in mdadm.conf but so far the 
result is either the boot volumes don't get recognized (assemble + 
switchroot fails) but the data volume gets assembled with dm-multipath 
devices, or the boot/root md devices assemble and the dm-multipath based 
md devices get assembled as sd member devices and dm-multipath is disabled.

Some of the DEVICE declarations I tried in mdadm.conf are below. Two on 
the same line or two separate lines. The non dm-mulitpath boot devices 
are Intel SATA SSDs on the onboard SATA ports. The dm-mulitpath RAID-10 
data volume is on an external SAS HBA with valid multipath 
configuration. I have remade the initramfs after these changes (dracut -f).

DEVICE /dev/disk/by-id/scsi-SATA_INTEL_SSD.*-.* 
/dev/disk/by-id/dm-uuid-.*-mpath-.*

and

DEVICE /dev/disk/by-id/scsi-SATA_INTEL_SSD.*-.*
DEVICE /dev/disk/by-id/dm-uuid-.*-mpath-.*

These examples find the SAS attached dm-multipath devices fine and 
assemble the mdraid volumes but the boot devices are not found or 
assembled. A look via rdshell shows the 
/dev/disk/by-id/scsi-SATA_INTEL_SSD.*-.* devices listed in the 
/dev/disk/by-id directory. It appears mdadm doesn't like the declaration 
for the SSDs and won't find them. I haven't been able to figure out why 
so far.

Current state (/proc/mdstat)
cat /proc/mdstat
Personalities : [raid1] [raid10]
md4 : active raid10 dm-11[3] dm-5[2] dm-7[1] dm-9[0]
       584615936 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 0/5 pages [0KB], 65536KB chunk

md3 : active raid1 dm-10[3] dm-2[2] dm-4[1] dm-8[0]
       521792 blocks super 1.2 [4/4] [UUUU]

md0 : active raid1 sdb1[1] sda1[0]
       255936 blocks super 1.0 [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       225653760 blocks super 1.1 [2/2] [UU]
       bitmap: 0/2 pages [0KB], 65536KB chunk

md1 : active raid1 sda2[0] sdb2[1]
       8380416 blocks super 1.1 [2/2] [UU]

unused devices: <none>

OS: CentOS 6.6 x86_64 2.6.32-504.el6.x86_64

If anyone has suggestions of how to configure a proper set of DEVICE 
declarations to assemble the SATA connected member drives of the 
boot/root volumes without relying on the default "DEVICE partitions 
containers" where the multipath devices get assembled as sd devices 
prior to multipath starting I would appreciate the advice.

Thanks,

--Jeff
