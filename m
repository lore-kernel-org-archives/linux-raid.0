From: Healy <news@nwgeeks.com>
Subject: Re: root raid problems
Date: Sat, 20 Jul 2002 05:48:26 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020720054639Z317367-685+14542@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I fixed it.  The following entries were added to lilo.conf:

disk    = /dev/sda                
  bios  = 0x80                    
disk    = /dev/sdb                
    bios  = 0x81                    
boot    = /dev/sda        

I also had to have /boot mounted on both /boot and on /mnt/slash/boot
in order for lilo to execute w/out errors.  

-Healy

In message <20020720044840Z317361-686+2561@vger.kernel.org>, Healy writes:
>
>I've been trying to setup a root raid with out much luck.  I have
>raid running for everything else.  Whenever I run lilo for that 
>partition I get an error stating 'Fatal: open /boot/boot.b: No 
>such file or directory'.  The file is there however.  
>
>System is setup with:
>
>/dev/hda as the install drive
>
>/dev/sda & /dev/sdb are the two duplicate scsi drives.  I have
>duplicated the partions for everyting on hda and dumped the data
>over.  System boots up fine w/ /boot /var /tmp /usr and /home all
>on raid partitions.  Getting lilo to run without errors on the 
>root raid is my only hang up before the whole setup is raid & I 
>can remove /dev/hda
>
>I have read through the 2.2x raid docs and the 2.4 kernel howto at: 
>http://karaolides.com/computing/HOWTO/lvmraid/
>
>Each of them mention that lilo should run w/out errors.  I have
>not found much on this error in my searches.
>
>I would appreciate any tips/pointers help.
>
>thanks in advance,
>
>-Healy
>
>
>
>System:
>Debian 3.0 base install
>2.4.18 smp custom kernel
>
>Filesystem            Size  Used Avail Use% Mounted on
>/dev/hda3             843M   28M  772M   4% /
>/dev/md5              143M   33M  110M  23% /tmp
>/dev/md6              961M   44M  869M   5% /var
>/dev/md7              4.6G  449M  3.9G  11% /usr
>/dev/md8              4.6G   20k  4.3G   1% /web
>/dev/md9              4.8G   20k  4.5G   1% /home
>/dev/md3              844M   28M  773M   4% /mnt/slash  <-- future root
>/dev/md1               46M  2.6M   41M   6% /boot
>
>I have edited the lilo.conf on /dev/md3 (mounted to /mnt/slash)
>to look like so:
>
>boot=/dev/md3
>root=/dev/md3
>install=/boot/boot.b
>map=/boot/map
>append="noapic"     
>
>image=/vmlinuz
>        label=linux   
>        read-only     
>
>
>Example of the error:
>
># lilo -r /mnt/slash/
>
>Warning: using BIOS device code 0x81 for RAID boot blocks
>Warning: /dev/md3 is not on the first disk
>Fatal: open /boot/boot.b: No such file or directory
>
>
># ls -la /boot/
>total 2658
>drwxr-xr-x    3 root     root         1024 Jul 19 18:47 .
>drwxr-xr-x   21 root     root         4096 Jul 19 17:37 ..
>lrwxrwxrwx    1 root     root           17 Jul 19 18:13 System.map -> System.map-2.4.18
>-rw-r--r--    1 root     root       272725 Jul 18 21:01 System.map-2.2.20
>-rw-r--r--    1 root     root       378045 Jul 19 18:13 System.map-2.4.18
>-rw-r--r--    1 root     root         7988 Apr 13 11:57 boot-bmp.b
>-rw-r--r--    1 root     root         6204 Apr 13 11:57 boot-compat.b
>-rw-r--r--    1 root     root         7964 Apr 13 11:57 boot-menu.b
>-rw-r--r--    1 root     root         6204 Apr 13 11:57 boot-text.b
>-rw-------    1 root     root          512 Jul 18 22:31 boot.0303
>lrwxrwxrwx    1 root     root           11 Apr 13 11:57 boot.b -> boot-menu.b
>-rw-r--r--    1 root     root          728 Apr 13 11:57 chain.b
>-rw-r--r--    1 root     root        14979 Jul 18 21:01 config-2.2.20
>drwx------    2 root     root         1024 Jul 18 20:59 lost+found
>-rw-------    1 root     root        36352 Jul 19 18:46 map
>-rw-------    1 root     root            0 Jul 19 19:01 map~
>-rw-r--r--    1 root     root          656 Apr 13 11:57 os2_d.b
>-rw-------    1 root     root        13856 Jul 19 18:04 restoresymtable
>-rw-r--r--    1 root     root      1005181 Jul 18 21:01 vmlinuz-2.2.20
>-rw-r--r--    1 root     root       939621 Jul 19 16:00 vmlinuz-2.4.18
>
># cat /etc/raidtab 
>
># /boot raid
>raiddev /dev/md1
>			raid-level					1
>			nr-raid-disks				2
>			nr-spare-disks				0
>			chunk-size					32
>			persistent-superblock	1
>			device						/dev/sda1
>			raid-disk					0
>			device						/dev/sdb1
>			raid-disk					1
>
># / raid
>raiddev /dev/md3
>			raid-level					1
>			nr-raid-disks				2
>			nr-spare-disks				0
>			chunk-size					32
>			persistent-superblock	1
>			device						/dev/sda3
>			raid-disk					0
>			device						/dev/sdb3
>			raid-disk					1
>
>
>(etc, etc)
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
