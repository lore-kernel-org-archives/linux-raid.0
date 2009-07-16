From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: hdaprm -Y /dev/sda /dev/sdb -> I/O error -> disk kicked out of RAID
 - is it normal?
Date: Fri, 17 Jul 2009 01:03:57 +0200
Message-ID: <4A5FB1DD.3000904@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

hdparm -Y /dev/sda /dev/sdb renders this:

Jul 17 00:55:50 dom klogd: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
Jul 17 00:55:50 dom klogd: ata1.00: waking up from sleep
Jul 17 00:55:50 dom klogd: ata1: hard resetting link
Jul 17 00:55:50 dom klogd: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
Jul 17 00:55:50 dom klogd: ata2.00: waking up from sleep
Jul 17 00:55:50 dom klogd: ata2: hard resetting link
Jul 17 00:55:50 dom klogd: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 17 00:55:50 dom klogd: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 17 00:55:50 dom klogd: ata2.00: configured for UDMA/133
Jul 17 00:55:50 dom klogd: ata2: EH complete
Jul 17 00:55:50 dom klogd: ata1.00: configured for UDMA/133
Jul 17 00:55:50 dom klogd: ata1: EH complete
Jul 17 00:55:55 dom klogd: end_request: I/O error, dev sda, sector 225263226
Jul 17 00:55:55 dom klogd: md: super_written gets error=-5, uptodate=0
Jul 17 00:55:55 dom klogd: raid1: Disk failure on sda2, disabling device.
Jul 17 00:55:55 dom klogd: raid1: Operation continuing on 1 devices.
Jul 17 00:55:55 dom klogd: end_request: I/O error, dev sdb, sector 225263226
Jul 17 00:55:55 dom klogd: md: super_written gets error=-5, uptodate=0
Jul 17 00:55:55 dom klogd: RAID1 conf printout:
Jul 17 00:55:55 dom klogd:  --- wd:1 rd:2
Jul 17 00:55:55 dom klogd:  disk 0, wo:1, o:0, dev:sda2
Jul 17 00:55:55 dom klogd:  disk 1, wo:0, o:1, dev:sdb2
Jul 17 00:55:55 dom klogd: RAID1 conf printout:
Jul 17 00:55:55 dom klogd:  --- wd:1 rd:2
Jul 17 00:55:55 dom klogd:  disk 1, wo:0, o:1, dev:sdb2


And one of the disks is kicked out of RAID.

Is it expected behaviour (although probably the error happens somewhere in the ata layer)?
It is kernel 2.6.30.1 and AHCI driver.

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller


# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda5[1] sdb5[0]
      511999424 blocks [2/2] [UU]

md3 : active raid1 sda6[1] sdb6[0]
      96256 blocks [2/2] [UU]

md0 : active raid1 sdb1[0] sda1[1]
      10233280 blocks [2/2] [UU]

md1 : active raid1 sda2[2](F) sdb2[1]
      102398208 blocks [2/1] [_U]

unused devices: <none>


-- 
Tomasz Chmielewski
http://wpkg.org
