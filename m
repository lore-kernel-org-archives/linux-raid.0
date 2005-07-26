From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Failed RAID-5 with 4 disks
Date: Tue, 26 Jul 2005 19:03:29 +0200
Message-ID: <20050726170329.GA30354@intoxicatedmind.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID-5 set up with the following raidtab:

raiddev /dev/md0
        raid-level              5
        nr-raid-disks           4
        nr-spare-disks          0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size              256
        device                  /dev/hde
        raid-disk               0
        device                  /dev/hdg
        raid-disk               1
        device                  /dev/hdi
        raid-disk               2
        device                  /dev/hdk
        raid-disk               3

My hde has failed some time ago, leaving some 
	hde: dma_intr: status=0x51 { DriveReady SeekComplete Error }
	hde: dma_intr: error=0x84 { DriveStatusError BadCRC }
messages in the syslog.

I wanted to get sure it really was damaged, so I did a badblocks
(read-only) scan on /dev/hde. It actually found a bad sector on the
disk.


I wanted to take the disk out to get me a new one, but unfortunately my
hdg seems to have run into trouble too, now. I also have some
SeekComplete/BadCRC errors in my log for that disk, too.

Furthermore, i got this:

Jul 25 10:35:49 blackbox kernel: ide: failed opcode was: unknown
Jul 25 10:35:49 blackbox kernel: hdg: DMA disabled
Jul 25 10:35:49 blackbox kernel: PDC202XX: Secondary channel reset.
Jul 25 10:35:49 blackbox kernel: PDC202XX: Primary channel reset.
Jul 25 10:35:49 blackbox kernel: hde: lost interrupt
Jul 25 10:35:49 blackbox kernel: ide3: reset: master: error (0x00?)
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 488396928
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159368976
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159368984
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159368992
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159369000
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159369008
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159369016
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159369024
Jul 25 10:35:49 blackbox kernel: end_request: I/O error, dev hdg, sector 159369032
Jul 25 10:35:49 blackbox kernel: md: write_disk_sb failed for device hdg
Jul 25 10:35:49 blackbox kernel: lost page write due to I/O error on md0
Jul 25 10:35:49 blackbox kernel: lost page write due to I/O error on md0
Jul 25 10:35:49 blackbox kernel: RAID5 conf printout:
Jul 25 10:35:49 blackbox kernel:  --- rd:4 wd:2 fd:2
Jul 25 10:35:49 blackbox kernel:  disk 0, o:1, dev:hdk
Jul 25 10:35:49 blackbox kernel:  disk 1, o:1, dev:hdi
Jul 25 10:35:49 blackbox kernel:  disk 2, o:0, dev:hdg
Jul 25 10:35:49 blackbox kernel: RAID5 conf printout:
Jul 25 10:35:49 blackbox kernel:  --- rd:4 wd:2 fd:2
Jul 25 10:35:49 blackbox kernel:  disk 0, o:1, dev:hdk
Jul 25 10:35:49 blackbox kernel:  disk 1, o:1, dev:hdi
Jul 25 10:35:49 blackbox kernel: lost page write due to I/O error on md0


Well, now it seems I have to failed disks in my RAID-5, which of course
would be fatal. I am still hoping to somehow rescue the data on the
array somehow, but I am not sure what would be the best approach. I don't
want to cause any more damage.

When booting my system with all four disks connected, hde and hdg as
expected won't get added:

Jul 26 18:07:59 blackbox kernel: md: hdg has invalid sb, not importing!
Jul 26 18:07:59 blackbox kernel: md: autorun ...
Jul 26 18:07:59 blackbox kernel: md: considering hdi ...
Jul 26 18:07:59 blackbox kernel: md:  adding hdi ...
Jul 26 18:07:59 blackbox kernel: md:  adding hdk ...
Jul 26 18:07:59 blackbox kernel: md:  adding hde ...
Jul 26 18:07:59 blackbox kernel: md: created md0
Jul 26 18:07:59 blackbox kernel: md: bind<hde>
Jul 26 18:07:59 blackbox kernel: md: bind<hdk>
Jul 26 18:07:59 blackbox kernel: md: bind<hdi>
Jul 26 18:07:59 blackbox kernel: md: running: <hdi><hdk><hde>
Jul 26 18:07:59 blackbox kernel: md: kicking non-fresh hde from array!
Jul 26 18:07:59 blackbox kernel: md: unbind<hde>
Jul 26 18:07:59 blackbox kernel: md: export_rdev(hde)
Jul 26 18:07:59 blackbox kernel: raid5: device hdi operational as raid disk 1
Jul 26 18:07:59 blackbox kernel: raid5: device hdk operational as raid disk 0
Jul 26 18:07:59 blackbox kernel: RAID5 conf printout:
Jul 26 18:07:59 blackbox kernel:  --- rd:4 wd:2 fd:2
Jul 26 18:07:59 blackbox kernel:  disk 0, o:1, dev:hdk
Jul 26 18:07:59 blackbox kernel:  disk 1, o:1, dev:hdi
Jul 26 18:07:59 blackbox kernel: md: do_md_run() returned -22
Jul 26 18:07:59 blackbox kernel: md: md0 stopped.
Jul 26 18:07:59 blackbox kernel: md: unbind<hdi>
Jul 26 18:07:59 blackbox kernel: md: export_rdev(hdi)
Jul 26 18:07:59 blackbox kernel: md: unbind<hdk>
Jul 26 18:07:59 blackbox kernel: md: export_rdev(hdk)
Jul 26 18:07:59 blackbox kernel: md: ... autorun DONE.

So hde is not fresh (it has been removed from the array for quite some
time now) and hdg has an invalid superblock.

Any advice on what I should do now? Should I better try to rebuild the
array with hde or with hdg?


Greetings,
Frank
