From: Richard Scobie <richard@sauce.co.nz>
Subject: sd takes drive offline but md does not know
Date: Sat, 29 Nov 2008 21:19:45 +1300
Message-ID: <4930FB21.2070108@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have system running 2.6.26.6-79.fc9.x86_64 using a 16 SATA drive md 
RAID6 behind an LSI 1068 SAS controller.

The current stable version of smartmontools cannot be started at boot 
time if samba is also started at the same time - see:

http://marc.info/?l=smartmontools-support&m=122518510306493&w=2

Up until today, about 1 month, I have been able to run smartd and issue 
smrtctl commands without problem.

Today I smartctl'ed a drive (sdr) in the array and the drive was reset 
and finally offlined.

Is it to be expected that in this scenario, md was ignorant of this and 
/proc/mdstat showed this drive as being present still?

Only when the array is unmounted and possibly if filesystem activity 
occurs do thing fall over badly - in this case external ssh and console 
access hung and a reset was required. The log shows nothing of note 
after the following until the machine reboots:

Nov 29 13:12:56 avidstorage kernel: mptscsih: ioc0: attempting task 
abort! (sc=ffff810226524dc0)
Nov 29 13:12:56 avidstorage kernel: sd 8:0:15:0: [sdr] CDB: ATA command 
pass through(16): 85 08 0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
Nov 29 13:12:58 avidstorage kernel: mptbase: ioc0: LogInfo(0x31140000): 
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Nov 29 13:12:58 avidstorage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff810226524dc0)
Nov 29 13:13:08 avidstorage kernel: mptscsih: ioc0: attempting task 
abort! (sc=ffff810226524dc0)
Nov 29 13:13:08 avidstorage kernel: sd 8:0:15:0: [sdr] CDB: Test Unit 
Ready: 00 00 00 00 00 00
Nov 29 13:13:10 avidstorage kernel: mptbase: ioc0: LogInfo(0x31140000): 
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Nov 29 13:13:10 avidstorage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff810226524dc0)
Nov 29 13:13:10 avidstorage kernel: mptscsih: ioc0: attempting target 
reset! (sc=ffff810226524dc0)
Nov 29 13:13:10 avidstorage kernel: sd 8:0:15:0: [sdr] CDB: ATA command 
pass through(16): 85 08 0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
Nov 29 13:13:12 avidstorage kernel: mptscsih: ioc0: Issue of TaskMgmt 
failed!
Nov 29 13:13:12 avidstorage kernel: mptscsih: ioc0: target reset: FAILED 
(sc=ffff810226524dc0)
Nov 29 13:13:12 avidstorage kernel: mptscsih: ioc0: attempting bus 
reset! (sc=ffff810226524dc0)
Nov 29 13:13:12 avidstorage kernel: sd 8:0:15:0: [sdr] CDB: ATA command 
pass through(16): 85 08 0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
Nov 29 13:13:20 avidstorage kernel: mptscsih: ioc0: bus reset: SUCCESS 
(sc=ffff810226524dc0)
Nov 29 13:13:40 avidstorage kernel: mptscsih: ioc0: attempting task 
abort! (sc=ffff810226524dc0)
Nov 29 13:13:40 avidstorage kernel: sd 8:0:15:0: [sdr] CDB: Test Unit 
Ready: 00 00 00 00 00 00
Nov 29 13:13:42 avidstorage kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Nov 29 13:13:42 avidstorage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff810226524dc0)
Nov 29 13:13:42 avidstorage kernel: mptscsih: ioc0: attempting host 
reset! (sc=ffff810226524dc0)
Nov 29 13:13:42 avidstorage kernel: mptbase: ioc0: Initiating recovery
Nov 29 13:13:57 avidstorage kernel: mptscsih: ioc0: host reset: SUCCESS 
(sc=ffff810226524dc0)
Nov 29 13:13:57 avidstorage kernel: sd 8:0:15:0: Device offlined - not 
ready after error recovery
Nov 29 13:18:05 avidstorage ntpd[3101]: kernel time sync status change 4001
Nov 29 13:26:40 avidstorage smartd[3468]: Device: /dev/sdr, No such 
device or address, open() failed
Nov 29 13:26:40 avidstorage smartd[3468]: Sending warning via mail to 
root@sauce.co.nz ...
Nov 29 13:26:40 avidstorage smartd[3468]: Warning via mail to 
root@sauce.co.nz: successful


Regards,

Richard
