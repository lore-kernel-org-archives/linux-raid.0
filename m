From: Andy Bailey <andy@hazlorealidad.com>
Subject: Re: sdb failure - mdadm: no devices found for /dev/md0
Date: Tue, 28 Jul 2009 08:05:36 -0500
Message-ID: <1248786336.13147.172.camel@localhost.localdomain>
References: <1248711579.13147.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1248711579.13147.75.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

More info:

In the initrd the mdadm.conf has
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90
UUID=392f9510:37d5d89a:d9143456:0dceb00d

In the /etc/mdadm.conf (for that root partition)
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=2d10ee45:1a407729:ec85deb0:7e9ea950

The rest of the UUID entries are identical in the 2 mdadm.confs.

So its now clear what the problem was.

However, I still dont know how the problem happened.

What could have caused he UUID for the root filesystem to change.
Anaconda installed it to md0 and the only thing that we had done was
grow the filesystem to 3 partitions and add a third partition, as I
mentioned in my previous email.

Could yum have installed a kernel upgrade that changed the UUID???

Also why didnt the kernel options md=0,/dev/sda1,/dev/sdb1 override the
settings in mdadm.conf?

Is the syntax correct?
If its not correct doesnt the kernel print an error message?

The kernel we were running was 2.6.27.24-170.2.68.fc10.x86_64

It also doesnt explain why mkinitrd didnt do anything using the rescue
disk, no delay, no message, no file.

On the new system it works as expected
mkinitrd test 2.6.27.24-170.2.68.fc10.x86_64

creates the initrd "test" in the current directory
and if theres a typo it reports
No modules available for kernel ....

Any ideas?

Thanks in advance

Andy Bailey

--------------------------------------------------------------------
[root@servidor cron.daily]# cd /mnt/boot/

[root@servidor boot]# zcat initrd-2.6.27.24-170.2.68.fc10.x86_64.img
> /tmp/initrd
[root@servidor boot]# cd /tmp/
[root@servidor tmp]# mkdir init
[root@servidor tmp]# file initrd 
initrd: ASCII cpio archive (SVR4 with no CRC)
[root@servidor tmp]# man cpio
[root@servidor tmp]# cd init
[root@servidor init]# cpio -i --make-directories < ../initrd 
15858 blocks
[root@servidor init]# cd etc

[root@servidor etc]# cat mdadm.conf 

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR root

ARRAY /dev/md1 level=raid1 num-devices=2 metadata=0.90
UUID=ed127569:52ff37b7:da473d79:03ebe556
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90
UUID=392f9510:37d5d89a:d9143456:0dceb00d
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=0.90
UUID=c964f385:5b6e5d18:2d631c3c:e70b1b22
ARRAY /dev/md9 level=raid1 num-devices=2 metadata=0.90
UUID=1ab3d6b5:575a8a2b:dfa789fa:805a401f
ARRAY /dev/md8 level=raid1 num-devices=2 metadata=0.90
UUID=318d1ff4:dd2b9ccc:7effe40e:a3e412fc
ARRAY /dev/md7 level=raid1 num-devices=2 metadata=0.90
UUID=0114a14e:b6a45be8:3a719518:7cb31784
ARRAY /dev/md6 level=raid1 num-devices=2 metadata=0.90
UUID=03254e0d:86de6727:2ff70881:773bec64
ARRAY /dev/md5 level=raid1 num-devices=2 metadata=0.90
UUID=644a897a:15ef0e34:833f147a:71729df0
ARRAY /dev/md4 level=raid1 num-devices=2 metadata=0.90
UUID=988ecde9:cc998c1b:c50949cb:adc77570
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=0.90
UUID=e7b76f39:7c6d5185:3b70f7bd:4b6284f5

[root@servidor etc]# cat /mnt/etc/mdadm.conf 

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR root

ARRAY /dev/md2 level=raid1 num-devices=2
UUID=c964f385:5b6e5d18:2d631c3c:e70b1b22
ARRAY /dev/md4 level=raid1 num-devices=2
UUID=988ecde9:cc998c1b:c50949cb:adc77570
ARRAY /dev/md3 level=raid1 num-devices=2
UUID=e7b76f39:7c6d5185:3b70f7bd:4b6284f5
ARRAY /dev/md8 level=raid1 num-devices=2
UUID=318d1ff4:dd2b9ccc:7effe40e:a3e412fc
ARRAY /dev/md7 level=raid1 num-devices=2
UUID=0114a14e:b6a45be8:3a719518:7cb31784
ARRAY /dev/md6 level=raid1 num-devices=2
UUID=03254e0d:86de6727:2ff70881:773bec64
ARRAY /dev/md5 level=raid1 num-devices=2
UUID=644a897a:15ef0e34:833f147a:71729df0
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=2d10ee45:1a407729:ec85deb0:7e9ea950
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=ed127569:52ff37b7:da473d79:03ebe556
ARRAY /dev/md9 level=raid1 num-devices=2
UUID=1ab3d6b5:575a8a2b:dfa789fa:805a401f
[root@servidor etc]# cat /mnt/etc/mdadm.conf /tmp/init/etc/mdadm.conf |
sort

ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90
UUID=392f9510:37d5d89a:d9143456:0dceb00d
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=2d10ee45:1a407729:ec85deb0:7e9ea950

ARRAY /dev/md1 level=raid1 num-devices=2 metadata=0.90
UUID=ed127569:52ff37b7:da473d79:03ebe556
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=ed127569:52ff37b7:da473d79:03ebe556

ARRAY /dev/md2 level=raid1 num-devices=2 metadata=0.90
UUID=c964f385:5b6e5d18:2d631c3c:e70b1b22
ARRAY /dev/md2 level=raid1 num-devices=2
UUID=c964f385:5b6e5d18:2d631c3c:e70b1b22

ARRAY /dev/md3 level=raid1 num-devices=2 metadata=0.90
UUID=e7b76f39:7c6d5185:3b70f7bd:4b6284f5
ARRAY /dev/md3 level=raid1 num-devices=2
UUID=e7b76f39:7c6d5185:3b70f7bd:4b6284f5

ARRAY /dev/md4 level=raid1 num-devices=2 metadata=0.90
UUID=988ecde9:cc998c1b:c50949cb:adc77570
ARRAY /dev/md4 level=raid1 num-devices=2
UUID=988ecde9:cc998c1b:c50949cb:adc77570

ARRAY /dev/md5 level=raid1 num-devices=2 metadata=0.90
UUID=644a897a:15ef0e34:833f147a:71729df0
ARRAY /dev/md5 level=raid1 num-devices=2
UUID=644a897a:15ef0e34:833f147a:71729df0

ARRAY /dev/md6 level=raid1 num-devices=2 metadata=0.90
UUID=03254e0d:86de6727:2ff70881:773bec64
ARRAY /dev/md6 level=raid1 num-devices=2
UUID=03254e0d:86de6727:2ff70881:773bec64

ARRAY /dev/md7 level=raid1 num-devices=2 metadata=0.90
UUID=0114a14e:b6a45be8:3a719518:7cb31784
ARRAY /dev/md7 level=raid1 num-devices=2
UUID=0114a14e:b6a45be8:3a719518:7cb31784

ARRAY /dev/md8 level=raid1 num-devices=2 metadata=0.90
UUID=318d1ff4:dd2b9ccc:7effe40e:a3e412fc
ARRAY /dev/md8 level=raid1 num-devices=2
UUID=318d1ff4:dd2b9ccc:7effe40e:a3e412fc

ARRAY /dev/md9 level=raid1 num-devices=2 metadata=0.90
UUID=1ab3d6b5:575a8a2b:dfa789fa:805a401f
ARRAY /dev/md9 level=raid1 num-devices=2
UUID=1ab3d6b5:575a8a2b:dfa789fa:805a401f


