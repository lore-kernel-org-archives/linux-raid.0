From: Don Feliciano <don.feliciano@runbox.com>
Subject: kernel panic reading root disk (s/w raid0)
Date: Wed, 02 Nov 2005 22:02:55 -0500
Message-ID: <43697DDF.1070003@runbox.com>
Reply-To: donf.lists@runbox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  The error:  sh-2006: read_super_block: bread failed (dev md0, block2, 
size 4096)

My config works fine with kernel 2.6.12.  2.6.13 (I've tried everything 
from make oldconfig to a complete
make xconfig walk-through) panics with error above no matter how I 
compile it.

Could I really have a bad superblock?  Why would my 2.6.12 work if that 
were the case?  Also, I tried replacing mdadm.conf with output of mdadm 
--detail -s  Doing so caused 2.6.12 to fail, too (though on md5 not md0, 
so I could boot single user)

My distro is Gentoo.  Any help appreciated!  (I want to follow ~stable)

/boot/grub/grub.conf (relevant portion):

title=Gentoo Linux 2.6.12-r10
root (hd0,0)
kernel /kernel-2.6.12-gentoo-r10 ro root=/dev/md0

/etc/fstab (relevant portion):

/dev/md0    /           reiserfs    noatime                    1 1
/dev/sda1   /boot       ext2        noauto,noatime             1 2
/dev/md1    /usr        reiserfs    noatime                    1 2
/dev/md2    /var        reiserfs    noatime,notail             1 2
/dev/md3    /tmp        reiserfs    noatime,notail             1 2
/dev/md4    /export     reiserfs    noatime,notail             1 2
/dev/md5    /opt        reiserfs    noatime                    1 2
/dev/md6    /fs0        reiserfs    noatime,notail             1 2
/dev/sda10  none        swap        sw,pri=1                   0 0
/dev/sdb10  none        swap        sw,pri=1                   0 0

/etc/mdadm.conf:

DEVICE /dev/sda5 /dev/sdb5
DEVICE /dev/sda6 /dev/sdb6
DEVICE /dev/sda7 /dev/sdb7
DEVICE /dev/sda8 /dev/sdb8
DEVICE /dev/sda9 /dev/sdb9
DEVICE /dev/sda11 /dev/sdb11
DEVICE /dev/sda12 /dev/sdb12

ARRAY /dev/md0 devices=/dev/sda5,/dev/sdb5
ARRAY /dev/md1 devices=/dev/sda6,/dev/sdb6
ARRAY /dev/md2 devices=/dev/sda7,/dev/sdb7
ARRAY /dev/md3 devices=/dev/sda8,/dev/sdb8
ARRAY /dev/md4 devices=/dev/sda9,/dev/sdb9
ARRAY /dev/md5 devices=/dev/sda11,/dev/sdb11
ARRAY /dev/md6 devices=/dev/sda12,/dev/sdb12

