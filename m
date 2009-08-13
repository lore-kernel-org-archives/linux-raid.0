From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Ext3 convert to RAID1 ...
Date: Fri, 14 Aug 2009 00:27:19 +0200
Message-ID: <b7b14cbb0908131527w19c900c5r2a572b345e177408@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

 Was hoping to find a nice a simple answer to a scary and complicate
process ... Please could I ask for clarification ...

 Let me provide some background, so that somebody can slap me in the
face and tell me this is not possible ...

 Running CentOS 5.x, we would like to be able to convert a running or
populated filesystem from ext3 to ext3 on RAID1 mirror ... I found the
following ...

http://wiki.centos.org/HowTos/CentOS5ConvertToRAID

 ... but this sounds like alot of extra work, from what I have been
able to see, RAID1 is just a little bit more metadata, which should be
easy to add ... should?

 So I went a searching, and I found this like that got me thinking ...
http://ubuntuforums.org/showthread.php?t=990045

So, using a VM, I did the following ...

created a standard ext3 filesystem on 512MB HD ...
fdisk /dev/sdb

mkfs.ext3 -L data /dev/sdb1

mount /dev/sdb1 /mnt/test
mkdir /mnt/test/stuff
cp -vr /var/cache/yum /mnt/test/stuff

sync
umount /mnt/test

 e2fsck -f /dev/sdb1

resize2fs -F -p /dev/sdb1 450M

 e2fsck -f /dev/sdb1

Now comes the fun part ...

[root@hermes mnt]# mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force
mdadm: /dev/sdb1 appears to contain an ext2fs file system
    size=460800K  mtime=Fri Aug 14 01:41:46 2009
Continue creating array? y
mdadm: array /dev/md0 started.

[root@hermes mnt]# e2fsck -v /dev/md0
e2fsck 1.39 (29-May-2006)
data: clean, 242/116280 files, 228707/460800 blocks

 mdadm --add /dev/md0 /dev/sdc1

[root@hermes mnt]# mdadm --grow /dev/md0 --raid-disks=2
--backup-file=/root/raid1.backup.file

[root@hermes mnt]# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc1[1] sdb1[0]
      521984 blocks [2/2] [UU]

unused devices: <none>
[root@hermes mnt]# e2fsck -v -f /dev/md0
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

     242 inodes used (0.21%)
      22 non-contiguous inodes (9.1%)
         # of inodes with ind/dind/tind blocks: 182/52/0
  228707 blocks used (49.63%)
       0 bad blocks
       0 large files

     218 regular files
      15 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
     233 files

[root@hermes mnt]# resize2fs -F -p /dev/md0
resize2fs 1.39 (29-May-2006)
Resizing the filesystem on /dev/md0 to 521984 (1k) blocks.
Begin pass 1 (max = 7)
Extending the inode table     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/md0 is now 521984 blocks long.

[root@hermes mnt]# e2fsck -v -f /dev/md0
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

     242 inodes used (0.19%)
      22 non-contiguous inodes (9.1%)
         # of inodes with ind/dind/tind blocks: 182/52/0
  230506 blocks used (44.16%)
       0 bad blocks
       0 large files

     218 regular files
      15 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
     233 files

diff -urqs test/ orgdata ...

All seems to work out perfectly fine ... Basic test compare perfectly
... Now, please can someone confirm that this is a working solution to
convert ext3 partitions to ext3 on RAID1 ...

Thanks
Mailed
LeeT
