From: John Hendrikx <hjohn@xs4all.nl>
Subject: Drives disappearing from /dev/ during surface scan
Date: Thu, 24 Jun 2010 17:16:02 +0200
Message-ID: <4C2376B2.3080606@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm wondering if anyone could share some insight into a problem I'm having.

The problem is that every week, one or two harddrives simply disappear 
(from /dev/) during the weekly wednesday morning long surface scan 
triggered by smartctl.  The scan starts at 6 am, and the drives dropped 
at 6:30 am and the next week at 8:30 am (the surface scans take I think 
~3 hours).

Messages in syslog are similar to this:

> Jun 23 08:27:58 Ukyo kernel: ata3: hard resetting link
> Jun 23 08:27:59 Ukyo kernel: ata3: SATA link down (SStatus 0 SControl 300)
> Jun 23 08:28:04 Ukyo kernel: ata3: hard resetting link
> Jun 23 08:28:04 Ukyo kernel: ata3: SATA link down (SStatus 0 SControl 300)
> Jun 23 08:28:09 Ukyo kernel: ata3: hard resetting link
> Jun 23 08:28:09 Ukyo kernel: ata3: SATA link down (SStatus 0 SControl 300)
> Jun 23 08:28:09 Ukyo kernel: ata3.00: disabled
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Sense Key : Aborted 
> Command [current] [descriptor]
> Jun 23 08:28:09 Ukyo kernel: Descriptor sense data with sense 
> descriptors (in hex):
> Jun 23 08:28:09 Ukyo kernel:         72 0b 47 00 00 00 00 0c 00 0a 80 
> 00 00 00 00 00
> Jun 23 08:28:09 Ukyo kernel:         0f ff ff ff
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Add. Sense: Scsi parity 
> error
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Result: 
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> Jun 23 08:28:09 Ukyo kernel: md: super_written gets error=-5, uptodate=0
> Jun 23 08:28:09 Ukyo kernel: ata3: EH complete
> Jun 23 08:28:09 Ukyo kernel: ata3.00: detaching (SCSI 3:0:0:0)
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Stopping disk
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] START_STOP FAILED
> Jun 23 08:28:09 Ukyo kernel: sd 3:0:0:0: [sdc] Result: 
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Trying to get the drive back by using:

 echo "- - -" /sys/class/scsi_host/hostX/scan

Has no effect (in the log, ata3 gets rescanned but no drives are found):
> Jun 24 16:36:21 Ukyo kernel: ata3: hard resetting link
> Jun 24 16:36:22 Ukyo kernel: ata3: SATA link down (SStatus 0 SControl 300)
> Jun 24 16:36:22 Ukyo kernel: ata3: EH complete
> Jun 24 16:36:31 Ukyo kernel: ata4: hard resetting link
> Jun 24 16:36:32 Ukyo kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 
> SControl 300)
> Jun 24 16:36:32 Ukyo kernel: ata4.00: configured for UDMA/133
> Jun 24 16:36:32 Ukyo kernel: ata4: EH complete
> Jun 24 16:36:32 Ukyo kernel: sd 4:0:0:0: [sdd] 1953525168 512-byte 
> hardware sectors (1000205 MB)
> Jun 24 16:36:32 Ukyo kernel: sd 4:0:0:0: [sdd] Write Protect is off
> Jun 24 16:36:32 Ukyo kernel: sd 4:0:0:0: [sdd] Write cache: disabled, 
> read cache: enabled, doesn't support DPO or
Rebooting the system returns /dev/sdc (ata3) to working order, and 
re-adding it to the array results in a short repair and everything is 
good again for another week.

This only happens during the surface scan, and has been hard to 
reproduce with just regular server use (copying, array rebuilding, etc..)

I suspect it may be a power issue, so I'm supplying some more numbers.  
The PSU is rated for 460 watt, 165 watt 5v, 312 watt 12v.  There's 10 
drives in there, all recent models (1 TB+).  System temperature is 
normal (four 12 cm fans installed, not counting the PSU one).

I'm however somewhat skeptical about the power issue, as I used to have 
another server that would hit its power limiter during a cold start (ie, 
it would not power on as the spin-up cycle caused an overload) -- 
however, that server would still power up fully when forcing it to start 
by simply powering it on 2 or 3 times quickly in a row.  It would run 
stable for months once it managed to spin up all drives.

Any insights why this might occur is appreciated.  I'm currently 
considering spreading the weekly surface scans out a bit to prevent 
this, but would rather find out what the real issue is.  Other things 
I'm considering is replacing two drives for one drive (2x 1 TB -> 2 TB) 
to reduce power load a bit... or finding a PSU that is rated a bit higher.

--John





