From: "Scott Bolander" <scott@bolanderhome.com>
Subject: Software RAID crash > /dev/md0: Invalid argument
Date: Thu, 16 Sep 2004 07:30:49 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <52074.10.0.0.151.1095334249.squirrel@10.0.0.151>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: scott@bolanderhome.com
List-Id: linux-raid.ids

I have a Mandrake 10 server with a 40gb boot drive and a three 200gb disk
software raid 5 array using reiserfs.  A disk went bad; so i have replaced
it.

Doing the normal things to get it back up don't work:

[root@server root]#raidhotadd /dev/md0 /dev/hdg

/dev/md0: can not hot-add disk: array not running!

[root@server root]# raidstart -a

/dev/md0: Invalid argument

I think the superblock on the virtual disk is corrupt.  Can anyone help?
This is a production server and the backup was a removable drive that
failed last week.

Thanks


# cat /etc/fstab
/dev/hde1 / reiserfs notail 1 1
none /dev/pts devpts mode=0620 0 0
# /dev/md0 /files reiserfs notail 1 2
/dev/hda /mnt/cdrom auto
umask=0,user,iocharset=iso8859-1,codepage=850,noauto,ro,exec 0 0
none /mnt/floppy supermount
dev=/dev/fd0,fs=ext2:vfat,--,umask=0,iocharset=iso8859-1,sync,codepage=850
0 0
none /proc proc defaults 0 0
/dev/hde5 swap swap defaults 0 0

# cat /etc/raidtab
raiddev       /dev/md0
raid-level    5
chunk-size    128k
persistent-superblock 1
nr-raid-disks 3
    device    /dev/hdg1
    raid-disk 0
    device    /dev/hdi1
    raid-disk 1
    device    /dev/hdk1
    raid-disk 2

dmesg:
md: invalid raid superblock magic on hdg1
md: hdg1 has invalid sb, not importing!
md: could not import hdg1!
md: autostart unknown-block(0,8705) failed!

cat /proc/modules
raid5 20512 0 - Live 0xd0a5e000

# cat /proc/mdstat
Personalities : [raid5]
md0 : inactive hdi1[1] hdk1[2]
      390716672 blocks
unused devices: <none>


# mdadm --examine /dev/md0
mdadm: /dev/md0 is too small for md


# raidhotremove /dev/md0 /dev/hdg1
/dev/md0: can not hot-remove disk: array not running!


# uname -a
2.6.3-7mdk


Scott Bolander
Computer Services of Cincinnati
http://www.cincysystems.com
scott@cincysystems.com
513-266-6656
"I said, 'government is powerless to protect you,' not powerless to punish
you." --Chief Wiggum, The Simpsons



