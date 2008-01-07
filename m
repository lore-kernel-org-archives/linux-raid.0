From: Radu Rendec <radu.rendec@ines.ro>
Subject: Raid 1, new disk can't be added after replacing faulty disk
Date: Mon, 07 Jan 2008 15:44:48 +0200
Message-ID: <1199713488.3202.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm experiencing trouble when trying to add a new disk to a raid 1 array
after having replaced a faulty disk.

A few details about my configuration:

# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md1 : active raid1 sdb3[1]
      151388452 blocks super 1.0 [2/1] [_U]
      
md0 : active raid1 sdb2[1]
      3911816 blocks super 1.0 [2/1] [_U]
      
unused devices: <none>

# uname -a
Linux i.ines.ro 2.6.23.8-63.fc8 #1 SMP Wed Nov 21 18:51:08 EST 2007 i686
i686 i386 GNU/Linux

# mdadm --version
mdadm - v2.6.2 - 21st May 2007

So the story is this: disk sda failed and was physically replaced with a
new one. The new disk is identical and was partitioned exactly the same
way (as the old one and sdb). Getting sda2 (from the fresh empty disk)
to the array does not work. This is what happens:

# mdadm /dev/md0 -a /dev/sda2
mdadm: add new device failed for /dev/sda2 as 2: Invalid argument

Kernel messages follow:
md: sda2 does not have a valid v1.0 superblock, not importing!
md: md_import_device returned -22

It's obvious that sda2 does not have a superblock (at all) since it's a
fresh empty disk. But I expected mdadm to create the superblock and
start rebuilding the array immediately.

However, this happens with both mdadm 2.6.2 and 2.6.4. I downgraded to
2.5.4 and it works like a charm.

If you reply, please add me to cc - I am not subscribed to the list.
Should I provide you further details or any kind of assistance for
testing, please let me know.

Thanks,

Radu Rendec

