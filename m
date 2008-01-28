From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Unable to eradicate previous version of device information, even
 with zero-superblock and dd
Date: Mon, 28 Jan 2008 09:05:24 -0600
Message-ID: <479DEF34.70306@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been trying to bring up a RAID10 device, and I'm having some 
difficulty with automatically-created device names.

mdadm version 2.5.6, Debian Etch.

With metadata=1.2 in my config file,

mdadm --create /dev/md/all --auto=p7 -n 4 --level=10 /dev/sd*2

This does seem to create a RAID array. I see that my /dev/md/ directory 
is populated with all1 through all7.

On reboot, however, I notice that there's a suddenly a /dev/md127 
device. Confused, I attempted to start over many times, but I can't seem 
to create a non-"all" array and I can't seem to create a simple 
/dev/md/0 array.

Steps:

To eradicate all prior traces of md configuration, I issue these commands:

mdadm --stop /dev/md/all

which stops.

mdadm --zero-superblock  /dev/sd[each drive]2


I went further (after some trouble) and issued

dd if=/dev/zero of=/dev/sd[each drive]2 count=2M

I then issue:

rm /dev/md* /dev/md/*

The ARRAY information is commented out of the config file (mdadm.conf).

On reboot, I see that the devices /dev/md/all, /dev/md/all1, etc. have 
reappeared, along /dev/md127, /dev/md_127, and /dev/md_d127.

This is very, very puzzling.

Well, I thought I could work around this. I issued

mdadm --create /dev/md/all

with the same paramters as above. I can use cfdisk and fdisk (either 
one) to create two partitions, /dev/md/all1 and /dev/md/all2.

However,

mkfs.reiserfs /dev/md/all1

claims that the /dev/md/all1 has "no such device or address."

ls -l /dev/md/all gives

brw-rw---- 1 root disk 254, 8129 (date) /dev/md/all1

QUESTIONS:

1. If I create a device called /dev/md/all, should I expect that mdadm 
will create a device called /dev/md/127, and that mdadm --detail --scan 
will report it as /dev/md127 or something similar?

2. How can I completely eradicate all traces of previous work, given 
that zero-superblock and dd on the drives that make up the array doesn't 
seem to erase previous information?



-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "If you're going to shoot, shoot! Don't talk!"
    		   -- Eli Wallach,"The Good, the Bad, and the Ugly"
