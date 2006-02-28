From: "kyle" <kylewong@southa.com>
Subject: disk failure but raid 5 does not degrade
Date: Tue, 28 Feb 2006 23:51:19 +0800
Message-ID: <00ce01c63c7e$d122c320$28df0f3d@kyleont8n3poyo>
Reply-To: "kyle" <kylewong@southa.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Recently I have my RAID5 freeze up twice within one month, with single disk
failure, /dev/sda. The RAID5 doesn't go to degrade mode, all processes from
nfs clients trying to access the freezed RAID5 stuck in "D" state, the nfs
server running the RAID5 cannot be shutdown, only power button works. The
nfs server is running kernel 2.6.15.2

Actually I wonder it's really disk (sda) failure or not, I haven't test the
drive yet.  However I found something like:
Feb 27 18:26:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
maybe libata problem? Anyway I expect RAID5 should go to degrade mode
instead of just freeze in this case. Maybe the new "RAID5 read failure
handling" make the RAID doesn't go to degrade mode?

Please CC me if possible, thanks.

My raid configuration (after replaced sda and resync):
[root@images1 log]# more /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdc2[1] hda2[0]
      6144768 blocks [2/2] [UU]

md2 : active raid5 sda1[2] hda4[0] sdf1[7] sde1[6] sdd1[5] sdc1[4] sdb1[3]
hdc4[1]
      1664893440 blocks level 5, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]

md0 : active raid1 hdc1[1] hda1[0]
      104320 blocks [2/2] [UU]

/var/log/message:
Feb 27 18:26:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:26:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:26:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:26:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:26:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:26:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:26:11 images1 kernel: end_request: I/O error, dev sda, sector
44318183
Feb 27 18:26:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:26:11 images1 last message repeated 2 times
Feb 27 18:26:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:26:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:26:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:26:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:26:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:26:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:26:41 images1 kernel: end_request: I/O error, dev sda, sector
44318191
Feb 27 18:26:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:26:41 images1 last message repeated 2 times
Feb 27 18:27:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:27:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:27:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:27:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:27:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:27:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:27:11 images1 kernel: end_request: I/O error, dev sda, sector
44318199
Feb 27 18:27:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:27:11 images1 last message repeated 2 times
Feb 27 18:27:23 images1 PAM-securetty[4594]: access denied: tty 'pts/0' is
not secure !
Feb 27 18:27:28 images1 login[4594]: FAILED LOGIN 1 FROM 152.101.81.89 FOR
root, Authentication failure
Feb 27 18:27:32 images1 remote(pam_unix)[4594]: session opened for user kyle
by (uid=0)
Feb 27 18:27:32 images1  -- kyle[4594]: LOGIN ON pts/0 BY kyle FROM
152.101.81.89
Feb 27 18:27:36 images1 su(pam_unix)[4619]: authentication failure; logname=
uid=500 euid=0 tty=pts/0 ruser=kyle rhost=  user=root
Feb 27 18:27:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:27:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:27:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:27:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:27:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:27:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:27:41 images1 kernel: end_request: I/O error, dev sda, sector
44318207
Feb 27 18:27:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:27:41 images1 last message repeated 2 times
Feb 27 18:27:42 images1 su(pam_unix)[4620]: session opened for user root by
(uid=500)
Feb 27 18:28:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:28:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:28:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:28:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:28:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:28:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:28:11 images1 kernel: end_request: I/O error, dev sda, sector
44318231
Feb 27 18:28:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:28:11 images1 last message repeated 2 times
Feb 27 18:28:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:28:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:28:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:28:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:28:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:28:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:28:41 images1 kernel: end_request: I/O error, dev sda, sector
44318239
Feb 27 18:28:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:28:41 images1 last message repeated 2 times
Feb 27 18:29:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:29:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:29:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:29:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:29:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:29:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:29:11 images1 kernel: end_request: I/O error, dev sda, sector
336291503
Feb 27 18:29:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:29:11 images1 last message repeated 2 times
Feb 27 18:29:35 images1 telnetd[4906]: ttloop: read: Connection reset by
peer
Feb 27 18:29:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:29:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:29:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:29:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:29:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:29:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:29:41 images1 kernel: end_request: I/O error, dev sda, sector
336390743
Feb 27 18:29:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:29:41 images1 last message repeated 2 times
Feb 27 18:30:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:30:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:30:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:30:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:30:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:30:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:30:11 images1 kernel: end_request: I/O error, dev sda, sector
336390751
Feb 27 18:30:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:30:11 images1 last message repeated 2 times
Feb 27 18:30:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:30:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:30:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:30:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:30:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:30:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:30:41 images1 kernel: end_request: I/O error, dev sda, sector
336390759
Feb 27 18:30:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:30:41 images1 last message repeated 2 times
Feb 27 18:31:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:31:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:31:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:31:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:31:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:31:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:31:11 images1 kernel: end_request: I/O error, dev sda, sector
336390767
Feb 27 18:31:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:31:11 images1 last message repeated 2 times
Feb 27 18:31:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:31:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:31:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:31:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:31:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:31:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:31:41 images1 kernel: end_request: I/O error, dev sda, sector
336390775
Feb 27 18:31:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:31:41 images1 last message repeated 2 times
Feb 27 18:32:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:32:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:32:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:32:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:32:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:32:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:32:11 images1 kernel: end_request: I/O error, dev sda, sector
336390783
Feb 27 18:32:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:32:11 images1 last message repeated 2 times
Feb 27 18:32:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:32:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:32:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:32:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:32:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:32:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:32:41 images1 kernel: end_request: I/O error, dev sda, sector
336390791
Feb 27 18:32:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:32:41 images1 last message repeated 2 times
Feb 27 18:32:44 images1 su(pam_unix)[4620]: session closed for user root
Feb 27 18:32:45 images1 remote(pam_unix)[4594]: session closed for user kyle
Feb 27 18:33:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:33:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:33:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:33:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:33:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:33:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:33:11 images1 kernel: end_request: I/O error, dev sda, sector
336390799
Feb 27 18:33:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:33:11 images1 last message repeated 2 times
Feb 27 18:33:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:33:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:33:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:33:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:33:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:33:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:33:41 images1 kernel: end_request: I/O error, dev sda, sector
336390807
Feb 27 18:33:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:33:41 images1 last message repeated 2 times
Feb 27 18:34:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:34:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:34:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:34:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:34:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:34:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:34:11 images1 kernel: end_request: I/O error, dev sda, sector
336390815
Feb 27 18:34:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:34:11 images1 last message repeated 2 times
Feb 27 18:34:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:34:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:34:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:34:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:34:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:34:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:34:41 images1 kernel: end_request: I/O error, dev sda, sector
336390823
Feb 27 18:34:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:34:41 images1 last message repeated 2 times
Feb 27 18:35:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:35:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:35:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:35:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:35:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:35:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:35:11 images1 kernel: end_request: I/O error, dev sda, sector
336390831
Feb 27 18:35:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:35:11 images1 last message repeated 2 times
Feb 27 18:35:41 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:35:41 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:35:41 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:35:41 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:35:41 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:35:41 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:35:41 images1 kernel: end_request: I/O error, dev sda, sector
336390839
Feb 27 18:35:41 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:35:41 images1 last message repeated 2 times
Feb 27 18:36:11 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 18:36:11 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 18:36:11 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 18:36:11 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 18:36:11 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 18:36:11 images1 kernel:     Additional sense: Scsi parity error
Feb 27 18:36:11 images1 kernel: end_request: I/O error, dev sda, sector
336390847
Feb 27 18:36:11 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 18:36:11 images1 last message repeated 2 times
..........................
..........................
..........................
Feb 27 19:46:12 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 19:46:12 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 19:46:12 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 19:46:12 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 19:46:12 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 19:46:12 images1 kernel:     Additional sense: Scsi parity error
Feb 27 19:46:12 images1 kernel: end_request: I/O error, dev sda, sector
336391695
Feb 27 19:46:12 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
Feb 27 19:46:12 images1 last message repeated 2 times
Feb 27 19:46:14 images1 shutdown: shutting down for system reboot
Feb 27 19:46:40 images1 login(pam_unix)[5137]: session opened for user root
by (uid=0)
Feb 27 19:46:41 images1  -- root[5137]: ROOT LOGIN ON tty3
Feb 27 19:46:42 images1 kernel: ata1: command 0x25 timeout, stat 0xd0
host_stat 0x21
Feb 27 19:46:42 images1 kernel: ata1: translated ATA stat/err 0xd0/00 to
SCSI SK/ASC/ASCQ 0xb/47/00
Feb 27 19:46:42 images1 kernel: ata1: status=0xd0 { Busy }
Feb 27 19:46:42 images1 kernel: sd 0:0:0:0: SCSI error: return code =
0x8000002
Feb 27 19:46:42 images1 kernel: sda: Current: sense key: Aborted Command
Feb 27 19:46:42 images1 kernel:     Additional sense: Scsi parity error
Feb 27 19:46:42 images1 kernel: end_request: I/O error, dev sda, sector
336391703
Feb 27 19:46:42 images1 kernel: ATA: abnormal status 0xD0 on port 0x9F7
.....................................
Cannot shutdown, power off.

Thanks a lot,
Kyle


