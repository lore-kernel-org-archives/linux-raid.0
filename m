From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Why won't mdadm start several RAIDs that appear to be
  fine?  Info from "mdadm -A --verbose"
Date: Thu, 30 Dec 2010 20:38:09 -0700
Message-ID: <20101231033910.9565CE30951@mail.futurelabusa.com>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
 <20101230232227.96C1CE30991@mail.futurelabusa.com>
 <20101231120816.6b87fa2e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101231120816.6b87fa2e@notabene.brown>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
 <20101230232227.96C1CE30991@mail.futurelabusa.com>
 <20101231120816.6b87fa2e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After explicitly stopping the RAID (mdadm -S /dev/md5), and executing the mdadm -A --verbose command as suggested, more info is forthcoming. Mdadm appears to think that /dev/sdi5 and /dev/sdj5 are "busy". Since only /dev/sda5 and /dev/sdk5 can be added to the RAID, we are hosed.

I am puzzled as to why it thinks /dev/sdi5 and /dev/sdj5 are "busy". Fdisk reports normal partition data, dmesg and the system log report no problems, and I have no trouble copying data from /dev/sdi5 and /dev/sdj5 with dd. The system log does contain messages like 

"kernel: [   47.946357] dracut: Scanning devices md0 md1 md2 md3 sdi sdi1 sdi2 sdj sdj1 sdj2 sdk sdk1 sdk2 sdl  for LVM volume groups"

but there appears to be no essential difference in the logging messages for sdi,j versus sda,k. Also, the physical devices (a,i,j,k) are the same brand and model number disk drive. The system log reports

"3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)"

for all of them. Also, "fuser -m /dev/sdi5" and the same for sdj5 reports no users of the filesystems.

Stopping /dev/md5,6,7,8 and rerunning mdadm -A command, shows that mdadm also thinks that /dev/sdi6,7,8 and /dev/sdj6,7,8 are busy as well, even though they are not being used in any other RAID.  

What does this mean?

I am grasping at straws here. It seems that mdadm thinks that two of the devices are "busy", even though Linux apparently disagrees, and no I/O errors are being reported. I am mystified.

After googling, I did find one suggestion - remove dmraid from the system. I will try that and report the result. I am not sure why dmraid is installed - I never explicitly installed it. I see that I have

dmraid-events-1.0.0.rc16-12.fc13.i686
dmraid-1.0.0.rc16-12.fc13.i686

Thanks!

Jim


1st try
-----------------

mdadm -A --verbose --no-degraded /dev/md5 --uuid 291655c3:b6c334ff:8dfe69a4:447f777b
mdadm: looking for devices for /dev/md5
mdadm: no recogniseable superblock on /dev/dm-6
mdadm: /dev/dm-6 has wrong uuid.
mdadm: no recogniseable superblock on /dev/dm-5
mdadm: /dev/dm-5 has wrong uuid.
mdadm: cannot open device /dev/dm-4: Device or resource busy
mdadm: /dev/dm-4 has wrong uuid.
mdadm: cannot open device /dev/dm-3: Device or resource busy
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: /dev/dm-1 has wrong uuid.
mdadm: cannot open device /dev/md1: Device or resource busy
mdadm: /dev/md1 has wrong uuid.
mdadm: cannot open device /dev/md2: Device or resource busy
mdadm: /dev/md2 has wrong uuid.
mdadm: cannot open device /dev/md3: Device or resource busy
mdadm: /dev/md3 has wrong uuid.
mdadm: cannot open device /dev/md0: Device or resource busy
mdadm: /dev/md0 has wrong uuid.
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: /dev/dm-0 has wrong uuid.
mdadm: cannot open device /dev/sdm7: Device or resource busy
mdadm: /dev/sdm7 has wrong uuid.
mdadm: cannot open device /dev/sdm6: Device or resource busy
mdadm: /dev/sdm6 has wrong uuid.
mdadm: cannot open device /dev/sdm5: Device or resource busy
mdadm: /dev/sdm5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdm1
mdadm: /dev/sdm1 has wrong uuid.
mdadm: cannot open device /dev/sdm: Device or resource busy
mdadm: /dev/sdm has wrong uuid.
mdadm: cannot open device /dev/sdp7: Device or resource busy
mdadm: /dev/sdp7 has wrong uuid.
mdadm: cannot open device /dev/sdp6: Device or resource busy
mdadm: /dev/sdp6 has wrong uuid.
mdadm: cannot open device /dev/sdp5: Device or resource busy
mdadm: /dev/sdp5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdp1
mdadm: /dev/sdp1 has wrong uuid.
mdadm: cannot open device /dev/sdp: Device or resource busy
mdadm: /dev/sdp has wrong uuid.
mdadm: cannot open device /dev/sdo7: Device or resource busy
mdadm: /dev/sdo7 has wrong uuid.
mdadm: cannot open device /dev/sdo6: Device or resource busy
mdadm: /dev/sdo6 has wrong uuid.
mdadm: cannot open device /dev/sdo5: Device or resource busy
mdadm: /dev/sdo5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdo1
mdadm: /dev/sdo1 has wrong uuid.
mdadm: cannot open device /dev/sdo: Device or resource busy
mdadm: /dev/sdo has wrong uuid.
mdadm: cannot open device /dev/sdn7: Device or resource busy
mdadm: /dev/sdn7 has wrong uuid.
mdadm: cannot open device /dev/sdn6: Device or resource busy
mdadm: /dev/sdn6 has wrong uuid.
mdadm: cannot open device /dev/sdn5: Device or resource busy
mdadm: /dev/sdn5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdn1
mdadm: /dev/sdn1 has wrong uuid.
mdadm: cannot open device /dev/sdn: Device or resource busy
mdadm: /dev/sdn has wrong uuid.
mdadm: cannot open device /dev/sdi8: Device or resource busy
mdadm: /dev/sdi8 has wrong uuid.
mdadm: cannot open device /dev/sdi7: Device or resource busy
mdadm: /dev/sdi7 has wrong uuid.
mdadm: cannot open device /dev/sdi6: Device or resource busy
mdadm: /dev/sdi6 has wrong uuid.
mdadm: cannot open device /dev/sdi5: Device or resource busy
mdadm: /dev/sdi5 has wrong uuid.
mdadm: cannot open device /dev/sdi2: Device or resource busy
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: cannot open device /dev/sdl: Device or resource busy
mdadm: /dev/sdl has wrong uuid.
mdadm: cannot open device /dev/sdk8: Device or resource busy
mdadm: /dev/sdk8 has wrong uuid.
mdadm: cannot open device /dev/sdk7: Device or resource busy
mdadm: /dev/sdk7 has wrong uuid.
mdadm: cannot open device /dev/sdk6: Device or resource busy
mdadm: /dev/sdk6 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk2
mdadm: /dev/sdk2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk1
mdadm: /dev/sdk1 has wrong uuid.
mdadm: cannot open device /dev/sdk: Device or resource busy
mdadm: /dev/sdk has wrong uuid.
mdadm: cannot open device /dev/sdj8: Device or resource busy
mdadm: /dev/sdj8 has wrong uuid.
mdadm: cannot open device /dev/sdj7: Device or resource busy
mdadm: /dev/sdj7 has wrong uuid.
mdadm: cannot open device /dev/sdj6: Device or resource busy
mdadm: /dev/sdj6 has wrong uuid.
mdadm: cannot open device /dev/sdj5: Device or resource busy
mdadm: /dev/sdj5 has wrong uuid.
mdadm: cannot open device /dev/sdj2: Device or resource busy
mdadm: /dev/sdj2 has wrong uuid.
mdadm: cannot open device /dev/sdj1: Device or resource busy
mdadm: /dev/sdj1 has wrong uuid.
mdadm: cannot open device /dev/sdj: Device or resource busy
mdadm: /dev/sdj has wrong uuid.
mdadm: cannot open device /dev/sdh3: Device or resource busy
mdadm: /dev/sdh3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh2
mdadm: /dev/sdh2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh1
mdadm: /dev/sdh1 has wrong uuid.
mdadm: cannot open device /dev/sdh: Device or resource busy
mdadm: /dev/sdh has wrong uuid.
mdadm: cannot open device /dev/sdf3: Device or resource busy
mdadm: /dev/sdf3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf2
mdadm: /dev/sdf2 has wrong uuid.
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sdg3: Device or resource busy
mdadm: /dev/sdg3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg2
mdadm: /dev/sdg2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: /dev/sdg has wrong uuid.
mdadm: cannot open device /dev/sdb7: Device or resource busy
mdadm: /dev/sdb7 has wrong uuid.
mdadm: cannot open device /dev/sdb6: Device or resource busy
mdadm: /dev/sdb6 has wrong uuid.
mdadm: cannot open device /dev/sdb5: Device or resource busy
mdadm: /dev/sdb5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sde7: Device or resource busy
mdadm: /dev/sde7 has wrong uuid.
mdadm: cannot open device /dev/sde6: Device or resource busy
mdadm: /dev/sde6 has wrong uuid.
mdadm: cannot open device /dev/sde5: Device or resource busy
mdadm: /dev/sde5 has wrong uuid.
mdadm: no RAID superblock on /dev/sde1
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: cannot open device /dev/sdd7: Device or resource busy
mdadm: /dev/sdd7 has wrong uuid.
mdadm: cannot open device /dev/sdd6: Device or resource busy
mdadm: /dev/sdd6 has wrong uuid.
mdadm: cannot open device /dev/sdd5: Device or resource busy
mdadm: /dev/sdd5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd1
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sda8: Device or resource busy
mdadm: /dev/sda8 has wrong uuid.
mdadm: cannot open device /dev/sda7: Device or resource busy
mdadm: /dev/sda7 has wrong uuid.
mdadm: cannot open device /dev/sda6: Device or resource busy
mdadm: /dev/sda6 has wrong uuid.
mdadm: no RAID superblock on /dev/sda2
mdadm: /dev/sda2 has wrong uuid.
mdadm: no RAID superblock on /dev/sda1
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdk5 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sda5 is identified as a member of /dev/md5, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md5
mdadm: no uptodate device for slot 2 of /dev/md5
mdadm: added /dev/sdk5 to /dev/md5 as 3
mdadm: added /dev/sda5 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 2 drives (out of 4), but not started.


Stopping /dev/md5,6,7,8 first
------------------------------------------

mdadm -A --verbose --no-degraded /dev/md5 --uuid 291655c3:b6c334ff:8dfe69a4:447f777b
mdadm: looking for devices for /dev/md5
mdadm: no recogniseable superblock on /dev/dm-6
mdadm: /dev/dm-6 has wrong uuid.
mdadm: no recogniseable superblock on /dev/dm-5
mdadm: /dev/dm-5 has wrong uuid.
mdadm: cannot open device /dev/dm-4: Device or resource busy
mdadm: /dev/dm-4 has wrong uuid.
mdadm: cannot open device /dev/dm-3: Device or resource busy
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: /dev/dm-1 has wrong uuid.
mdadm: cannot open device /dev/md1: Device or resource busy
mdadm: /dev/md1 has wrong uuid.
mdadm: cannot open device /dev/md2: Device or resource busy
mdadm: /dev/md2 has wrong uuid.
mdadm: cannot open device /dev/md3: Device or resource busy
mdadm: /dev/md3 has wrong uuid.
mdadm: cannot open device /dev/md0: Device or resource busy
mdadm: /dev/md0 has wrong uuid.
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: /dev/dm-0 has wrong uuid.
mdadm: cannot open device /dev/sdm7: Device or resource busy
mdadm: /dev/sdm7 has wrong uuid.
mdadm: cannot open device /dev/sdm6: Device or resource busy
mdadm: /dev/sdm6 has wrong uuid.
mdadm: cannot open device /dev/sdm5: Device or resource busy
mdadm: /dev/sdm5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdm1
mdadm: /dev/sdm1 has wrong uuid.
mdadm: cannot open device /dev/sdm: Device or resource busy
mdadm: /dev/sdm has wrong uuid.
mdadm: cannot open device /dev/sdp7: Device or resource busy
mdadm: /dev/sdp7 has wrong uuid.
mdadm: cannot open device /dev/sdp6: Device or resource busy
mdadm: /dev/sdp6 has wrong uuid.
mdadm: cannot open device /dev/sdp5: Device or resource busy
mdadm: /dev/sdp5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdp1
mdadm: /dev/sdp1 has wrong uuid.
mdadm: cannot open device /dev/sdp: Device or resource busy
mdadm: /dev/sdp has wrong uuid.
mdadm: cannot open device /dev/sdo7: Device or resource busy
mdadm: /dev/sdo7 has wrong uuid.
mdadm: cannot open device /dev/sdo6: Device or resource busy
mdadm: /dev/sdo6 has wrong uuid.
mdadm: cannot open device /dev/sdo5: Device or resource busy
mdadm: /dev/sdo5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdo1
mdadm: /dev/sdo1 has wrong uuid.
mdadm: cannot open device /dev/sdo: Device or resource busy
mdadm: /dev/sdo has wrong uuid.
mdadm: cannot open device /dev/sdn7: Device or resource busy
mdadm: /dev/sdn7 has wrong uuid.
mdadm: cannot open device /dev/sdn6: Device or resource busy
mdadm: /dev/sdn6 has wrong uuid.
mdadm: cannot open device /dev/sdn5: Device or resource busy
mdadm: /dev/sdn5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdn1
mdadm: /dev/sdn1 has wrong uuid.
mdadm: cannot open device /dev/sdn: Device or resource busy
mdadm: /dev/sdn has wrong uuid.
mdadm: cannot open device /dev/sdi8: Device or resource busy
mdadm: /dev/sdi8 has wrong uuid.
mdadm: cannot open device /dev/sdi7: Device or resource busy
mdadm: /dev/sdi7 has wrong uuid.
mdadm: cannot open device /dev/sdi6: Device or resource busy
mdadm: /dev/sdi6 has wrong uuid.
mdadm: cannot open device /dev/sdi5: Device or resource busy
mdadm: /dev/sdi5 has wrong uuid.
mdadm: cannot open device /dev/sdi2: Device or resource busy
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: cannot open device /dev/sdl: Device or resource busy
mdadm: /dev/sdl has wrong uuid.
mdadm: /dev/sdk8 has wrong uuid.
mdadm: /dev/sdk7 has wrong uuid.
mdadm: /dev/sdk6 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk2
mdadm: /dev/sdk2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk1
mdadm: /dev/sdk1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk
mdadm: /dev/sdk has wrong uuid.
mdadm: cannot open device /dev/sdj8: Device or resource busy
mdadm: /dev/sdj8 has wrong uuid.
mdadm: cannot open device /dev/sdj7: Device or resource busy
mdadm: /dev/sdj7 has wrong uuid.
mdadm: cannot open device /dev/sdj6: Device or resource busy
mdadm: /dev/sdj6 has wrong uuid.
mdadm: cannot open device /dev/sdj5: Device or resource busy
mdadm: /dev/sdj5 has wrong uuid.
mdadm: cannot open device /dev/sdj2: Device or resource busy
mdadm: /dev/sdj2 has wrong uuid.
mdadm: cannot open device /dev/sdj1: Device or resource busy
mdadm: /dev/sdj1 has wrong uuid.
mdadm: cannot open device /dev/sdj: Device or resource busy
mdadm: /dev/sdj has wrong uuid.
mdadm: cannot open device /dev/sdh3: Device or resource busy
mdadm: /dev/sdh3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh2
mdadm: /dev/sdh2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh1
mdadm: /dev/sdh1 has wrong uuid.
mdadm: cannot open device /dev/sdh: Device or resource busy
mdadm: /dev/sdh has wrong uuid.
mdadm: cannot open device /dev/sdf3: Device or resource busy
mdadm: /dev/sdf3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf2
mdadm: /dev/sdf2 has wrong uuid.
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sdg3: Device or resource busy
mdadm: /dev/sdg3 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg2
mdadm: /dev/sdg2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: /dev/sdg has wrong uuid.
mdadm: cannot open device /dev/sdb7: Device or resource busy
mdadm: /dev/sdb7 has wrong uuid.
mdadm: cannot open device /dev/sdb6: Device or resource busy
mdadm: /dev/sdb6 has wrong uuid.
mdadm: cannot open device /dev/sdb5: Device or resource busy
mdadm: /dev/sdb5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sde7: Device or resource busy
mdadm: /dev/sde7 has wrong uuid.
mdadm: cannot open device /dev/sde6: Device or resource busy
mdadm: /dev/sde6 has wrong uuid.
mdadm: cannot open device /dev/sde5: Device or resource busy
mdadm: /dev/sde5 has wrong uuid.
mdadm: no RAID superblock on /dev/sde1
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: cannot open device /dev/sdd7: Device or resource busy
mdadm: /dev/sdd7 has wrong uuid.
mdadm: cannot open device /dev/sdd6: Device or resource busy
mdadm: /dev/sdd6 has wrong uuid.
mdadm: cannot open device /dev/sdd5: Device or resource busy
mdadm: /dev/sdd5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd1
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc7: Device or resource busy
mdadm: /dev/sdc7 has wrong uuid.
mdadm: cannot open device /dev/sdc6: Device or resource busy
mdadm: /dev/sdc6 has wrong uuid.
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: /dev/sdc5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sda8 has wrong uuid.
mdadm: /dev/sda7 has wrong uuid.
mdadm: /dev/sda6 has wrong uuid.
mdadm: no RAID superblock on /dev/sda2
mdadm: /dev/sda2 has wrong uuid.
mdadm: no RAID superblock on /dev/sda1
mdadm: /dev/sda1 has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdk5 is identified as a member of /dev/md5, slot 3.
mdadm: /dev/sda5 is identified as a member of /dev/md5, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md5
mdadm: no uptodate device for slot 2 of /dev/md5
mdadm: added /dev/sdk5 to /dev/md5 as 3
mdadm: added /dev/sda5 to /dev/md5 as 0
mdadm: /dev/md5 assembled from 2 drives (out of 4), but not started.




At 06:08 PM 12/30/2010, Neil Brown wrote:
>On Thu, 30 Dec 2010 16:20:58 -0700 Jim Schatzman
><james.schatzman@futurelabusa.com> wrote:
>
>> When I rebooted my server yesterday, not all the RAIDs came up. There were no errors in the system log. All devices appear to be working correctly. There is no evidence of  hardware errors or data corruption.
>> 
>> To prevent mdadm from failing RAID drives, I removed the RAID entries from /etc/mdadm.conf, and I have a cron script that does things like
>> 
>> mdadm -A --no-degraded /dev/md5 --uuid 291655c3:b6c334ff:8dfe69a4:447f777b
>> mdadm: /dev/md5 assembled from 2 drives (out of 4), but not started.
>> 
>> The question is, why did mdadm assemble only 2 drives, when all 4 drives appear to be fine?  The same problem occurred for 4 RAIDs, each with similar geometry, and using the same 4 physical drives.
>
>Add a '--verbose' to the '-A' command.  Hopefully it will reveal something
>interesting.
>
>NeilBrown
>

