From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 17:09:30 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02d201c33023$13fd45a0$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm using a 2.4.18-ac3 kernel and the multipath module in order to ensure
automatic IO path failover. The systems connect to a FC SAN environment.
New logical disks are added/removed from the SAN periodically.

Unfortunatelly, linux's raid subsystem uses major and minor numbers in the
superblock in order to identify members for all raid types - including
multipath. This causes the multipath module to fail when attempting to
identify the members. When the scsi driver is loaded, the bus is scanned and
all the available devices/targets/luns are added to the scsi subsystem and
are allocated a major and minor number.

Say initially, the following are available

scsi1, bus0, target0, lun0
scsi1, bus0, target0, lun1
scsi1, bus0, target0, lun2
scsi2, bus0, target0, lun0
scsi2, bus0, target0, lun1
scsi2, bus0, target0, lun2

They will be mapped as

/dev/sda
/dev/sdb
/dev/sdc
/dev/sdd
/dev/sde
/dev/sdf

and

8,0
8,16
8,32
8,48
8,64
8,80

majors,minors respectivelly.

The disks with LUNs 0, 1, 2 are the same but are viewed on two paths:

/dev/sda - /dev/sdd
/dev/sdb - /dev/sde
/dev/sdc - /dev/sdf

Multipath is created in this configuration and works properly.

Now LUN1 is removed. The new configuration is:

scsi1, bus0, target0, lun0
scsi1, bus0, target0, lun2
scsi2, bus0, target0, lun0
scsi2, bus0, target0, lun2

Unfortunatelly, majors and minors became
8,0
8,16
8,32
8,48
So scsi1, bus0, target0, lun2 is now 8,16 instead of 8,32

However, the raid superblock still has 8,32 in it - this confuses
multipath - I even managed to get it crashing really ugly at some point.
The problem is partially caused by md identifying devices based on
major,minor and partially caused by the fact the the scsi subsystem has no
way (afaik) of mapping device,channel,target,lun to major,minor pairs.
This mapping is being performed dynamically by devfs for user-space
programs, but kernel modules that need to access devices via major,minor
have this problem.

Is there something I am missing? Is this a lack in the kernel?

Thanks,
Ionut

