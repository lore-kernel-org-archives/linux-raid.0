From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: replacing drives
Date: Fri, 26 Apr 2013 16:27:01 +0200
Message-ID: <517A8EB5.8080100@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all.

I'd like to replace two hd in raid1 with larger ones.

I could just add the new drives in raid1 and mount it on /opt after a 
dump/restore, but I'd prefer to just have to drives instead of four.. 
less noise and less power consumption and noise.

The question is: what whould be the best way to go?
Tricks and tips? Drawbacks? Common errors?

Any hint/advice welcome.
Thank you. :-)


present HD: two WD caviar green 500GB
new HD: two WD caviar green 2TB


root@host1:~# uname -rms
Linux 2.6.32-46-server x86_64


root@host1:~# mdadm --version
mdadm - v2.6.7.1 - 15th October 2008


root@host1:~# cat /proc/mdstat
Personalities : [linear] [raid1] [multipath] [raid0] [raid6] [raid5] 
[raid4] [raid10]
md1 : active raid1 sda2[0] sdb2[1]
       7812032 blocks [2/2] [UU]

md2 : active raid1 sda3[0] sdb3[1]
       431744960 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
       48827328 blocks [2/2] [UU]

unused devices: <none>


root@host1:~# parted /dev/sda print
Model: ATA WDC WD5000ABPS-0 (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system     Flags
  1      1049kB  50.0GB  50.0GB  primary  ext4            boot, raid
  2      50.0GB  58.0GB  8000MB  primary  linux-swap(v1)  raid
  3      58.0GB  500GB   442GB   primary  ext4            raid

root@host1:~# parted /dev/sdb print
Model: ATA WDC WD5000ABPS-0 (scsi)
Disk /dev/sdb: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system     Flags
  1      1049kB  50.0GB  50.0GB  primary  ext4            boot, raid
  2      50.0GB  58.0GB  8000MB  primary  linux-swap(v1)  raid
  3      58.0GB  500GB   442GB   primary  ext4            raid


root@host1:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0              48060232   6460476  39158392  15% /
none                   3052888       272   3052616   1% /dev
none                   3057876         0   3057876   0% /dev/shm
none                   3057876        88   3057788   1% /var/run
none                   3057876         0   3057876   0% /var/lock
none                   3057876         0   3057876   0% /lib/init/rw
/dev/md2             424970552 399524484   3858820 100% /opt


Thank you and best regards.
Robi
