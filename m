From: Michael Stumpf <mjstumpf@pobox.com>
Subject: timeouts on 3ware 5800.. driver issue?
Date: Fri, 24 Jun 2005 10:43:46 -0500
Message-ID: <42BC2A32.4090509@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got an old server I'm trying to maintain with 2 - 3ware 5800 8 port 
cards inside, one filled with 80 gig drives, the other with 120 gig.  I 
have 4 independent md arrays that are all in one large LVM virtual drive.

Some drives have started to go bad.  So as I  replace them with new 
Seagate 120 gig PATA drives, I get errors in syslog similar to this:

Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
0xc7, flags = 0x1b, unit #2.
Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: AEN: WARNING: ATA port 
timeout: Port #2.
Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
0xc7, flags = 0x1b, unit #2.
Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: AEN: WARNING: ATA port 
timeout: Port #2.
Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
Jun 16 11:24:56 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
0xc7, flags = 0x1b, unit #2.

This manifests in different ways.  Usually it starts up fine, but when 
the array is idle and I attempt to access it, I see these entries.and a 
brief
delay, then the array works fine for a while.

I replaced it with a 200 gig older drive (yes, I know it is limited to 
137 gig), and this problem shifted to unit #3 (same thing, it is also a
recently replaced new seagate 120gig).

I replace unit #3 with several different 200 gig drives (new hitachi, 
new seagate, old WD) and always now I get on startup:

Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
0xc1, flags = 0x11, unit #3.
Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: AEN: ERROR: Drive error: 
Port #0.
Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
0xc1, flags = 0x11, unit #3.
Jun 23 20:54:27 blimp kernel: SCSI disk error : host 1 channel 0 id 3 
lun 0 return code = 2
Jun 23 20:54:27 blimp kernel:  I/O error: dev 08:b1, sector 390716672
Jun 23 20:54:27 blimp kernel: md: disabled device sdl1, could not read 
superblock.
Jun 23 20:54:27 blimp kernel: md: could not read sdl1's sb, not importing!
Jun 23 20:54:27 blimp kernel: md: could not import sdl1!
Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: AEN: ERROR: Drive error: 
Port #0.
Jun 23 20:54:27 blimp kernel: md3: former device sdl1 is unavailable, 
removing from array!

Any suggestions?  I'm not really sure what to do now.

Regards,
Michael Stumpf


