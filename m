From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Cannot start array on disk
Date: Wed, 20 Jul 2016 02:10:12 +0000 (UTC)
Message-ID: <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com> <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com> <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil

1. The enclosure had 2 drives in RAID1, since 2013. One drive went bad early this year around Feb 2016 (Drive A). WDC gave a RMA replacement drive. I remember accessing the enclosure at least once after the RMA drive rebuilt. This drive A is the one that is still alive. The drive B went bad recently (June 2016) after which I was unable to access the system at all.

2. The drive should be around 1/3rd used i.e around 1TB out of 3TB drive should be used.


3. Connecting this drive via esata to a linux laptop, gparted shows sdc1 and sdc2 as EXT3 of 1.91GB each, and sdc3 (489MB) and sdc4 (2.72TB) as linux-raid filesystem.

4. I mounted sdc1 and sdc2 and var/log directories on both look like copy of each other:
$ ls -lart p1/var/log
total 1136
-rw-rw-rw-  1 root root     31 Dec 31  1969 master_drive_serial_number
drwxr-xr-x  2 root root   4096 Mar 24  2010 sysstat
drwxr-xr-x  2 root root   4096 Sep 16  2013 apt
-rw-rw-rw-  1 root adm    4734 Sep 16  2013 dmesg.4.gz
-rw-rw-rw-  1 root adm    4799 Sep 16  2013 dmesg.3.gz
drwxr-xr--  2 root root   4096 Sep 16  2013 news
-rw-r--r--  1 root adm       0 Sep 16  2013 mail.warn
-rw-r--r--  1 root adm       0 Sep 16  2013 mail.log
-rw-r--r--  1 root adm       0 Sep 16  2013 mail.info
-rw-r--r--  1 root adm       0 Sep 16  2013 mail.err
-rw-r--r--  1 root adm       0 Sep 16  2013 lpr.log
drwxr-xr-x  2 root root   4096 Sep 16  2013 apache2
-rw-rw-rw-  1 root adm   14889 May  7  2015 dmesg.0
-rw-r--r--  1 root adm       0 May  7  2015 sshd.log
-rw-r--r--  1 root adm    1765 May  7  2015 kern.log
-rw-r--r--  1 root root   1504 May  7  2015 dpkg.log
-rw-r-----  1 root adm       0 Jul  1 22:38 vsftpd.log
drwxr-xr-x  3 root root   4096 Jul  1 22:38 samba
-rw-rw-rw-  1 root adm    4747 Jul  1 22:42 dmesg.2.gz
-rw-rw-rw-  1 root adm    4747 Jul  1 22:48 dmesg.1.gz
-rw-rw-rw-  1 root root    154 Jul  1 23:01 version.log
drwxr-xr-x 14 root root   4096 Jul  1 23:06 ..
-rw-r--r--  1 root adm      75 Jul  1 23:06 wdalerts.log
-rw-r--r--  1 root adm   15259 Jul  1 23:10 wdnas.log
-rw-r--r--  1 root root   3067 Jul  1 23:10 forked-daapd.log
-rw-r--r--  1 root adm   32586 Jul  1 23:11 user.log
-rw-r--r--  1 root adm      74 Jul  1 23:11 dlna_server.log
-rw-r--r--  1 root adm    4243 Jul  1 23:11 miocrawler.log
-rw-r--r--  1 root adm   21531 Jul  1 23:12 mediacrawler.log
-rw-r--r--  1 root adm  643021 Jul  2 00:02 rest_api.log.1
-rw-r--r--  1 root adm  151111 Jul  2 00:02 messages
-rw-r--r--  1 root adm   31328 Jul  2 02:14 daemon.log
-rw-rw-rw-  1 root root    720 Jul  2 03:00 ramlog
-rw-rw-rw-  1 root adm   15162 Jul  2 12:02 dmesg
-rw-rw-rw-  1 root root 108362 Jul  2 12:02 rest_api.log
-rw-rw-rw-  1 root root     58 Jul  2 12:02 purge.log
drwxr-xr-x  7 root root   4096 Jul  2 12:02 .

5. A grep of raid or sd or ext, on messages shows:
$ cat p1/var/log/messages | egrep -i "sd|raid|ext" 
Sep 16 11:53:17 MyBookLiveDuo kernel: MMU: Allocated 1088 bytes of context maps for 255 contexts
Sep 16 11:53:17 MyBookLiveDuo kernel: Kernel command line: root=/dev/md0 rw rootfstype=ext3 rootflags=data=ordered console=ttyS0,115200
Sep 16 11:53:17 MyBookLiveDuo kernel: raid6: int32x1    185 MB/s
Sep 16 11:53:17 MyBookLiveDuo kernel: raid6: int32x2    189 MB/s
Sep 16 11:53:17 MyBookLiveDuo kernel: raid6: int32x4    197 MB/s
Sep 16 11:53:17 MyBookLiveDuo kernel: raid6: int32x8    189 MB/s
Sep 16 11:53:17 MyBookLiveDuo kernel: raid6: using algorithm int32x4 (197 MB/s)
Sep 16 11:53:17 MyBookLiveDuo kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid0 personality registered for level 0
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid1 personality registered for level 1
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid10 personality registered for level 10
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid6 personality registered for level 6
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid5 personality registered for level 5
Sep 16 11:53:17 MyBookLiveDuo kernel: md: raid4 personality registered for level 4
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write Protect is off
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 4096-byte physical blocks
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Sep 16 11:53:17 MyBookLiveDuo kernel: sda:
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write Protect is off
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 16 11:53:17 MyBookLiveDuo kernel: sdb:apm82181 adma3: allocated 512 descriptor slots
Sep 16 11:53:17 MyBookLiveDuo kernel: sda1 sda2 sda3 sda4
Sep 16 11:53:17 MyBookLiveDuo kernel: sdb1 sdb2 sdb3 sdb4
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Sep 16 11:53:17 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Sep 16 11:53:17 MyBookLiveDuo kernel: md: If you don't use raid, use raid=noautodetect
Sep 16 11:53:17 MyBookLiveDuo kernel: md: Autodetecting RAID arrays.
Sep 16 11:53:17 MyBookLiveDuo kernel: md: sda3 does not have a valid v0.90 superblock, not importing!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: sda4 does not have a valid v0.90 superblock, not importing!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: sdb3 does not have a valid v0.90 superblock, not importing!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: sdb4 does not have a valid v0.90 superblock, not importing!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: considering sdb2 ...
Sep 16 11:53:17 MyBookLiveDuo kernel: md:  adding sdb2 ...
Sep 16 11:53:17 MyBookLiveDuo kernel: md:  adding sdb1 ...
Sep 16 11:53:17 MyBookLiveDuo kernel: md:  adding sda2 ...
Sep 16 11:53:17 MyBookLiveDuo kernel: md:  adding sda1 ...
Sep 16 11:53:17 MyBookLiveDuo kernel: md: bind<sda1>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: bind<sda2>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: bind<sdb1>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: bind<sdb2>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: running: <sdb2><sdb1><sda2><sda1>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: kicking non-fresh sdb2 from array!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: unbind<sdb2>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: export_rdev(sdb2)
Sep 16 11:53:17 MyBookLiveDuo kernel: md: kicking non-fresh sdb1 from array!
Sep 16 11:53:17 MyBookLiveDuo kernel: md: unbind<sdb1>
Sep 16 11:53:17 MyBookLiveDuo kernel: md: export_rdev(sdb1)
Sep 16 11:53:17 MyBookLiveDuo kernel: md0: WARNING: sda2 appears to be on the same physical disk as sda1.
Sep 16 11:53:17 MyBookLiveDuo kernel: raid1: raid set md0 active with 2 out of 4 mirrors
Sep 16 11:53:17 MyBookLiveDuo kernel: EXT3 FS on md0, internal journal
Sep 16 11:53:17 MyBookLiveDuo kernel: EXT3-fs: recovery complete.
Sep 16 11:53:17 MyBookLiveDuo kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep 16 11:53:17 MyBookLiveDuo kernel: VFS: Mounted root (ext3 filesystem) on device 9:0.
Sep 16 11:53:25 MyBookLiveDuo kernel: md: bind<sdb3>
Sep 16 11:53:25 MyBookLiveDuo kernel: md: bind<sda3>
Sep 16 11:53:25 MyBookLiveDuo kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Sep 16 11:53:36 MyBookLiveDuo [admin-rest-api.postinst] 09/16/13 18:53:36: test context=test
Sep 16 11:53:40 MyBookLiveDuo kernel: Adding 500544k swap on /dev/md2.  Priority:-1 extents:1 across:500544k 
Sep 16 11:54:02 MyBookLiveDuo kernel: ufsd: bad vermagic: kernel tainted.
Sep 16 11:54:02 MyBookLiveDuo kernel: ufsd: module license 'unspecified' taints kernel.
Sep 16 11:54:02 MyBookLiveDuo kernel: ufsd: driver 8.5 (NTFS4LINUX_U85_014_S[2011-09-15-11:41:06]) LBD=ON with delayalloc with ioctl loaded at d1790000
Jul  1 19:39:01 MyBookLiveDuo kernel: md: cannot remove active disk sda1 from md0 ...
Jul  1 19:39:01 MyBookLiveDuo kernel: md: cannot remove active disk sda2 from md0 ...
Jul  1 19:39:01 MyBookLiveDuo kernel: md: bind<sdb1>
Jul  1 19:39:01 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:39:01 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:39:01 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:39:01 MyBookLiveDuo kernel: disk 2, wo:1, o:1, dev:sdb1
Jul  1 19:39:02 MyBookLiveDuo kernel: md: recovery of RAID array md0
Jul  1 19:39:02 MyBookLiveDuo kernel: md: bind<sdb2>
Jul  1 19:39:40 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 2, wo:0, o:1, dev:sdb1
Jul  1 19:39:40 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 2, wo:0, o:1, dev:sdb1
Jul  1 19:39:40 MyBookLiveDuo kernel: disk 3, wo:1, o:1, dev:sdb2
Jul  1 19:39:41 MyBookLiveDuo kernel: md: recovery of RAID array md0
Jul  1 19:40:18 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:40:18 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:40:18 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:40:18 MyBookLiveDuo kernel: disk 2, wo:0, o:1, dev:sdb1
Jul  1 19:40:18 MyBookLiveDuo kernel: disk 3, wo:0, o:1, dev:sdb2
Jul  1 19:42:02 MyBookLiveDuo kernel: nfsd: last server has exited, flushing export cache
Jul  1 19:42:02 MyBookLiveDuo kernel: ufsd: driver unloaded
Jul  1 19:42:26 MyBookLiveDuo kernel: MMU: Allocated 1088 bytes of context maps for 255 contexts
Jul  1 19:42:26 MyBookLiveDuo kernel: Kernel command line: root=/dev/md0 rw rootfstype=ext3 rootflags=data=ordered console=ttyS0,115200
Jul  1 19:42:26 MyBookLiveDuo kernel: raid6: int32x1    185 MB/s
Jul  1 19:42:26 MyBookLiveDuo kernel: raid6: int32x2    189 MB/s
Jul  1 19:42:26 MyBookLiveDuo kernel: raid6: int32x4    197 MB/s
Jul  1 19:42:26 MyBookLiveDuo kernel: raid6: int32x8    189 MB/s
Jul  1 19:42:26 MyBookLiveDuo kernel: raid6: using algorithm int32x4 (197 MB/s)
Jul  1 19:42:26 MyBookLiveDuo kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid0 personality registered for level 0
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid1 personality registered for level 1
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid10 personality registered for level 10
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid6 personality registered for level 6
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid5 personality registered for level 5
Jul  1 19:42:26 MyBookLiveDuo kernel: md: raid4 personality registered for level 4
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write Protect is off
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 4096-byte physical blocks
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Jul  1 19:42:26 MyBookLiveDuo kernel: sda:
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write Protect is off
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  1 19:42:26 MyBookLiveDuo kernel: sdb:apm82181 adma3: allocated 512 descriptor slots
Jul  1 19:42:26 MyBookLiveDuo kernel: sda1 sda2 sda3 sda4
Jul  1 19:42:26 MyBookLiveDuo kernel: sdb1 sdb2 sdb3 sdb4
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Jul  1 19:42:26 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jul  1 19:42:26 MyBookLiveDuo kernel: md: If you don't use raid, use raid=noautodetect
Jul  1 19:42:26 MyBookLiveDuo kernel: md: Autodetecting RAID arrays.
Jul  1 19:42:26 MyBookLiveDuo kernel: md: sda3 does not have a valid v0.90 superblock, not importing!
Jul  1 19:42:26 MyBookLiveDuo kernel: md: sda4 does not have a valid v0.90 superblock, not importing!
Jul  1 19:42:26 MyBookLiveDuo kernel: md: sdb3 does not have a valid v0.90 superblock, not importing!
Jul  1 19:42:26 MyBookLiveDuo kernel: md: sdb4 does not have a valid v0.90 superblock, not importing!
Jul  1 19:42:26 MyBookLiveDuo kernel: md: considering sdb2 ...
Jul  1 19:42:26 MyBookLiveDuo kernel: md:  adding sdb2 ...
Jul  1 19:42:26 MyBookLiveDuo kernel: md:  adding sdb1 ...
Jul  1 19:42:26 MyBookLiveDuo kernel: md:  adding sda2 ...
Jul  1 19:42:26 MyBookLiveDuo kernel: md:  adding sda1 ...
Jul  1 19:42:26 MyBookLiveDuo kernel: md: bind<sda1>
Jul  1 19:42:26 MyBookLiveDuo kernel: md: bind<sda2>
Jul  1 19:42:26 MyBookLiveDuo kernel: md: bind<sdb1>
Jul  1 19:42:26 MyBookLiveDuo kernel: md: bind<sdb2>
Jul  1 19:42:26 MyBookLiveDuo kernel: md: running: <sdb2><sdb1><sda2><sda1>
Jul  1 19:42:26 MyBookLiveDuo kernel: md0: WARNING: sdb2 appears to be on the same physical disk as sdb1.
Jul  1 19:42:26 MyBookLiveDuo kernel: md0: WARNING: sda2 appears to be on the same physical disk as sda1.
Jul  1 19:42:26 MyBookLiveDuo kernel: raid1: raid set md0 active with 4 out of 4 mirrors
Jul  1 19:42:26 MyBookLiveDuo kernel: EXT3 FS on md0, internal journal
Jul  1 19:42:26 MyBookLiveDuo kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jul  1 19:42:26 MyBookLiveDuo kernel: VFS: Mounted root (ext3 filesystem) on device 9:0.
Jul  1 19:42:32 MyBookLiveDuo kernel: md: bind<sdb3>
Jul  1 19:42:32 MyBookLiveDuo kernel: md: bind<sda3>
Jul  1 19:42:32 MyBookLiveDuo kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Jul  1 19:42:40 MyBookLiveDuo [admin-rest-api.postinst] 07/02/16 02:42:40: test context=test
Jul  1 19:42:44 MyBookLiveDuo kernel: Adding 500544k swap on /dev/md2.  Priority:-1 extents:1 across:500544k 
Jul  1 19:43:06 MyBookLiveDuo kernel: ufsd: bad vermagic: kernel tainted.
Jul  1 19:43:06 MyBookLiveDuo kernel: ufsd: module license 'unspecified' taints kernel.
Jul  1 19:43:06 MyBookLiveDuo kernel: ufsd: driver 8.5 (NTFS4LINUX_U85_014_S[2011-09-15-11:41:06]) LBD=ON with delayalloc with ioctl loaded at d1790000
Jul  1 19:44:37 MyBookLiveDuo kernel: md: cannot remove active disk sda1 from md0 ...
Jul  1 19:44:37 MyBookLiveDuo kernel: md: cannot remove active disk sda2 from md0 ...
Jul  1 19:44:37 MyBookLiveDuo kernel: md: cannot remove active disk sdb1 from md0 ...
Jul  1 19:44:37 MyBookLiveDuo kernel: md: cannot remove active disk sdb2 from md0 ...
Jul  1 19:47:30 MyBookLiveDuo kernel: nfsd: last server has exited, flushing export cache
Jul  1 19:47:31 MyBookLiveDuo kernel: ufsd: driver unloaded
Jul  1 19:48:09 MyBookLiveDuo kernel: MMU: Allocated 1088 bytes of context maps for 255 contexts
Jul  1 19:48:09 MyBookLiveDuo kernel: Kernel command line: root=/dev/md0 rw rootfstype=ext3 rootflags=data=ordered console=ttyS0,115200
Jul  1 19:48:09 MyBookLiveDuo kernel: raid6: int32x1    185 MB/s
Jul  1 19:48:09 MyBookLiveDuo kernel: raid6: int32x2    189 MB/s
Jul  1 19:48:09 MyBookLiveDuo kernel: raid6: int32x4    197 MB/s
Jul  1 19:48:09 MyBookLiveDuo kernel: raid6: int32x8    189 MB/s
Jul  1 19:48:09 MyBookLiveDuo kernel: raid6: using algorithm int32x4 (197 MB/s)
Jul  1 19:48:09 MyBookLiveDuo kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid0 personality registered for level 0
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid1 personality registered for level 1
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid10 personality registered for level 10
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid6 personality registered for level 6
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid5 personality registered for level 5
Jul  1 19:48:09 MyBookLiveDuo kernel: md: raid4 personality registered for level 4
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write Protect is off
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 4096-byte physical blocks
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Jul  1 19:48:09 MyBookLiveDuo kernel: sda:
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write Protect is off
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  1 19:48:09 MyBookLiveDuo kernel: sdb:apm82181 adma3: allocated 512 descriptor slots
Jul  1 19:48:09 MyBookLiveDuo kernel: sda1 sda2 sda3 sda4
Jul  1 19:48:09 MyBookLiveDuo kernel: sdb1 sdb2 sdb3 sdb4
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jul  1 19:48:09 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Jul  1 19:48:09 MyBookLiveDuo kernel: md: If you don't use raid, use raid=noautodetect
Jul  1 19:48:09 MyBookLiveDuo kernel: md: Autodetecting RAID arrays.
Jul  1 19:48:09 MyBookLiveDuo kernel: md: sda3 does not have a valid v0.90 superblock, not importing!
Jul  1 19:48:09 MyBookLiveDuo kernel: md: sda4 does not have a valid v0.90 superblock, not importing!
Jul  1 19:48:09 MyBookLiveDuo kernel: md: sdb3 does not have a valid v0.90 superblock, not importing!
Jul  1 19:48:09 MyBookLiveDuo kernel: md: sdb4 does not have a valid v0.90 superblock, not importing!
Jul  1 19:48:09 MyBookLiveDuo kernel: md: considering sdb2 ...
Jul  1 19:48:09 MyBookLiveDuo kernel: md:  adding sdb2 ...
Jul  1 19:48:09 MyBookLiveDuo kernel: md:  adding sdb1 ...
Jul  1 19:48:09 MyBookLiveDuo kernel: md:  adding sda2 ...
Jul  1 19:48:09 MyBookLiveDuo kernel: md:  adding sda1 ...
Jul  1 19:48:09 MyBookLiveDuo kernel: md: bind<sda1>
Jul  1 19:48:09 MyBookLiveDuo kernel: md: bind<sda2>
Jul  1 19:48:09 MyBookLiveDuo kernel: md: bind<sdb1>
Jul  1 19:48:09 MyBookLiveDuo kernel: md: bind<sdb2>
Jul  1 19:48:09 MyBookLiveDuo kernel: md: running: <sdb2><sdb1><sda2><sda1>
Jul  1 19:48:09 MyBookLiveDuo kernel: md0: WARNING: sdb2 appears to be on the same physical disk as sdb1.
Jul  1 19:48:09 MyBookLiveDuo kernel: md0: WARNING: sda2 appears to be on the same physical disk as sda1.
Jul  1 19:48:09 MyBookLiveDuo kernel: raid1: raid set md0 active with 4 out of 4 mirrors
Jul  1 19:48:09 MyBookLiveDuo kernel: EXT3 FS on md0, internal journal
Jul  1 19:48:09 MyBookLiveDuo kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jul  1 19:48:09 MyBookLiveDuo kernel: VFS: Mounted root (ext3 filesystem) on device 9:0.
Jul  1 19:48:13 MyBookLiveDuo kernel: md: bind<sda4>
Jul  1 19:48:13 MyBookLiveDuo kernel: md: bind<sdb4>
Jul  1 19:48:13 MyBookLiveDuo kernel: md: unbind<sdb4>
Jul  1 19:48:13 MyBookLiveDuo kernel: md: export_rdev(sdb4)
Jul  1 19:48:13 MyBookLiveDuo kernel: md: unbind<sda4>
Jul  1 19:48:13 MyBookLiveDuo kernel: md: export_rdev(sda4)
Jul  1 19:48:15 MyBookLiveDuo kernel: md: bind<sdb3>
Jul  1 19:48:15 MyBookLiveDuo kernel: md: bind<sda3>
Jul  1 19:48:15 MyBookLiveDuo kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Jul  1 19:48:15 MyBookLiveDuo kernel: md: bind<sdb4>
Jul  1 19:48:15 MyBookLiveDuo kernel: md: bind<sda4>
Jul  1 19:53:51 MyBookLiveDuo kernel: EXT4-fs (md3): mounted filesystem with ordered data mode
Jul  1 19:53:56 MyBookLiveDuo [wd-nas.postinst] 07/02/16 02:53:55: restore context=restore
Jul  1 19:54:00 MyBookLiveDuo [networking-general.postinst] 07/02/16 02:54:00: restore context=restore
Jul  1 19:54:01 MyBookLiveDuo [apache-php-webdav.postinst] 07/02/16 02:54:01: restore context=restore
Jul  1 19:54:06 MyBookLiveDuo [date-time.postinst] 07/02/16 02:54:06: restore context=restore
Jul  1 19:54:09 MyBookLiveDuo [alerts.postinst] 07/02/16 02:54:09: restore context=restore
Jul  1 19:54:10 MyBookLiveDuo [admin-rest-api.postinst] 07/02/16 02:54:10: restore context=restore
Jul  1 19:54:12 MyBookLiveDuo [drive-lib.postinst] 07/02/16 02:54:12: restore context=restore
Jul  1 19:54:13 MyBookLiveDuo [data-volume-config.postinst] 07/02/16 02:54:13: restore context=restore
Jul  1 19:54:14 MyBookLiveDuo [upnp-nas.postinst] 07/02/16 02:54:14: restore context=restore
Jul  1 19:54:15 MyBookLiveDuo [dlna-server-access.postinst] 07/02/16 02:54:15: restore context=restore
Jul  1 19:54:16 MyBookLiveDuo [itunes.postinst] 07/02/16 02:54:16: restore context=restore
Jul  1 19:54:17 MyBookLiveDuo [nas-safepoint.postinst] 07/02/16 02:54:17: restore context=restore
Jul  1 19:54:18 MyBookLiveDuo [webui.postinst] 07/02/16 02:54:18: restore context=restore
Jul  1 19:54:28 MyBookLiveDuo [orion-resources.postinst] 07/02/16 02:54:28: restore context=restore
Jul  1 19:54:29 MyBookLiveDuo [afp.postinst] 07/02/16 02:54:29: restore context=restore
Jul  1 19:54:29 MyBookLiveDuo kernel: Adding 500544k swap on /dev/md2.  Priority:-1 extents:1 across:500544k 
Jul  1 19:55:18 MyBookLiveDuo kernel: md: cannot remove active disk sda1 from md0 ...
Jul  1 19:55:19 MyBookLiveDuo kernel: md: cannot remove active disk sda2 from md0 ...
Jul  1 19:55:19 MyBookLiveDuo kernel: md: cannot remove active disk sdb1 from md0 ...
Jul  1 19:55:19 MyBookLiveDuo kernel: md: cannot remove active disk sdb2 from md0 ...
Jul  1 19:55:28 MyBookLiveDuo kernel: ufsd: bad vermagic: kernel tainted.
Jul  1 19:55:28 MyBookLiveDuo kernel: ufsd: module license 'unspecified' taints kernel.
Jul  1 19:55:28 MyBookLiveDuo kernel: ufsd: driver 8.5 (NTFS4LINUX_U85_014_S[2011-09-15-11:41:06]) LBD=ON with delayalloc with ioctl loaded at d3b00000
Jul  1 19:55:31 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 2, wo:1, o:0, dev:sdb1
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 3, wo:0, o:1, dev:sdb2
Jul  1 19:55:31 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda1
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda2
Jul  1 19:55:31 MyBookLiveDuo kernel: disk 3, wo:0, o:1, dev:sdb2
Jul  1 19:55:31 MyBookLiveDuo kernel: md: unbind<sdb1>
Jul  1 19:55:31 MyBookLiveDuo kernel: md: export_rdev(sdb1)
Jul  1 19:55:32 MyBookLiveDuo kernel: md: bind<sdb1>
Jul  1 19:55:32 MyBookLiveDuo kernel: raid1: raid set md1 active with 1 out of 4 mirrors
Jul  1 19:58:57 MyBookLiveDuo kernel: md: cannot remove active disk sda1 from md0 ...
Jul  1 19:58:57 MyBookLiveDuo kernel: md: cannot remove active disk sda2 from md0 ...
Jul  1 19:58:57 MyBookLiveDuo kernel: md: cannot remove active disk sdb2 from md0 ...
Jul  1 20:00:59 MyBookLiveDuo kernel: EXT3-fs warning: checktime reached, running e2fsck is recommended
Jul  1 20:00:59 MyBookLiveDuo kernel: EXT3 FS on md1, internal journal
Jul  1 20:00:59 MyBookLiveDuo kernel: EXT3-fs: mounted filesystem with writeback data mode.
May  7 18:23:57 MyBookLiveDuo kernel: MMU: Allocated 1088 bytes of context maps for 255 contexts
May  7 18:23:57 MyBookLiveDuo kernel: Kernel command line: root=/dev/md1 rw rootfstype=ext3 rootflags=data=ordered console=ttyS0,115200
May  7 18:23:57 MyBookLiveDuo kernel: raid6: int32x1    185 MB/s
May  7 18:23:57 MyBookLiveDuo kernel: raid6: int32x2    189 MB/s
May  7 18:23:57 MyBookLiveDuo kernel: raid6: int32x4    197 MB/s
May  7 18:23:57 MyBookLiveDuo kernel: raid6: int32x8    189 MB/s
May  7 18:23:57 MyBookLiveDuo kernel: raid6: using algorithm int32x4 (197 MB/s)
May  7 18:23:57 MyBookLiveDuo kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
May  7 18:23:57 MyBookLiveDuo kernel: md: raid0 personality registered for level 0
May  7 18:23:57 MyBookLiveDuo kernel: md: raid1 personality registered for level 1
May  7 18:23:57 MyBookLiveDuo kernel: md: raid10 personality registered for level 10
May  7 18:23:57 MyBookLiveDuo kernel: md: raid6 personality registered for level 6
May  7 18:23:57 MyBookLiveDuo kernel: md: raid5 personality registered for level 5
May  7 18:23:57 MyBookLiveDuo kernel: md: raid4 personality registered for level 4
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write Protect is off
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] 4096-byte physical blocks
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
May  7 18:23:57 MyBookLiveDuo kernel: sda:
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write Protect is off
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May  7 18:23:57 MyBookLiveDuo kernel: sdb:apm82181 adma3: allocated 512 descriptor slots
May  7 18:23:57 MyBookLiveDuo kernel: sda1 sda2 sda3 sda4
May  7 18:23:57 MyBookLiveDuo kernel: sdb1 sdb2 sdb3 sdb4
May  7 18:23:57 MyBookLiveDuo kernel: sd 0:0:0:0: [sda] Attached SCSI disk
May  7 18:23:57 MyBookLiveDuo kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
May  7 18:23:57 MyBookLiveDuo kernel: md: If you don't use raid, use raid=noautodetect
May  7 18:23:57 MyBookLiveDuo kernel: md: Autodetecting RAID arrays.
May  7 18:23:57 MyBookLiveDuo kernel: md: sda3 does not have a valid v0.90 superblock, not importing!
May  7 18:23:57 MyBookLiveDuo kernel: md: sda4 does not have a valid v0.90 superblock, not importing!
May  7 18:23:57 MyBookLiveDuo kernel: md: sdb3 does not have a valid v0.90 superblock, not importing!
May  7 18:23:57 MyBookLiveDuo kernel: md: sdb4 does not have a valid v0.90 superblock, not importing!
May  7 18:23:57 MyBookLiveDuo kernel: md: considering sdb2 ...
May  7 18:23:57 MyBookLiveDuo kernel: md:  adding sdb2 ...
May  7 18:23:57 MyBookLiveDuo kernel: md: sdb1 has different UUID to sdb2
May  7 18:23:57 MyBookLiveDuo kernel: md:  adding sda2 ...
May  7 18:23:57 MyBookLiveDuo kernel: md:  adding sda1 ...
May  7 18:23:57 MyBookLiveDuo kernel: md: bind<sda1>
May  7 18:23:57 MyBookLiveDuo kernel: md: bind<sda2>
May  7 18:23:57 MyBookLiveDuo kernel: md: bind<sdb2>
May  7 18:23:57 MyBookLiveDuo kernel: md: running: <sdb2><sda2><sda1>
May  7 18:23:57 MyBookLiveDuo kernel: md0: WARNING: sda2 appears to be on the same physical disk as sda1.
May  7 18:23:57 MyBookLiveDuo kernel: raid1: raid set md0 active with 3 out of 4 mirrors
May  7 18:23:57 MyBookLiveDuo kernel: md: considering sdb1 ...
May  7 18:23:57 MyBookLiveDuo kernel: md:  adding sdb1 ...
May  7 18:23:57 MyBookLiveDuo kernel: md: bind<sdb1>
May  7 18:23:57 MyBookLiveDuo kernel: md: running: <sdb1>
May  7 18:23:57 MyBookLiveDuo kernel: raid1: raid set md1 active with 1 out of 4 mirrors
May  7 18:23:57 MyBookLiveDuo kernel: EXT3 FS on md1, internal journal
May  7 18:23:57 MyBookLiveDuo kernel: EXT3-fs: mounted filesystem with ordered data mode.
May  7 18:23:57 MyBookLiveDuo kernel: VFS: Mounted root (ext3 filesystem) on device 9:1.
May  7 18:24:01 MyBookLiveDuo kernel: md: bind<sdb3>
May  7 18:24:01 MyBookLiveDuo kernel: md: bind<sda3>
May  7 18:24:01 MyBookLiveDuo kernel: raid1: raid set md2 active with 2 out of 2 mirrors
May  7 18:24:02 MyBookLiveDuo kernel: md: bind<sdb4>
May  7 18:24:02 MyBookLiveDuo kernel: md: bind<sda4>
May  7 18:24:02 MyBookLiveDuo kernel: EXT4-fs (md3): mounted filesystem with ordered data mode
May  7 18:24:10 MyBookLiveDuo [admin-rest-api.postinst] 05/08/15 01:24:10: test context=test
May  7 18:24:14 MyBookLiveDuo kernel: Adding 500544k swap on /dev/md2.  Priority:-1 extents:1 across:500544k 
May  7 18:24:23 MyBookLiveDuo [dlna-server-access.postinst] 05/08/15 01:24:23: configure 02.00.00-100316 context=upgrade
May  7 18:24:52 MyBookLiveDuo kernel: ufsd: bad vermagic: kernel tainted.
May  7 18:24:52 MyBookLiveDuo kernel: ufsd: module license 'unspecified' taints kernel.
May  7 18:24:52 MyBookLiveDuo kernel: ufsd: driver 8.5 (NTFS4LINUX_U85_014_S[2011-09-15-11:41:06]) LBD=ON with delayalloc with ioctl loaded at d2750000
Jul  1 20:06:48 MyBookLiveDuo kernel: md: unbind<sdb2>
Jul  1 20:06:48 MyBookLiveDuo kernel: md: export_rdev(sdb2)
Jul  1 20:06:48 MyBookLiveDuo kernel: md: unbind<sda2>
Jul  1 20:06:48 MyBookLiveDuo kernel: md: export_rdev(sda2)
Jul  1 20:06:48 MyBookLiveDuo kernel: md: unbind<sda1>
Jul  1 20:06:48 MyBookLiveDuo kernel: md: export_rdev(sda1)
Jul  1 20:06:50 MyBookLiveDuo kernel: md: bind<sda1>
Jul  1 20:06:50 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:06:50 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sdb1
Jul  1 20:06:50 MyBookLiveDuo kernel: disk 1, wo:1, o:1, dev:sda1
Jul  1 20:06:50 MyBookLiveDuo kernel: md: recovery of RAID array md1
Jul  1 20:06:50 MyBookLiveDuo kernel: md: bind<sda2>
Jul  1 20:06:50 MyBookLiveDuo kernel: md: cannot remove active disk sdb1 from md1 ...
Jul  1 20:06:50 MyBookLiveDuo kernel: md: bind<sdb2>
Jul  1 20:07:31 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sdb1
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda1
Jul  1 20:07:31 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sdb1
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda1
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 2, wo:1, o:1, dev:sdb2
Jul  1 20:07:31 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sdb1
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda1
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 2, wo:1, o:1, dev:sdb2
Jul  1 20:07:31 MyBookLiveDuo kernel: disk 3, wo:1, o:1, dev:sda2
Jul  1 20:07:31 MyBookLiveDuo kernel: md: recovery of RAID array md1
Jul  1 20:08:39 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:08:39 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sdb1
Jul  1 20:08:39 MyBookLiveDuo kernel: disk 1, wo:0, o:1, dev:sda1
Jul  1 20:08:39 MyBookLiveDuo kernel: disk 2, wo:0, o:1, dev:sdb2
Jul  1 20:08:39 MyBookLiveDuo kernel: disk 3, wo:0, o:1, dev:sda2
Jul  1 20:09:54 MyBookLiveDuo kernel: nfsd: last server has exited, flushing export cache
Jul  1 20:10:49 MyBookLiveDuo kernel: md: unbind<sda4>
Jul  1 20:10:49 MyBookLiveDuo kernel: md: export_rdev(sda4)
Jul  1 20:10:49 MyBookLiveDuo kernel: md: unbind<sdb4>
Jul  1 20:10:49 MyBookLiveDuo kernel: md: export_rdev(sdb4)
Jul  1 20:10:51 MyBookLiveDuo kernel: md: bind<sda4>
Jul  1 20:10:51 MyBookLiveDuo kernel: raid1: raid set md3 active with 1 out of 2 mirrors
Jul  1 20:10:51 MyBookLiveDuo kernel: md: bind<sdb4>
Jul  1 20:10:51 MyBookLiveDuo kernel: RAID1 conf printout:
Jul  1 20:10:51 MyBookLiveDuo kernel: disk 0, wo:0, o:1, dev:sda4
Jul  1 20:10:51 MyBookLiveDuo kernel: disk 1, wo:1, o:1, dev:sdb4
Jul  1 20:10:51 MyBookLiveDuo kernel: md: recovery of RAID array md3
Jul  1 20:10:51 MyBookLiveDuo kernel: EXT4-fs (md3): mounted filesystem with ordered data mode




The messages file has 1922 lines, so I am not pasting the whole content here yet, unless you suggest.

6. Trying to mount sdc4 as ext4 fails:
$ sudo mount -t ext4 /dev/sdc4 p4
mount: /dev/sdc4 already mounted or p4 busy

Is there a way to confirm whether sdc4 was ext4 (as r-linux) had reported, or ext3?


7. Before trying to do fsck on sdc4, I wanted to check if you had any other suggestion based on info above. Also, looks like for fsck I should be providing filesystem type. So, wanted to check if I should try ext3 or ext4 on sdc4, when trying fsck.

Thanks
Amit


----- Original Message -----
From: Phil Turmel <philip@turmel.org>
To: Bhatia Amit <amitbhatia@rocketmail.com>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Sent: Tuesday, July 19, 2016 5:12 AM
Subject: Re: Cannot start array on disk

On 07/17/2016 03:59 PM, Bhatia Amit wrote:
> Hi
> 
> I have a WD Live duo setup with two 3TB drives in RAID1. After a
> recent power surge etc, I could not access the enclosure data. I
> removed the drives out from the enclosure and connected them via
> esata cable to a Linux laptop. One of the drives had physical noise
> and failed to connect at all. The other drive was able to connect and
> showed up as /dev/sdc. Following some online search, I issued the
> following commands to get some results, but am unable to mount the
> drive to a linux laptop via esata. Questions:
> 
> * Ideally both sdc3 and sdc4 should have shown RAID=RAID1. If sdc4 is
> showing RAID=linear, is it because the other drive went totally bad,
> and software decided to reconfigure this drive from RAID1 to linear
> ?

No way to know.  I would be inclined to believe that that you didn't
actually have raid1 set for those partitions.  Do you recall the
available space in that device while running?

> * Given the one of the two drives is totally dead, is it still
> possible to reconfigure, mount and recover data from the single
> drive?

If truly linear, no, not past the half-way mark.  The device is
identified as role 0, so it would be the beginning of the filesystem in
a linear array.  If it really was raid1 with v0.9 or v1.0 metadata, you
can mount /dev/sdc4 directly to access your data.  That it doesn't show
a detected filesystem suggests that it wasn't raid1.

Even worse, that partition shows a creation date and update date both in
2013, with no events.  Suggesting that the device hasn't actually been
running properly in the array since its initial creation.

> * I tried scanning the drive via r-linux and it does show files
> exist, but does not show any folder information. So data is there on
> the drive. Is there a way to recreate the setup with just this single
> drive, so that I can extract files with folder information?

With v1.0 metadata, you should be able to fsck /dev/sdc4 and then mount.
Kinda dangerous though -- I suggest you use an overlay for that.  I
suspect that sdc4 hasn't been running in your array for the past three
years.


> * Looking at an online "derrick" script, the script seems to call
> mdadm create with the "missing" flag. Is that something I should be
> doing to be able to assemble and recover data from the drive ?

> "mdadm --create $rootfsRaid --verbose --metadata=0.9 --raid-devices=2
> --level=raid1 --run $diskRoot1 missing"

No.

Using --create is practically never the right solution, unless you've
done operations that destroy the right solution.  Metadata v0.9 is
almost certainly wrong.

If you have syslogs on your other array that show the boot details from
the last successful boot *before* it died, that might provide the
details needed to figure if anything recent is on sdc4.

Phil
