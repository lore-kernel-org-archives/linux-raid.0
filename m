From: gannan10@comcast.net
Subject: error during raid config
Date: Fri, 16 Jan 2004 18:18:07 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <011620041818.1453.804@comcast.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From:  gannan10@comcast.net  [ Save Address ]  
To:  linux-raid@vger.rutgers.edu 
Subject:  error during raid config 
Date:  Fri, 16 Jan 2004 05:27:40 +0000 


Hello,

I get the following error when I tried to setup my raid:

# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hda1, 489951kB, raid superblock at 489856kB
/dev/hda1 is mounted
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

Here is my config information:

# cat /proc/mdstat
Personalities :
read_ahead not set
unused devices: <none>

cat /etc/raidtab
# Persistent raid-1 configuration - md0
raiddev                 /dev/md0
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda1
raid-disk               0

device                  /dev/hdb1
raid-disk               1

# Persistent raid-1 configuration - md1
raiddev                 /dev/md1
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda3

raid-disk               0

device                  /dev/hdb3
raid-disk               1

# Persistent raid-1 configuration - md2
raiddev                 /dev/md2
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda5
raid-disk               0

device                  /dev/hdb5
raid-disk               1

# Persistent raid-1 configuration - md3
raiddev                 /dev/md3
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda6
raid-disk               0

device                  /dev/hdb6
raid-disk               1

# Persistent raid-1 configuration - md4
raiddev                 /dev/md4
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda7

raid-disk               0

device                  /dev/hdb7
raid-disk               1


# fdisk -l /dev/hda

Disk /dev/hda: 255 heads, 63 sectors, 4111 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1        61    489951   fd  Linux raid autodetect
/dev/hda2            62       122    489982+  82  Linux swap
/dev/hda3           123       495   2996122+  fd  Linux raid autodetect
/dev/hda4           496      4111  29045520    5  Extended
/dev/hda5           496      1700   9679131   fd  Linux raid autodetect
/dev/hda6          1701      2905   9679131   fd  Linux raid autodetect
/dev/hda7          2906      4111   9687163+  fd  Linux raid autodetect

# fdisk -l /dev/hdb

Disk /dev/hdb: 255 heads, 63 sectors, 4865 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1             1        61    489951   fd  Linux raid autodetect

/dev/hdb2            62       122    489982+  82  Linux swap
/dev/hdb3           123       495   2996122+  fd  Linux raid autodetect
/dev/hdb4           496      4111  29045520    5  Extended
/dev/hdb5           496      1700   9679131   fd  Linux raid autodetect
/dev/hdb6          1701      2905   9679131   fd  Linux raid autodetect
/dev/hdb7          2906      4111   9687163+  fd  Linux raid autodetect




