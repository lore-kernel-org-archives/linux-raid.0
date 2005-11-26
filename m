From: "David M. Strang" <dstrang@shellpower.net>
Subject: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 26 Nov 2005 11:18:10 -0500
Message-ID: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all --

I've read, and read, and read -- and I'm still not having ANY luck booting 
completely from a raid1 device.

This is my setup...

sda1 is booting, working great. I'm attempting to transition to a bootable 
raid1.

sdb1 is a 400GB partition -- it is type FD.

Disk /dev/sdb: 400.0 GB, 400088457216 bytes
2 heads, 4 sectors/track, 97677846 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1    97677846   390711382   fd  Linux raid 
autodetect

I have created my raid1 mirror with the following command:

mdadm --create /dev/md_d0 -e1 -ap --level=1 --raid-devices=2 
missing,/dev/sdb1

The raid created correctly, I then partitioned md_d0 to match sda1.



Disk /dev/sda: 400.0 GB, 400088457216 bytes
2 heads, 4 sectors/track, 97677846 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1    25000000    99999998   83  Linux
/dev/sda2        25000001    95677734   282710936   83  Linux
/dev/sda3        95677735    96177734     2000000   83  Linux
/dev/sda4        96177735    97677824     6000360   82  Linux swap / Solaris


Disk /dev/md_d0: 400.0 GB, 400088444928 bytes
2 heads, 4 sectors/track, 97677843 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d0p1   *           1    25000000    99999998   83  Linux
/dev/md_d0p2        25000001    95677734   282710936   83  Linux
/dev/md_d0p3        95677735    96177734     2000000   83  Linux
/dev/md_d0p4        96177735    97677843     6000436   82  Linux swap / 
Solaris


Here is my lilo.conf settings; I'm attempting to get it to mount md_d0 when 
the kernel starts. I realize that automount (type FD) no longer functions 
with a version-1 superblock.

#
# /etc/lilo.conf: lilo(8) configuration, see lilo.conf(5)
#

lba32
install=text
boot=/dev/sda
map=/boot/System.map
image=/vmlinuz
        label=CRUX
        root=/dev/sda1
        read-only
        append="quiet md=d0,/dev/sdb1"

# End of file


Without fail, every time the system boots -- I get the following message:

md: invalid raid superblock magic on sdb1

The odd thing is; if I login -- I can execute the following:

-(root@xenogenesis)-(~)- # mdadm -A /dev/md_d0 /dev/sdb1
mdadm: /dev/md_d0 has been started with 1 drive (out of 2).
-(root@xenogenesis)-(~)- # mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 0d7a60d0:af2843fe:cde2a4dc:207bbd63
           Name : CRUX x64
  Creation Time : Sat Nov 26 03:24:23 2005
     Raid Level : raid1
   Raid Devices : 2

    Device Size : 781422744 (372.61 GiB 400.09 GB)
   Super Offset : 781422744 sectors
          State : clean
    Device UUID : 86be5e9e:b7c740ab:46bfb508:090a0e42
    Update Time : Sat Nov 26 04:03:43 2005
       Checksum : ebed5cb5 - correct
         Events : 168


   Array State : _U 1 failed
-(root@xenogenesis)-(~)- # mdadm -Q /dev/sdb1
/dev/sdb1: is not an md array
/dev/sdb1: device 1 in 2 device unknown raid1 array.  Use mdadm --examine 
for more detail.


I'm really confused; mdadm seems to recognize it and load it fine... why 
can't I get the kernel to load it?

-- David M. Strang 

