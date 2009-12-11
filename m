From: Matthew Tehonica <matt.tehonica@mac.com>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Thu, 10 Dec 2009 19:04:32 -0500
Message-ID: <91296851101702456968380052308470713510-Webmail@me.com>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com>
 <20091211071006.56270ebf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20091211071006.56270ebf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 
On Thursday, December 10, 2009, at 03:10PM, "Neil Brown" <neilb@suse.de> wrote:
>On Thu, 10 Dec 2009 12:15:09 -0500
>Matt Tehonica <matt.tehonica@mac.com> wrote:
>
>> Hi all,
>> 
>> I was just wondering if anyone else has seen a problem when creating a  
>> RAID5 where mdadm will create it and it shows all disks as spares and  
>> above it shows all drives as removed. I can't seem to figure this. Any  
>> sugestions would be great.
>
>Maybe the raid456 modules isn't getting loaded?
>
>If you show us the exact command, the exact contents of /proc/mdstat,
>and any kernel log messages generated at the time it will be a lot easier
>to explain what is happening.
>
>NeilBrown
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

 On Thursday, December 10, 2009, at 03:10PM, "Neil Brown" <neilb@suse.de> wrote:
>On Thu, 10 Dec 2009 12:15:09 -0500
>Matt Tehonica <matt.tehonica@mac.com> wrote:
>
>> Hi all,
>> 
>> I was just wondering if anyone else has seen a problem when creating a  
>> RAID5 where mdadm will create it and it shows all disks as spares and  
>> above it shows all drives as removed. I can't seem to figure this. Any  
>> sugestions would be great.
>
>Maybe the raid456 modules isn't getting loaded?
>
>If you show us the exact command, the exact contents of /proc/mdstat,
>and any kernel log messages generated at the time it will be a lot easier
>to explain what is happening.
>
>NeilBrown
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Thanks for the response.  Here is some more info....

When I create the RAID5 using: sudo mdadm --create --verbose /dev/md2 --chunk=512 --level=raid5 --raid-devices=3 /dev/sde /dev/sdf /dev/sdg

it shows: mdadm: 
layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: size set to 1465138176K
mdadm: Defaulting to version 1.1 metadata
mdadm: array /dev/md2 started.

So great, the array is created and started.  Then I cat /proc/mdstat and see: 

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
md2 : active raid5 sdg[3] sdf[1] sde[0]
      2930276352 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  0.0% (0/1465138176) finish=201456499.2min speed=0K/sec
      
After about 5 minutes, I try to cat /proc/mdstat again and it just freezes and sits there with the cursor flashing.  At this point, I can do anything with mdadm, not even like a --detail on another array on the system.  Just sits there and flashes.  I've tried with a bunch of different disks and same thing all the time.  Here is a section from my kern.log.  

Dec 10 19:01:07 ghostrider kernel: [ 1338.011320] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011330] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011343] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011349] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011443] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011449] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:01:07 ghostrider kernel: [ 1338.011461] end_request: I/O error, dev sdf, sector 0
Dec 10 19:01:07 ghostrider kernel: [ 1338.011472] md: super_written gets error=-5, uptodate=0
Dec 10 19:01:07 ghostrider kernel: [ 1338.011516] sd 6:0:2:0: [sdg] Unhandled error code
Dec 10 19:01:07 ghostrider kernel: [ 1338.011521] sd 6:0:2:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Dec 10 19:01:07 ghostrider kernel: [ 1338.011529] end_request: I/O error, dev sdg, sector 2930277167
Dec 10 19:01:07 ghostrider kernel: [ 1338.031349] md: md2: recovery done.
Dec 10 19:01:07 ghostrider kernel: [ 1338.031556] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.031561]  --- rd:3 wd:0
Dec 10 19:01:07 ghostrider kernel: [ 1338.031566]  disk 0, o:0, dev:sde
Dec 10 19:01:07 ghostrider kernel: [ 1338.031571]  disk 1, o:0, dev:sdf
Dec 10 19:01:07 ghostrider kernel: [ 1338.031575]  disk 2, o:0, dev:sdg
Dec 10 19:01:07 ghostrider kernel: [ 1338.080421] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.080424]  --- rd:3 wd:0
Dec 10 19:01:07 ghostrider kernel: [ 1338.080427]  disk 0, o:0, dev:sde
Dec 10 19:01:07 ghostrider kernel: [ 1338.080429]  disk 1, o:0, dev:sdf
Dec 10 19:01:07 ghostrider kernel: [ 1338.080437] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.080439]  --- rd:3 wd:0
Dec 10 19:01:07 ghostrider kernel: [ 1338.080440]  disk 0, o:0, dev:sde
Dec 10 19:01:07 ghostrider kernel: [ 1338.080441]  disk 1, o:0, dev:sdf
Dec 10 19:01:07 ghostrider kernel: [ 1338.120169] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.120177]  --- rd:3 wd:0
Dec 10 19:01:07 ghostrider kernel: [ 1338.120184]  disk 0, o:0, dev:sde
Dec 10 19:01:07 ghostrider kernel: [ 1338.120200] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.120203]  --- rd:3 wd:0
Dec 10 19:01:07 ghostrider kernel: [ 1338.120206]  disk 0, o:0, dev:sde
Dec 10 19:01:07 ghostrider kernel: [ 1338.160092] RAID5 conf printout:
Dec 10 19:01:07 ghostrider kernel: [ 1338.160101]  --- rd:3 wd:0
Dec 10 19:01:38 ghostrider kernel: [ 1369.011322] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:38 ghostrider kernel: [ 1369.011332] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:01:38 ghostrider kernel: [ 1369.011346] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:38 ghostrider kernel: [ 1369.011352] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:01:38 ghostrider kernel: [ 1369.011360] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:01:38 ghostrider kernel: [ 1369.011365] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010077] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010087] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010101] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010107] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010115] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Dec 10 19:02:09 ghostrider kernel: [ 1400.010120] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5

Any ideas??  Thanks!
