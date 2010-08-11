From: Doug <doug.duboulay@gmail.com>
Subject: debian dist-upgrade etch -> squeeze broke my mdadm RAID1
Date: Wed, 11 Aug 2010 15:27:36 +1000
Message-ID: <201008111527.37009.Doug.duBoulay@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I had a PC running a XEN 2.6.18 kernel with two 350Gb disks 
configured as RAID1 with ext3 root dom0 on /dev/md0  (5Gb) and 
the remainder allocated to /dev/md1 managed with lvm for my 
XEN domU client OS's.

I needed a recent kernel/drivers to access some new hardware in Dom0 so 
ran apt-get dist-upgrade (after some initial trouble with 
incompatible dpkg versions but thats irrelevant).
After the upgrade and installation of a new 2.6.32 kernel, the kernel
wouldn't boot because it couldn't find the root partition - it 
dropped into the BusyBox/initramfs prompt.

The md devices were /dev/md/imsm0 sym linked to /dev/md127

Fortunately I was able to reboot my original 2.6.18 kernel from GRUB


$ dpkg-reconfigure mdadm

Generating array device nodes... done.
update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-686
W: mdadm: unchecked configuration file: /etc/mdadm/mdadm.conf
W: mdadm: please read /usr/share/doc/mdadm/README.upgrading-2.5.3.gz .
I: mdadm: auto-generated temporary mdadm.conf configuration file.
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=low mdadm` to change this.

basically, this runs the script: /usr/share/mdadm/mkconf
which evaluates the expression

  if ! $MDADM --examine --scan --config=partitions; then

and adds the result to the file /etc/mdadm/mdadm.conf

$ mdadm --examine --scan
ARRAY metadata=imsm UUID=9a1dfb7e:5783ddc7:a614552a:eb9c1135
ARRAY /dev/md/Volume0 container=9a1dfb7e:5783ddc7:a614552a:eb9c1135 member=0 
UUID=42f9906a:f4c0a788:5a5a74eb:154a22ef
ARRAY /dev/md0 UUID=74553564:5d83fae3:8520d040:09f92738
ARRAY /dev/md1 UUID=f5971c98:57f6fca7:5a7f0c3a:4f19787a

I am guessing that at boot, the initramfs(?) 2.6.32  kernel 
doesn't understand the /dev/md/Volume0 line and its builtin 
mdadm aborts before assembling the /dev/md0 and /dev/md1 partitions.

If I replace --examine with --detail in /usr/share/mdadm/mkconf, i.e.

  if ! $MDADM --detail --scan --config=partitions; then

$ mdadm --detail --scan
ARRAY /dev/md0 metadata=0.90 UUID=74553564:5d83fae3:8520d040:09f92738
ARRAY /dev/md1 metadata=0.90 UUID=f5971c98:57f6fca7:5a7f0c3a:4f19787a

and rerun 
$ dpkg-reconfigure mdadm

Now /dev/md0 is assembled and mounted as root and my 2.6.32
kernel boots. Problem sussed. But what was really going wrong and why?
I read that devices with superblock (metadata=?) version 0.9 are 
automatically assembled by the kernel at boot time, but apparently that
didn't happen.


Thanks
Doug

P.S.

ii  linux-image-2.6.18-6-xen-686             2.6.18.dfsg.1-26etch2 
ii  linux-image-2.6.32-5-xen-686             2.6.32-18 
ii  mdadm                                    3.0.3-2
ii  initramfs-tools                          0.97.2
ii  lvm2                                     2.02.66-2


mdadm --examine /dev/sda 
/dev/sda:                                 
          Magic : Intel Raid ISM Cfg Sig. 
        Version : 1.1.00                  
    Orig Family : 00000000                
         Family : 828006a6                
     Generation : 00000d7f                
           UUID : 9a1dfb7e:5783ddc7:a614552a:eb9c1135
       Checksum : 4b2aa46c correct                   
    MPB Sectors : 2                                  
          Disks : 2                                  
   RAID Devices : 1                                  

  Disk00 Serial : 9SZ0EQJ2
          State : active  
             Id : 00000000
    Usable Size : 625137934 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : 42f9906a:f4c0a788:5a5a74eb:154a22ef
     RAID Level : 1
        Members : 2
      This Slot : 0
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137664 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: repair
      Map State : normal <-- normal
    Dirty State : dirty

  Disk01 Serial : 9SZ0EH35
          State : active
             Id : 00000100
    Usable Size : 625137934 (298.09 GiB 320.07 GB)




