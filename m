From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: timeouts on 3ware 5800.. driver issue?
Date: Fri, 24 Jun 2005 10:44:38 -0700
Message-ID: <1119635078.22853.376.camel@seki.nac.uci.edu>
References: <42BC2A32.4090509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42BC2A32.4090509@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


I'd probably:

1) Fish around for a way of cranking back linux's expectations of the
"scsi device", EG cranking back the bandwidth, turning off Tagged
Command Queuing, and so on, and see if the errors persist.

2) Test each disk invidually, on a non-RAID controller, using UBCD or
similar.  You might also look them over with "smart".

3) If the disks all check out OK individually, then it may be time to
consider a different choice of RAID card - we've had some problems with
3Ware RAID cards here (or maybe a systemic problem in the SATA Maxtor
disks we were using with them).  EG, these folks appear to sell RAID
cards that don't require any lockin, binary-only drivers to use them
under linux: http://www.areca.com.tw/index/html/

HTH.

On Fri, 2005-06-24 at 10:43 -0500, Michael Stumpf wrote:
> I've got an old server I'm trying to maintain with 2 - 3ware 5800 8 port 
> cards inside, one filled with 80 gig drives, the other with 120 gig.  I 
> have 4 independent md arrays that are all in one large LVM virtual drive.
> 
> Some drives have started to go bad.  So as I  replace them with new 
> Seagate 120 gig PATA drives, I get errors in syslog similar to this:
> 
> Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
> 0xc7, flags = 0x1b, unit #2.
> Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: AEN: WARNING: ATA port 
> timeout: Port #2.
> Jun 15 22:45:14 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
> Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
> 0xc7, flags = 0x1b, unit #2.
> Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: AEN: WARNING: ATA port 
> timeout: Port #2.
> Jun 16 04:40:58 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
> Jun 16 11:24:56 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
> 0xc7, flags = 0x1b, unit #2.
> 
> This manifests in different ways.  Usually it starts up fine, but when 
> the array is idle and I attempt to access it, I see these entries.and a 
> brief
> delay, then the array works fine for a while.
> 
> I replaced it with a 200 gig older drive (yes, I know it is limited to 
> 137 gig), and this problem shifted to unit #3 (same thing, it is also a
> recently replaced new seagate 120gig).
> 
> I replace unit #3 with several different 200 gig drives (new hitachi, 
> new seagate, old WD) and always now I get on startup:
> 
> Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
> 0xc1, flags = 0x11, unit #3.
> Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: AEN: ERROR: Drive error: 
> Port #0.
> Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Reset succeeded.
> Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: Command failed: status = 
> 0xc1, flags = 0x11, unit #3.
> Jun 23 20:54:27 blimp kernel: SCSI disk error : host 1 channel 0 id 3 
> lun 0 return code = 2
> Jun 23 20:54:27 blimp kernel:  I/O error: dev 08:b1, sector 390716672
> Jun 23 20:54:27 blimp kernel: md: disabled device sdl1, could not read 
> superblock.
> Jun 23 20:54:27 blimp kernel: md: could not read sdl1's sb, not importing!
> Jun 23 20:54:27 blimp kernel: md: could not import sdl1!
> Jun 23 20:54:27 blimp kernel: 3w-xxxx: scsi1: AEN: ERROR: Drive error: 
> Port #0.
> Jun 23 20:54:27 blimp kernel: md3: former device sdl1 is unavailable, 
> removing from array!
> 
> Any suggestions?  I'm not really sure what to do now.
> 
> Regards,
> Michael Stumpf
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

