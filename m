From: Michael Renner <michael.renner@geizhals.at>
Subject: Logging-Loop when a drive in a raid1 fails.
Date: Mon, 13 Dec 2004 06:52:02 +0100
Message-ID: <41BD2E02.8020100@geizhals.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000101060601030205020501"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000101060601030205020501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

one of the drives in a software raid1 failed, on a machine running 
2.6.9-rc2, leading to this "logging-spree" (see attachment).

Sorry if this has been fixed in the meanwhile; it's not that easy to 
test codepaths for failing drives with various kernels without having 
access to special block devices which support on-demand-failing.

Furthermore I'm a bit concerned about the overall quality of the md 
support in 2.6, this is not the first bug I see with codepaths which 
don't get used during normal operation. When all drives are fine the 
driver is rock solid, but as soon as a block device gets funky, hell 
tends to break loose. I'm a bit surprised because I've never had any 
problems in 2.4. Were there major api/code changes which could be the 
cause for that?

Another odd behaviour, for which I don't have exact information anymore, 
was when md tried to do a resync of a degraded raid5, hit a bad block on 
one of the (supposedly) "good" drives, and entered a tight loop of 
resync processes starting/aborting. This was with 2.6.9, unfortunately I 
wasn't able to take records because of time constraints and arising panic.

best regards,
michael

--------------000101060601030205020501
Content-Type: text/plain;
 name="md-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md-log.txt"

Dec 13 02:03:13 stuff kernel: scsi0: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 01 5b ff 3c 00 00 08 00
Dec 13 02:03:13 stuff kernel: Info fld=0x15bff3e, Current sda: sense key Medium Error
Dec 13 02:03:13 stuff kernel: Additional sense: Unrecovered read error
Dec 13 02:03:13 stuff kernel: end_request: I/O error, dev sda, sector 22806332
Dec 13 02:03:13 stuff kernel: raid1: Disk failure on sda2, disabling device.
Dec 13 02:03:13 stuff kernel: ^IOperation continuing on 1 devices
Dec 13 02:03:13 stuff kernel: printk: 77 messages suppressed.
Dec 13 02:03:13 stuff kernel: raid1: sda2: rescheduling sector 18886472
Dec 13 02:03:13 stuff kernel: RAID1 conf printout:
Dec 13 02:03:13 stuff kernel:  --- wd:1 rd:2
Dec 13 02:03:13 stuff kernel:  disk 0, wo:1, o:0, dev:sda2
Dec 13 02:03:13 stuff kernel:  disk 1, wo:0, o:1, dev:sdb2
Dec 13 02:03:13 stuff kernel: RAID1 conf printout:
Dec 13 02:03:13 stuff kernel:  --- wd:1 rd:2
Dec 13 02:03:13 stuff kernel:  disk 1, wo:0, o:1, dev:sdb2
Dec 13 02:03:13 stuff kernel: raid1: sdb2: redirecting sector 18886472 to another mirror
Dec 13 02:03:13 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:13 stuff kernel: raid1: sdb2: redirecting sector 18886472 to another mirror
Dec 13 02:03:13 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:13 stuff kernel: raid1: sdb2: redirecting sector 18886472 to another mirror
Dec 13 02:03:13 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:13 stuff kernel: raid1: sdb2: redirecting sector 18886472 to another mirror
Dec 13 02:03:13 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:13 stuff kernel: raid1: sdb2: redirecting sector 18886472 to another mirror
Dec 13 02:03:18 stuff kernel: printk: 119408 messages suppressed.
Dec 13 02:03:18 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:23 stuff kernel: printk: 119581 messages suppressed.
Dec 13 02:03:23 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:28 stuff kernel: printk: 125937 messages suppressed.
Dec 13 02:03:28 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:33 stuff kernel: printk: 132411 messages suppressed.
Dec 13 02:03:34 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:38 stuff kernel: printk: 128773 messages suppressed.
Dec 13 02:03:39 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:43 stuff kernel: printk: 129557 messages suppressed.
Dec 13 02:03:44 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:48 stuff kernel: printk: 130365 messages suppressed.
Dec 13 02:03:49 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:53 stuff kernel: printk: 129959 messages suppressed.
Dec 13 02:03:54 stuff kernel: raid1: sdb2: rescheduling sector 18886472
Dec 13 02:03:58 stuff kernel: printk: 125235 messages suppressed.
Dec 13 02:03:59 stuff kernel: raid1: sdb2: rescheduling sector 18886472
[.. Continue ad nauseam ..]
--------------000101060601030205020501--
