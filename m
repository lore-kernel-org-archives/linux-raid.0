From: ariel.work@fmgirl.com
Subject: Request for help with "1st time through" RAID array renaming
Date: Wed, 14 Aug 2013 09:26:29 -0700
Message-ID: <1376497589.7879.9787867.21A861C2@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

I inherited a bunch of servers with RAID arrays.  I'm doing a bunch of
housekeeping/cleanup, documentation, etc.

In this step I want to get RAID array naming straightened out.

I read the mdadm manpage for

	[create, build, grow]
	-N, --name=

and I _think_ that to set an array name, and also to REname it?, I need
to do

	sudo mdadm --assemble <array device> --name=NewName
	--update=OldName <array's drives>

I'm a bit sketchy on the exact steps to do that though.  Well, the exact
steps to do that AND to NOT! screw things up!

Do I have to boot from a different disk, unmounting the arrays?
Disassembling them?  etc?

I'd like to learn how to do this right.

Here's an example of what's running on one server.  The OS is Opensuse.

	uname -a
		Linux arieltest.local 3.7.10-1.16-desktop #1 SMP PREEMPT
		Fri May 31 20:21:23 UTC 2013 (97c14ba) x86_64 x86_64
		x86_64 GNU/Linux
	rpm -q mdadm
		mdadm-3.2.6-3.4.1.x86_64

Its got three arrays attached.

	v0.90 RAID-1  <-- "/boot"
	v1.00 RAID-1  <-- ROOT
	v1.02 RAID-10 <-- storage

I can't say why these were configured that way (that admin's long gone
:-( ).  Once I get things all cleaned up around here, I'll start with a
next-gen plan from scratch.  But for the time being, this is what I'm
working with.

This system boots OK.  The arrays report as

	mdadm --detail --scan
	  ARRAY /dev/md0         metadata=0.90                
	  UUID=xxx...
	  ARRAY /dev/md126       metadata=1.00 name=Rescue:1  
	  UUID=yyy...
	  ARRAY /dev/md2         metadata=1.02 name=server:md2
	  UUID=zzz...

	mdadm -D -s
	  ARRAY /dev/md0         metadata=0.90                
	  UUID=xxx...
	  ARRAY /dev/md/Rescue:1 metadata=1.0  name=Rescue:1  
	  UUID=yyy...
	  ARRAY /dev/md2         metadata=1.2  name=server:md2
	  UUID=zzz...

Not sure why the devices are different between the two, or if that's a
problem.

The config file is

	cat /etc/mdadm.conf
		CREATE owner=root group=disk mode=0660 auto=yes
		DEVICE /dev/disk/by-id/ata-[DISK1]-part2
		/dev/disk/by-id/[DISK2]-part2
		DEVICE /dev/disk/by-id/ata-[DISK1]-part1
		/dev/disk/by-id/[DISK2]-part1 
		DEVICE /dev/disk/by-id/ata-[DISK3]-part1
		/dev/disk/by-id/ata-[DISK4]-part1
		/dev/disk/by-id/ata-[DISK5]-part1
		/dev/disk/by-id/ata-[DISK6]-part1
		ARRAY /dev/md0  level=raid1  num-devices=2 metadata=0.90
		UUID=xxx...
		ARRAY /dev/md1  level=raid1  num-devices=2 metadata=1.00
		UUID=yyy...
		ARRAY /dev/md2  level=raid10 num-devices=4 metadata=1.02
		name=server:md2 UUID=zzz...

I want to end up with

	boot ARRAY,    device == /dev/md0, name == server1_boot
	ROOT ARRAY,    device == /dev/md1, name == server1_root
	storage ARRAY, device == /dev/md2, name == server1_storage

and have

	mdadm --detail --scan
	mdadm -D -s

both report a consistent story.

To "get there", I need to 1st boot from another drive, right?  Like a
LiveCD, and -- at least -- unmount the arrays?

Do I need to 'break' or disassemble them?

Guess I'm looking for a little hand-holding on this once through.

Thanks a lot for any help!

Ariel
