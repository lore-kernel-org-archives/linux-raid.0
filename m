From: Mircea Ciocan <mirceac@interplus.ro>
Subject: Please help with a special RAID 1 setup
Date: Wed, 07 Jan 2004 12:16:26 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFBDC7A.8020702@interplus.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    Hello all,
    First excuse me for a looong message, but I've tryed to give as much 
relevant details as possible.

    Please help me with this weird setup if it is possible and fesable:

    I have this raid1 device, composed of two fibre channel devices 
mounted in RAID1, it works absolutely flawlessly.
The resulted device is used for a lot of important data logging and the 
ideea is to hotattach a 3-rd device ot the same size, wait for 
syncronisation and after all of them are syncronised, stop the data 
logging process, wait for a while, issue a sync command and hot detach 
the 3-rd device restart de data logging and walk away with valid 
filesytem backup of the main arry to be used as separate data analysys 
source. I know that solution is somewhat cumberome but trust me this is 
needed as is.
     Now if you read untill here I managed to hot-attach, the attaching 
was mentioned in the syslogfile, the data logging process continued 
undisturbed, even the cat /proc/mdstat showed the new device added BUT 
it only showed the same two   [2/2] [UU] and it didn't touch the 3-rd 
disk at all, also hotremoving was sucessful.

    Here are some relevant data of the test setup that may be usefull:
[root@test]# cat /etc/raidtab
raiddev /dev/md0
raid-level      1
nr-raid-disks   2
nr-spare-disks  0
chunk-size     4
persistent-superblock 1
device          /dev/sda2
raid-disk       0
device          /dev/sdb2
raid-disk       1

/proc/mdstat BEFORE adding the 3-rd device:
[root@test]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 scsi/host3/bus0/target0/lun0/part2[1] 
scsi/host2/bus0/target0/lun0/part2[0]
      710938560 blocks [2/2] [UU]

unused devices: <none>

Then I add the 3-rd device:
[root@test]# raidhotadd /dev/md0 /dev/sdb3

/proc/mdstat AFTER adding 3-rd device

[root@nfs10 root]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 scsi/host3/bus0/target0/lun0/part3[2] 
scsi/host3/bus0/target0/lun0/part2[1] scsi/host2/bus0/target0/lun0/part2[0]
      710938560 blocks [2/2] [UU]

unused devices: <none>

Piece of the syslog showing the add results:
.....
Jan  7 12:09:01 nfs10 kernel: md: updating md0 RAID superblock on device
Jan  7 12:09:01 nfs10 kernel: md: scsi/host3/bus0/target0/lun0/part3 
[events: 00000012]<6>(write) scsi/host3/bus0/target0/lun0/part3's sb 
offset: 725598144
Jan  7 12:09:01 nfs10 kernel: md: scsi/host3/bus0/target0/lun0/part2 
[events: 00000012]<6>(write) scsi/host3/bus0/target0/lun0/part2's sb 
offset: 710938560
Jan  7 12:09:01 nfs10 kernel: md: scsi/host2/bus0/target0/lun0/part2 
[events: 00000012]<6>(write) scsi/host2/bus0/target0/lun0/part2's sb 
offset: 710938560
......

    The problem is that no sync is done, as a matter of fact the 3rd 
disk is not even scrached visibly ;(, did I miss someting obvious or 
what I want is impossible ???

    Thank you for reading such a long mail and for any help that will 
lead me solving this,

       Mircea Ciocan









