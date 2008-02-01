From: Berni <wstripes@gmx.at>
Subject: raid problem: after every reboot /dev/sdb1 is removed?
Date: Fri, 1 Feb 2008 13:52:20 +0100
Message-ID: <20080201135220.617194ff@berni>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have the following problem with my softraid (raid 1). I'm running
Ubuntu 7.10 64bit with kernel 2.6.22-14-generic.

After every reboot my first boot partition in md0 is not synchron. One
of the disks (the sdb1) is removed. 
After a resynch every partition is synching. But after a reboot the
state is "removed". 

The disks are new and both seagate 250gb with exactly the same partition table. 

Here some config files: 

#cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10] 
md2 : active raid1 sda6[0] sdb6[1]
      117185984 blocks [2/2] [UU]
      
md1 : active raid1 sda5[0] sdb5[1]
      1951744 blocks [2/2] [UU]
      
md0 : active raid1 sda1[0]
      19534912 blocks [2/1] [U_]	<<<<<<<< this is the problem: looks like U_ after reboot
      
unused devices: <none>

#fdisk /dev/sda
  Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        2432    19535008+  fd  Linux raid
autodetect
/dev/sda2            2433       17264   119138040    5  Extended
/dev/sda3   *       17265       20451    25599577+   7  HPFS/NTFS
/dev/sda4           20452       30400    79915342+   7  HPFS/NTFS
/dev/sda5            2433        2675     1951866   fd  Linux raid
autodetect
/dev/sda6            2676       17264   117186111   fd  Linux raid
autodetect

#fdisk /dev/sdb
 Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1        2432    19535008+  fd  Linux raid
autodetect
/dev/sdb2            2433       17264   119138040    5  Extended
/dev/sdb3           17265       30400   105514920    7  HPFS/NTFS
/dev/sdb5            2433        2675     1951866   fd  Linux raid
autodetect
/dev/sdb6            2676       17264   117186111   fd  Linux raid
autodetect

# mount
/dev/md0 on / type reiserfs (rw,notail)
proc on /proc type proc (rw,noexec,nosuid,nodev)
/sys on /sys type sysfs (rw,noexec,nosuid,nodev)
varrun on /var/run type tmpfs (rw,noexec,nosuid,nodev,mode=0755)
varlock on /var/lock type tmpfs (rw,noexec,nosuid,nodev,mode=1777)
udev on /dev type tmpfs (rw,mode=0755)
devshm on /dev/shm type tmpfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
lrm on /lib/modules/2.6.22-14-generic/volatile type tmpfs (rw)
/dev/md2 on /home type reiserfs (rw)
securityfs on /sys/kernel/security type securityfs (rw)

Could anyone help me to solve this problem? 
thanks
greets
Berni
