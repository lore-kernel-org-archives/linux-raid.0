From: Kresimir Kukulj <madmax@iskon.hr>
Subject: problems with raid6, mdadm: RUN_ARRAY failed
Date: Fri, 2 Jun 2006 23:22:12 +0200
Message-ID: <20060602212212.GA14530@max.zg.iskon.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have some old controler Mylex Acceleraid 170LP with 6 SCSI 36GB disks on
it. Running hardware raid5 resulted with very poor performance (7Mb/sec in
sequential writing, with horrid iowait).

So I configured it to export 6 logical disks and tried creating raid6 and see
if I can get better results. Trying to create an array with a missing component
results in:

~/mdadm-2.5/mdadm -C /dev/md3 -l6 -n6 /dev/rd/c0d0p3  /dev/rd/c0d2p3 /dev/rd/c0d3p3 /dev/rd/c0d4p3 /dev/rd/c0d5p3 missing
mdadm: RUN_ARRAY failed: Input/output error

strace shows it barfed on some ioctl:

read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbffe64b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 4096, [4096], SEEK_SET)      = 0
read(4, "\3\0\0\0\4\0\0\0\5\0\0\0\355]\325?\2\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
close(4)                                = 0
open("/dev/rd/c0d5p3", O_RDWR|O_EXCL)   = 4
ioctl(4, BLKGETSIZE64, 0xbffe66d0)      = 0
_llseek(4, 31330009088, [31330009088], SEEK_SET) = 0
write(4, "\374N+\251\0\0\0\0Z\0\0\0\0\0\0\0\0\0\0\0\34\3077\262\353"..., 4096) = 4096
fsync(4)                                = 0
close(4)                                = 0
ioctl(3, 0x40140921, 0xbffe67a0)        = 0
ioctl(3, 0x400c0930, 0xbffe67a0)        = -1 EIO (Input/output error)
write(2, "mdadm: RUN_ARRAY failed: Input/o"..., 44) = 44
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 3), ...}) = 0
ioctl(3, 0x800c0910, 0xbffe6660)        = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 3), ...}) = 0
ioctl(3, 0x800c0910, 0xbffe6660)        = 0
ioctl(3, 0x932, 0)                      = 0
exit_group(1)                           = ?

Running:
vanilla 2.6.16.19
Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6]
mdadm-2.5

Creating a filesystem (mke2fs) on /dev/rd/c0d[0234]p3 works without a problem
so devices are accessible.

Any hints ?

-- 
Kresimir Kukulj                      madmax@iskon.hr
+--------------------------------------------------+
Remember, if you break Debian, you get to keep both parts.
