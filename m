From: ariel.work@fmgirl.com
Subject: Re: Request for help with "1st time through" RAID array renaming
Date: Wed, 14 Aug 2013 10:27:18 -0700
Message-ID: <1376501238.20717.9810207.70E4DA12@webmail.messagingengine.com>
References: <1376497589.7879.9787867.21A861C2@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376497589.7879.9787867.21A861C2@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doing 'my homework', to my read, this is what I think needs to be done. 
Am I right?

In general

(1) Boot from a LiveCD
(2) stop the arrays
(3) make changes

The details should look like this.

1st checking

	cat /proc/mdstat  | grep ^md
		md0 : active raid1 sda1[0] sdb1[1]
		md1 : active raid1 sdb2[2] sda2[0]
		md2 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]


???     QUESTION:  Why does the 'md1' line refer to "[2]" & "[0]"?  Why
is there no "[1]" instead of "[2]"?  Is this a problem that needs
fixing?

For

	mdadm --detail --scan
		ARRAY /dev/md0         metadata=0.90                
		UUID=xxx...
		ARRAY /dev/md/Rescue:1 metadata=1.0  name=Rescue:1  
		UUID=yyy...
		ARRAY /dev/md2         metadata=1.2  name=server:md2
		UUID=zzz...

I'd do this?

	mdadm --stop /dev/md0
	mdadm --stop /dev/md/Rescue:1
	mdadm --stop /dev/md2

	mdadm --uuid=xxx... --update=super-minor --assemble /dev/md0
	/dev/sd[ab]1
	mdadm --uuid=yyy... --update=super-minor --assemble /dev/md1
	/dev/sd[ab]2
	mdadm --uuid=zzz... --update=super-minor --assemble /dev/md2
	/dev/sd[cdef]1

	mdadm --stop /dev/md0
	mdadm --stop /dev/md1
	mdadm --stop /dev/md2

	mdadm --uuid=xxx... --update=name --name=server1_boot   
	--homehost="<none>" --assemble /dev/md0  /dev/sd[ab]1
	mdadm --uuid=yyy... --update=name --name=server1_root   
	--homehost="<none>" --assemble /dev/md1  /dev/sd[ab]2
	mdadm --uuid=zzz... --update=name --name=server1_storage
	--homehost="<none>" --assemble /dev/md2  /dev/sd[cdef]1

Then EDIT

	/etc/mdadm.conf
+               HOMEHOST <ignore>
		CREATE owner=root group=disk mode=0660 auto=yes
		DEVICE /dev/disk/by-id/ata-[DISK1]-part2
		/dev/disk/by-id/[DISK2]-part2
		DEVICE /dev/disk/by-id/ata-[DISK1]-part1
		/dev/disk/by-id/[DISK2]-part1
		DEVICE /dev/disk/by-id/ata-[DISK3]-part1
		/dev/disk/by-id/ata-[DISK4]-part1
		/dev/disk/by-id/ata-[DISK5]-part1
		/dev/disk/by-id/ata-[DISK6]-part1
-               ARRAY /dev/md0  level=raid1  num-devices=2 metadata=0.90
UUID=xxx...
-               ARRAY /dev/md1  level=raid1  num-devices=2 metadata=1.00
UUID=yyy...
-               ARRAY /dev/md2  level=raid10 num-devices=4 metadata=1.02
name=server:md2 UUID=zzz...
+               ARRAY /dev/md0  level=raid1  num-devices=2 metadata=0.90
name=server1_boot    UUID=xxx...
+               ARRAY /dev/md1  level=raid1  num-devices=2 metadata=1.00
name=server1_boot    UUID=yyy...
+               ARRAY /dev/md2  level=raid10 num-devices=4 metadata=1.02
name=server1_storage UUID=zzz...

and finally, 

	mkinitrd
	reboot

How's that look?

Ariel
