From: Mitchell Laks <mlaks@verizon.net>
Subject: Disaster with md0. Dead. Now md1 not showing in /proc/mdstat why?
 Drive is ok though!
Date: Mon, 21 Mar 2005 00:35:11 -0500
Message-ID: <200503210035.11371.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am running  a server using debian sarge. Linux kernel 2.6.8, mdadm was 
1.8.1. I described the onset of my disaster in an earlier exchange with David 
Greaves on this list.

My server had 1 sata system drive /dev/sda  and 5 ide data drives configured 
as 3  different raid1's.

I had

/dev/md0  /dev/hda1   /dev/hdg1
/dev/md1  /dev/hdc1   /dev/hdi1
/dev/md2  /dev/hde1    missing

Then I had a catastrophic loss of /dev/md0. 

What happened was that hda1 died and simultaneously hdg1 
began to have nonstop write errors. 
I then tried to rescue the data on /dev/hdg1.  I failed drive /dev/hdi1 from
/dev/md1 and added it to /dev/md0. 

Unfortunately, the rebuilding of /dev/md0 did not proceed, despite my allowing 
a day for it to take place. 

(Incidentally the copious write error messages from /dev/hdg1  were written to 
syslog which filled the /var directory. This lead to many difficulties in my 
administering the system, affecting a Postgresql database I had on the 
system ... another story)

I then removed the two hard drives (dead) hda1 and (dying) hdg1. I replaced 
them with 2 new hard drives.

Here was my 

# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/sda2       /               ext3    defaults,errors=remount-ro 0       1
/dev/sda1       /boot           ext3    defaults        0       2
/dev/sda3       /home           ext3    defaults        0       2
/dev/sda8       /mirror         ext3    defaults        0       2
/dev/sda7       /tmp            ext3    defaults        0       2
/dev/sda6       /var            ext3    defaults        0       2
/dev/sda5       none            swap    sw              0       0
/dev/hda        /media/cdrom0   iso9660 ro,user,noauto  0       0
/dev/md0       /home/big0              ext3    noauto   0     0
/dev/md1       /home/big1              ext3    defaults        0       2
/dev/md2       /home/big2              ext3    defaults        0       2

Here was my /etc/mdadm/mdadm.conf

DEVICE /dev/hda1 /dev/hdc1 /dev/hde1 /dev/hdg1 /dev/hdi1
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=6b8b4567:327b23c6:643c9869:6633483
   devices=/dev/hde1
ARRAY /dev/md1 level=raid1 num-devices=2 spares=1 
UUID=6b8b4567:327b23c6:643c983
   devices=/dev/hdc1,/dev/hdi1
ARRAY /dev/md0 level=raid1 num-devices=2 spares=1 
UUID=6b8b4567:327b23c6:643c983
   devices=/dev/hda1,/dev/hdg1
                           

After I replaced the two new hard drives, I found that the machine would not 
reboot unless I commented out the /dev/md0 and /dev/md1 in the /etc/fstab. 
For good measure I also commented out /dev/md2 as well.

Now I can reboot and I have.

  A2:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             9.2G  2.8G  6.0G  32% /
tmpfs                 443M     0  443M   0% /dev/shm
/dev/sda1              89M   11M   74M  13% /boot
/dev/sda3             7.4G  365M  6.7G   6% /home
/dev/sda8              11G  8.9G  1.1G  90% /mirror
/dev/sda7             449M  8.1M  417M   2% /tmp
/dev/sda6             7.4G  951M  6.1G  14% /var


Now comes the weird part. I expected that when I did cat /proc/mdstat
 I would see 2 working /dev/md1 and /dev/md2. Because both /dev/hdc1 
and /dev/e1 are still ok.

In fact what I see is
 
A2:~# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 hde1[1]
      244195904 blocks [2/1] [_U]

unused devices: <none>

Question 1) What happened to /dev/md1 and /dev/hdc1?

I then followed the advice of 
David Greaves , and I upgraded to mdadm-1.9.0 as 1.8.1 is experimental.

I then did 
mdadm --examine /dev/hdc1

A2:~# mdadm --examine /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6b8b4567:327b23c6:643c9869:66334873
  Creation Time : Wed Jan 12 14:19:46 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Sun Mar 13 10:19:59 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a4499264 - correct
         Events : 0.514


      Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1

   0     0       0        0        0      removed
   1     1      22        1        1      active sync   /dev/hdc1

2:~# mdadm --examine /dev/hdi1

/dev/hdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 6b8b4567:327b23c6:643c9869:66334873
  Creation Time : Wed Jan 12 14:19:21 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Mar 11 11:40:23 2005
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : a4517972 - correct
         Events : 0.343412


      Number   Major   Minor   RaidDevice State
this     2      56        1        2      spare   /dev/hdi1

   0     0      34        1        0      active sync   /dev/hdg1
   1     1       0        0        1      faulty removed
   2     2      56        1        2      spare   /dev/hdi


Then I did 

fdisk -l 
A2:~# fdisk -l

Disk /dev/sda: 40.0 GB, 40020664320 bytes
255 heads, 63 sectors/track, 4865 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          12       96358+  83  Linux
/dev/sda2              13        1228     9767520   83  Linux
/dev/sda3            1229        2201     7815622+  83  Linux
/dev/sda4            2202        4865    21398580    f  W95 Ext'd (LBA)
/dev/sda5            2202        2444     1951866   82  Linux swap
/dev/sda6            2445        3417     7815591   83  Linux
/dev/sda7            3418        3478      489951   83  Linux
/dev/sda8            3479        4865    11141046   83  Linux

Disk /dev/hde: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hde1               1       30401   244196001   fd  Linux raid autodetect

Disk /dev/hdg: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hdg doesn't contain a valid partition table

Disk /dev/hdi: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdi1               1       30401   244196001   fd  Linux raid autodetect

Disk /dev/hda: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hda doesn't contain a valid partition table

Disk /dev/hdc: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1       30401   244196001   fd  Linux raid autodetect


Any Ideas on why I don't have an active /dev/md1??????

What steps do I take to preserve the data on /dev/md1? I know I can now 
rebuild /dev/md0 the usual way.

Does the fact that the system booted with the /etc/mdadm/mdadm.conf that was 
"incorrect" because it mentioned that /dev/hdi1 was a partner with /dev/hdc1 
have anything to do with this????

Thanks,


Mitchell Laks
