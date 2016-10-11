From: moft@fmailbox.com
Subject: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Tue, 11 Oct 2016 10:26:55 -0700
Message-ID: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have a 4-disk RAID10 array

	md0 : active raid10 sda1[4] sdb1[3] sdc1[2] sdd1[1]
	      1953259520 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
	      bitmap: 0/15 pages [0KB], 65536KB chunk

It was created with this command

	mdadm --create /dev/md0 --level=raid10 --raid-devices=4 \
	 --name=md0 --homehost="<none>" \
	 --metadata=1.2 --bitmap=internal --layout=f2 --chunk=512  \
	 /dev/sd[abcd]1

It's running on a linux machine

	uname -rm
		4.8.1-2.g4861355-default x86_64
	mdadm --version
		mdadm - v3.3.1 - 5th June 2014

I need to add storage to the array.

I'd like to grow it by adding two disks (/dev/sd[ef]), to end up with a 6-disk array.

I know I can completely wipe it out and recreate it with 6-disks.

But I'd rather grow/extend it, Instead.

*CAN* I safely grow/expand it?

The ChangeLog for mdadm 3.3.1 says

	Changes Prior to release 3.3
	- Some array reshapes can proceed without needing backup file.
	  This is done by changing the 'data_offset' so we never need to write
	  any data back over where it was before.  If there is no "head space"
	  or "tail space" to allow data_offset to change, the old mechanism
	  with a backup file can still be used.
	- RAID10 arrays can be reshaped to change the number of devices,
	  change the chunk size, or change the layout between 'near'
	  and 'offset'.
	  This will always change data_offset, and will fail if there is no
	  room for data_offset to be moved.

So far I haven't found any specific "how to" for this process.

(1) The changelog refers to 'near' and 'offset' layouts, but doesn't mention 'far'.

CAN I safely grow this layout=f2 array ?

(2) If I can, what's the detailed procedure to do it?

Thanks

Mike
