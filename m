From: George Karaolides <george.karaolides@planitis.net>
Subject: Hot-removing SCSI disk freezes system
Date: 08 Apr 2003 22:37:29 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1049830649.2926.3.camel@deimos>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am stress-testing an LVM-on-RAID5 setup with Debian GNU/Linux 3.0
"woody".  Kernel version is 2.4.20

To test redundancy I hot-remove one of the SCSI SCA disks in which the
array is built.

A lot of error messages come up, ending with:

sym53c8xx_reset: pid=383206 reset_flags=1 serial_number_at_timeout=0
scsi0: device driver called scsi_done() for a synchronous reset.
SCSI disk error: host 0 channel 0 id 2 lun 0 return code = 2603007f
I/O error: dev 08:22, sector 31496

The machine then locks up.  It looks like the kernel is still there: 
The syslog still dumps to stdout, the TCP/IP stack responds to ping, 
and the virtual terminals present a login prompt, but I can't log in 
and nothing else works.

On reboot, the array and filesystems (I use reiserfs for everything
expcept /boot which is on ext2) come up normally (arrays come up in
degraded mode, of course).  This is good news, but I'd rather the 
machine did not freeze.

Anyone have any ideas as to what causes the crash and how to prevent
it?



-- 
Best regards,

|   George Karaolides                      Planitis Communications Ltd.,
|
|   tel:   +357 22 45 65 00              Office 102, 11 Florinis Street,
|
|   web:   www.planitis.net                             Nicosia CY 1065,
|
|   email: george.karaolides@planitis.net           Republic  of Cyprus.
|


