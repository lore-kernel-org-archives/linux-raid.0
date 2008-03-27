From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: how to disable partition search?
Date: Thu, 27 Mar 2008 01:45:01 +0100
Message-ID: <87skydj8qa.fsf@szonett.ki.iif.hu>
References: <87ve39lngy.fsf@tac.ki.iif.hu> <47EAB02B.3080104@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EAB02B.3080104@tmr.com> (Bill Davidsen's message of "Wed, 26
	Mar 2008 16:20:59 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Ferenc Wagner wrote:
>
>> I use an FC SAN, which provides multiple pathes to multiple LUNs.
>> These all come up as different sd* devices, exhausting single letter
>> names.  I mean they are a LOT.  Using the md mulitpath driver
>> everything works perfectly, no problems there.  However, during boot,
>> the kernel tries to read the partition table from each device,
>> spitting out hundreds of lines of error messages: most of the devices
>> aren't even readable, and those which are, don't contain a valid
>> partition table.  They never will.  So I'd like to disable partition
>> detection, because these messages overflow the kernel message buffer,
>> depriving syslog of gathering any useful boot messages, and also
>> needlessly lengthening the boot process.  (Of course the noise alone
>> is disturbing enough when one tries to troubleshoot a boot problem.)
>> However, looking at the kernel sources didn't give me any hint.  Is
>> this possible to disable at all?
>>
>> (Please Cc me, I'm not on the list.)
>
> After reading some code, I didn't see any boot or module load options
> you can use to prevent that, I think you may want to increase buffer
> size to hold the messages and use "grep -v" to create a sanitized
> dmesg.  If you can give an example of the error message you see I can
> look again.
>
> Don't forget to copy the list...

Thanks for looking into this.  As an illustration, a reboot looks like
this in the syslog:

Mar  3 17:20:55 mach kernel: Kernel logging (proc) stopped.
Mar  3 17:20:55 mach kernel: Kernel log daemon terminating.
Mar  3 17:20:56 mach exiting on signal 15
Mar  3 17:27:00 mach syslogd 1.4.1#18: restart.
Mar  3 17:27:00 mach kernel: klogd 1.4.1#18, log source = /proc/kmsg started.
[boot messages should have been inserted here.]
Mar  3 17:27:00 mach kernel:  Enabled
Mar  3 17:27:00 mach kernel:  sdd:<6>sd 0:0:0:3: [sdd] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdd, sector 0
Mar  3 17:27:00 mach kernel: sd 0:0:0:3: [sdd] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdd, sector 0
[the above 3 lines 7 more times]
Mar  3 17:27:00 mach kernel: Dev sdd: unable to read RDB block 0
[those 3 lines 2 more times]
Mar  3 17:27:00 mach kernel: sd 0:0:0:3: [sdd] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdd, sector 24
Mar  3 17:27:00 mach kernel: printk: 29 messages suppressed.
Mar  3 17:27:00 mach kernel: sd 0:0:0:3: [sdd] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdd, sector 24
Mar  3 17:27:00 mach kernel: sd 0:0:0:3: [sdd] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdd, sector 0
Mar  3 17:27:00 mach kernel:  unable to read partition table
Mar  3 17:27:00 mach kernel: sd 0:0:0:3: [sdd] Attached SCSI disk
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] 10485760 512-byte hardware sectors (5369 MB)
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] Write Protect is off
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] Cache data unavailable
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] 10485760 512-byte hardware sectors (5369 MB)
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] Write Protect is off
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] Cache data unavailable
Mar  3 17:27:00 mach kernel:  sde: unknown partition table
Mar  3 17:27:00 mach kernel: sd 0:0:1:0: [sde] Attached SCSI disk
Mar  3 17:27:00 mach kernel: sd 0:0:1:1: [sdf] 419430400 512-byte hardware sectors (214748 MB)
Mar  3 17:27:00 mach kernel: sd 0:0:1:1: [sdf] Test WP failed, assume Write Enabled
Mar  3 17:27:00 mach kernel: sd 0:0:1:1: [sdf] 419430400 512-byte hardware sectors (214748 MB)
Mar  3 17:27:00 mach kernel: sd 0:0:1:1: [sdf] Test WP failed, assume Write Enabled
Mar  3 17:27:00 mach kernel:  sdf:<6>sd 0:0:1:1: [sdf] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdf, sector 0
Mar  3 17:27:00 mach kernel: sd 0:0:1:1: [sdf] Device not ready: <6>: Sense Key : Not Ready [current] 
Mar  3 17:27:00 mach kernel: : Add. Sense: Logical unit not ready, manual intervention required
Mar  3 17:27:00 mach kernel: end_request: I/O error, dev sdf, sector 0
[and so on]

It would be possible to grep out the offending lines, but I'd rather
fight the cause than the symptom.  Doing my research I realized I'm
not alone with this problem.  Looks like a recompilation is necessary,
so I'm turning this into a feature request: how could selective
partition check be added to the Linux kernel?  I'm willing to give it
a shot under some expert guidance.
-- 
Thanks,
Feri.
