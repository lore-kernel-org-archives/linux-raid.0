From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 08:58:18 +0100
Message-ID: <20120711075818.GA30527@nsrc.org>
References: <20120710163345.GB29855@nsrc.org>
 <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
 <4FFC68AB.4010801@profitbricks.com> <20120710185927.GA30164@nsrc.org>
 <20120711124316.206ab3d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120711124316.206ab3d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 11, 2012 at 12:43:16PM +1000, NeilBrown wrote:
> As others have suggested, there is probably some hardware problem somewhere.
> It looks like sdr failed first, around "Jul  3 04:21:50 2012".
> The array continued working until about 06:36 when sdu then sds failed.
> Since then it doesn't look like much if anything has been written to the
> array - but I cannot be completely certain.

Good spotting, how did you work that out from `mdadm --examine` output? I
see 8 drives in state "clean" and four in state "active".  Three have update
times on Jul 3, two on Jul 7, the rest on Jul 10.  I couldn't see anything
which obviously jumps out as "FAULTY".

You're right that the system has been not doing any writes recently.

> Do you have kernel logs from the morning of 3rd July?

Logs at end of mail. It looks like sde failed, then a few seconds later
reattached itself as sdn - and a couple of hours later more things started
to fail (looks like sdh failed and reattached as sdo, and a minute later sdf
failed and reattached as sdp).  Very odd that these devices should fail so
close together, maybe a power glitch?  After that even more drives
apparently started to fail.

SMART shows 7 drives have reported at least one uncorrectable error:

root@dev-storage1:~# for i in /dev/sd?; do smartctl -A $i | grep -i correct; done
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   092   092   000    Old_age   Always       -       8
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   098   098   000    Old_age   Always       -       2
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   099   099   000    Old_age   Always       -       1
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   095   095   000    Old_age   Always       -       5
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   092   092   000    Old_age   Always       -       8
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   098   098   000    Old_age   Always       -       2
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
187 Reported_Uncorrect      0x0032   093   093   000    Old_age   Always       -       7
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0

And three have very high seek error rates:

root@dev-storage1:~# for i in /dev/sd?; do smartctl -A $i | grep -i seek_error; done
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2233869
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2231308
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2199098
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2250443
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2220215
  7 Seek_Error_Rate         0x000f   060   059   030    Pre-fail  Always       -       8592064174
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2238212
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       4297171738
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2170378
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2253934
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       2192100
  7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always       -       4297224551

BTW these are all Seagate ST3000DM001. Yes, I know :-(

So this doesn't look good. Having a go at reassembly anyway:

root@dev-storage1:~# mdadm -S /dev/md127
mdadm: stopped /dev/md127
root@dev-storage1:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
unused devices: <none>
root@dev-storage1:~# ls /dev/sd*
/dev/sda   /dev/sda5  /dev/sde  /dev/sdj  /dev/sdn  /dev/sdq
/dev/sda1  /dev/sdb   /dev/sdf  /dev/sdk  /dev/sdo
/dev/sda2  /dev/sdc   /dev/sdi  /dev/sdl  /dev/sdp
root@dev-storage1:~# mdadm --assemble --force /dev/md/storage1 /dev/sd{b,c,e,f,i,j,k,l,n,o,p,q}
mdadm: forcing event count in /dev/sdc(2) from 29355 upto 29374
mdadm: forcing event count in /dev/sdn(3) from 29352 upto 29374
mdadm: forcing event count in /dev/sdq(5) from 29312 upto 29374
mdadm: forcing event count in /dev/sdo(4) from 29272 upto 29374
mdadm: forcing event count in /dev/sdp(1) from 20228 upto 29374
mdadm: clearing FAULTY flag for device 10 in /dev/md/storage1 for /dev/sdp
mdadm: clearing FAULTY flag for device 8 in /dev/md/storage1 for /dev/sdn
mdadm: clearing FAULTY flag for device 9 in /dev/md/storage1 for /dev/sdo
mdadm: Marking array /dev/md/storage1 as 'clean'
mdadm: /dev/md/storage1 assembled from 12 drives - not enough to start the array.
root@dev-storage1:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : inactive sdb[0](S) sdl[11](S) sdk[10](S) sdj[9](S) sdi[8](S) sde[7](S) sdf[6](S) sdq[5](S) sdo[4](S) sdn[3](S) sdc[2](S) sdp[1](S)
      35163186720 blocks super 1.2

unused devices: <none>

> Don't try to --create --assume-clean, it isn't needed.
...
> When you re-assemble it won't include all the devices in the array - just
> enough to make the array functional.  You would then need to add the others
> back in if you trust them.

I am guessing that it's not starting the array because devices 8 and 9 were
both marked as failed, which are two halves of the same pair.

This is a test system but I will exchange at least the three drives with the
high seek error rates.

One final point. I would like to be able to monitor for suspect or failed
drives.  Is my best bet to look at /proc/mdstat output and identify drives
which have been kicked out of the array?  Or to monitor SMART variables (in
that case though I need to decide which ones are the most important to
monitor, and what thresholds to set)?

It would be really useful if the kernel itself kept some per-drive counters
for I/O failures, but if it does, I can't find them.
http://www.kernel.org/doc/Documentation/block/stat.txt

Regards,

Brian.
       

Jul  3 04:22:33 dev-storage1 kernel: [50147.362942] sd 4:0:3:0: [sde] Synchronizing SCSI cache
Jul  3 04:22:33 dev-storage1 kernel: [50147.364646] end_request: I/O error, dev sde, sector 8
Jul  3 04:22:33 dev-storage1 kernel: [50147.364656] md: super_written gets error=-5, uptodate=0
Jul  3 04:22:33 dev-storage1 kernel: [50147.364663] md/raid10:md127: Disk failure on sde, disabling device.
Jul  3 04:22:33 dev-storage1 kernel: [50147.364665] md/raid10:md127: Operation continuing on 11 devices.
Jul  3 04:22:33 dev-storage1 kernel: [50147.364710] sd 4:0:3:0: [sde]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 04:22:33 dev-storage1 kernel: [50147.364881] mpt2sas0: removing handle(0x000c), sas_addr(0x4433221100000000)
Jul  3 04:22:34 dev-storage1 kernel: [50147.437339] RAID10 conf printout:
Jul  3 04:22:34 dev-storage1 kernel: [50147.437344]  --- wd:11 rd:12
Jul  3 04:22:34 dev-storage1 kernel: [50147.437347]  disk 0, wo:0, o:1, dev:sdb
Jul  3 04:22:34 dev-storage1 kernel: [50147.437350]  disk 1, wo:1, o:0, dev:sde
Jul  3 04:22:34 dev-storage1 kernel: [50147.437352]  disk 2, wo:0, o:1, dev:sdc
Jul  3 04:22:34 dev-storage1 kernel: [50147.437354]  disk 3, wo:0, o:1, dev:sdd
Jul  3 04:22:34 dev-storage1 kernel: [50147.437357]  disk 4, wo:0, o:1, dev:sdh
Jul  3 04:22:34 dev-storage1 kernel: [50147.437359]  disk 5, wo:0, o:1, dev:sdf
Jul  3 04:22:34 dev-storage1 kernel: [50147.437361]  disk 6, wo:0, o:1, dev:sdi
Jul  3 04:22:34 dev-storage1 kernel: [50147.437363]  disk 7, wo:0, o:1, dev:sdg
Jul  3 04:22:34 dev-storage1 kernel: [50147.437366]  disk 8, wo:0, o:1, dev:sdj
Jul  3 04:22:34 dev-storage1 kernel: [50147.437368]  disk 9, wo:0, o:1, dev:sdk
Jul  3 04:22:34 dev-storage1 kernel: [50147.437370]  disk 10, wo:0, o:1, dev:sdl
Jul  3 04:22:34 dev-storage1 kernel: [50147.437372]  disk 11, wo:0, o:1, dev:sdm
Jul  3 04:22:34 dev-storage1 kernel: [50147.437429] RAID10 conf printout:
Jul  3 04:22:34 dev-storage1 kernel: [50147.437434]  --- wd:11 rd:12
Jul  3 04:22:34 dev-storage1 kernel: [50147.437437]  disk 0, wo:0, o:1, dev:sdb
Jul  3 04:22:34 dev-storage1 kernel: [50147.437439]  disk 2, wo:0, o:1, dev:sdc
Jul  3 04:22:34 dev-storage1 kernel: [50147.437441]  disk 3, wo:0, o:1, dev:sdd
Jul  3 04:22:34 dev-storage1 kernel: [50147.437444]  disk 4, wo:0, o:1, dev:sdh
Jul  3 04:22:34 dev-storage1 kernel: [50147.437446]  disk 5, wo:0, o:1, dev:sdf
Jul  3 04:22:34 dev-storage1 kernel: [50147.437448]  disk 6, wo:0, o:1, dev:sdi
Jul  3 04:22:34 dev-storage1 kernel: [50147.437450]  disk 7, wo:0, o:1, dev:sdg
Jul  3 04:22:34 dev-storage1 kernel: [50147.437452]  disk 8, wo:0, o:1, dev:sdj
Jul  3 04:22:34 dev-storage1 kernel: [50147.437454]  disk 9, wo:0, o:1, dev:sdk
Jul  3 04:22:34 dev-storage1 kernel: [50147.437457]  disk 10, wo:0, o:1, dev:sdl
Jul  3 04:22:34 dev-storage1 kernel: [50147.437459]  disk 11, wo:0, o:1, dev:sdm
Jul  3 04:22:47 dev-storage1 kernel: [50161.168292] scsi 4:0:8:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  3 04:22:47 dev-storage1 kernel: [50161.168302] scsi 4:0:8:0: SATA: handle(0x000c), sas_addr(0x4433221100000000), phy(0), device_name(0x5000c5004a37a3ae)
Jul  3 04:22:47 dev-storage1 kernel: [50161.168307] scsi 4:0:8:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(3)
Jul  3 04:22:47 dev-storage1 kernel: [50161.168457] scsi 4:0:8:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  3 04:22:47 dev-storage1 kernel: [50161.168465] scsi 4:0:8:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  3 04:22:47 dev-storage1 kernel: [50161.168686] sd 4:0:8:0: Attached scsi generic sg4 type 0
Jul  3 04:22:47 dev-storage1 kernel: [50161.170776] sd 4:0:8:0: [sdn] physical block alignment offset: 4096
Jul  3 04:22:47 dev-storage1 kernel: [50161.170783] sd 4:0:8:0: [sdn] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  3 04:22:47 dev-storage1 kernel: [50161.170786] sd 4:0:8:0: [sdn] 4096-byte physical blocks
Jul  3 04:22:47 dev-storage1 kernel: [50161.233278] sd 4:0:8:0: [sdn] Write Protect is off
Jul  3 04:22:47 dev-storage1 kernel: [50161.233283] sd 4:0:8:0: [sdn] Mode Sense: 7f 00 00 08
Jul  3 04:22:47 dev-storage1 kernel: [50161.233981] sd 4:0:8:0: [sdn] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  3 04:22:47 dev-storage1 kernel: [50161.325272]  sdn: unknown partition table
Jul  3 04:22:47 dev-storage1 kernel: [50161.392086] sd 4:0:8:0: [sdn] Attached SCSI disk


Jul  3 06:37:00 dev-storage1 kernel: [58191.291518] sd 4:0:6:0: [sdh] Synchronizing SCSI cache
Jul  3 06:37:00 dev-storage1 kernel: [58191.291586] sd 4:0:6:0: [sdh]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 06:37:00 dev-storage1 kernel: [58191.291975] md: super_written gets error=-19, uptodate=0
Jul  3 06:37:00 dev-storage1 kernel: [58191.291982] md/raid10:md127: Disk failure on sdh, disabling device.
Jul  3 06:37:00 dev-storage1 kernel: [58191.291985] md/raid10:md127: Operation continuing on 10 devices.
Jul  3 06:37:00 dev-storage1 kernel: [58191.292675] mpt2sas0: removing handle(0x000f), sas_addr(0x4433221105000000)
Jul  3 06:37:00 dev-storage1 kernel: [58191.363950] RAID10 conf printout:
Jul  3 06:37:00 dev-storage1 kernel: [58191.363955]  --- wd:10 rd:12
Jul  3 06:37:00 dev-storage1 kernel: [58191.363958]  disk 0, wo:0, o:1, dev:sdb
Jul  3 06:37:00 dev-storage1 kernel: [58191.363961]  disk 2, wo:0, o:1, dev:sdc
Jul  3 06:37:00 dev-storage1 kernel: [58191.363963]  disk 3, wo:0, o:1, dev:sdd
Jul  3 06:37:00 dev-storage1 kernel: [58191.363965]  disk 4, wo:1, o:0, dev:sdh
Jul  3 06:37:00 dev-storage1 kernel: [58191.363967]  disk 5, wo:0, o:1, dev:sdf
Jul  3 06:37:00 dev-storage1 kernel: [58191.363970]  disk 6, wo:0, o:1, dev:sdi
Jul  3 06:37:00 dev-storage1 kernel: [58191.363972]  disk 7, wo:0, o:1, dev:sdg
Jul  3 06:37:00 dev-storage1 kernel: [58191.363974]  disk 8, wo:0, o:1, dev:sdj
Jul  3 06:37:00 dev-storage1 kernel: [58191.363976]  disk 9, wo:0, o:1, dev:sdk
Jul  3 06:37:00 dev-storage1 kernel: [58191.363979]  disk 10, wo:0, o:1, dev:sdl
Jul  3 06:37:00 dev-storage1 kernel: [58191.363981]  disk 11, wo:0, o:1, dev:sdm
Jul  3 06:37:00 dev-storage1 kernel: [58191.364014] RAID10 conf printout:
Jul  3 06:37:00 dev-storage1 kernel: [58191.364018]  --- wd:10 rd:12
Jul  3 06:37:00 dev-storage1 kernel: [58191.364021]  disk 0, wo:0, o:1, dev:sdb
Jul  3 06:37:00 dev-storage1 kernel: [58191.364024]  disk 2, wo:0, o:1, dev:sdc
Jul  3 06:37:00 dev-storage1 kernel: [58191.364026]  disk 3, wo:0, o:1, dev:sdd
Jul  3 06:37:00 dev-storage1 kernel: [58191.364028]  disk 5, wo:0, o:1, dev:sdf
Jul  3 06:37:00 dev-storage1 kernel: [58191.364030]  disk 6, wo:0, o:1, dev:sdi
Jul  3 06:37:00 dev-storage1 kernel: [58191.364033]  disk 7, wo:0, o:1, dev:sdg
Jul  3 06:37:00 dev-storage1 kernel: [58191.364035]  disk 8, wo:0, o:1, dev:sdj
Jul  3 06:37:00 dev-storage1 kernel: [58191.364037]  disk 9, wo:0, o:1, dev:sdk
Jul  3 06:37:00 dev-storage1 kernel: [58191.364039]  disk 10, wo:0, o:1, dev:sdl
Jul  3 06:37:00 dev-storage1 kernel: [58191.364041]  disk 11, wo:0, o:1, dev:sdm
Jul  3 06:37:14 dev-storage1 kernel: [58204.853102] scsi 4:0:9:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  3 06:37:14 dev-storage1 kernel: [58204.853112] scsi 4:0:9:0: SATA: handle(0x000f), sas_addr(0x4433221105000000), phy(5), device_name(0x5000c5004a44edbe)
Jul  3 06:37:14 dev-storage1 kernel: [58204.853116] scsi 4:0:9:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(6)
Jul  3 06:37:14 dev-storage1 kernel: [58204.853292] scsi 4:0:9:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  3 06:37:14 dev-storage1 kernel: [58204.853299] scsi 4:0:9:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  3 06:37:14 dev-storage1 kernel: [58204.853491] sd 4:0:9:0: Attached scsi generic sg7 type 0
Jul  3 06:37:14 dev-storage1 kernel: [58204.853882] sd 4:0:9:0: [sdo] physical block alignment offset: 4096
Jul  3 06:37:14 dev-storage1 kernel: [58204.853892] sd 4:0:9:0: [sdo] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  3 06:37:14 dev-storage1 kernel: [58204.853897] sd 4:0:9:0: [sdo] 4096-byte physical blocks
Jul  3 06:37:14 dev-storage1 kernel: [58204.920533] sd 4:0:9:0: [sdo] Write Protect is off
Jul  3 06:37:14 dev-storage1 kernel: [58204.920539] sd 4:0:9:0: [sdo] Mode Sense: 7f 00 00 08
Jul  3 06:37:14 dev-storage1 kernel: [58204.949593] sd 4:0:9:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  3 06:37:14 dev-storage1 kernel: [58205.077376]  sdo: unknown partition table
Jul  3 06:37:14 dev-storage1 kernel: [58205.145744] sd 4:0:9:0: [sdo] Attached SCSI disk
Jul  3 06:38:15 dev-storage1 kernel: [58266.076919] sd 4:0:4:0: [sdf] Synchronizing SCSI cache
Jul  3 06:38:15 dev-storage1 kernel: [58266.077767] sd 4:0:4:0: [sdf]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  3 06:38:15 dev-storage1 kernel: [58266.078218] mpt2sas0: removing handle(0x000d), sas_addr(0x4433221104000000)
Jul  3 06:38:15 dev-storage1 kernel: [58266.078681] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:16 dev-storage1 kernel: [58266.356847] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:16 dev-storage1 kernel: [58266.381809] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:18 dev-storage1 kernel: [58268.351226] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:18 dev-storage1 kernel: [58268.381174] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:18 dev-storage1 kernel: [58268.606432] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:18 dev-storage1 kernel: [58268.643731] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:20 dev-storage1 kernel: [58270.676566] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:20 dev-storage1 kernel: [58270.727079] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:20 dev-storage1 kernel: [58270.951730] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:20 dev-storage1 kernel: [58270.986091] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:22 dev-storage1 kernel: [58273.021826] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:22 dev-storage1 kernel: [58273.100664] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:22 dev-storage1 kernel: [58273.122092] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:23 dev-storage1 kernel: [58273.324949] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:23 dev-storage1 kernel: [58273.351418] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:24 dev-storage1 kernel: [58274.318169] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:24 dev-storage1 kernel: [58274.351982] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:24 dev-storage1 kernel: [58274.609269] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:24 dev-storage1 kernel: [58274.636725] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:29 dev-storage1 kernel: [58279.573103] scsi 4:0:10:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  3 06:38:29 dev-storage1 kernel: [58279.573113] scsi 4:0:10:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c5004a123b93)
Jul  3 06:38:29 dev-storage1 kernel: [58279.573117] scsi 4:0:10:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(7)
Jul  3 06:38:29 dev-storage1 kernel: [58279.573252] scsi 4:0:10:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  3 06:38:29 dev-storage1 kernel: [58279.573257] scsi 4:0:10:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  3 06:38:29 dev-storage1 kernel: [58279.573450] sd 4:0:10:0: Attached scsi generic sg5 type 0
Jul  3 06:38:29 dev-storage1 kernel: [58279.573754] sd 4:0:10:0: [sdp] physical block alignment offset: 4096
Jul  3 06:38:29 dev-storage1 kernel: [58279.573764] sd 4:0:10:0: [sdp] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  3 06:38:29 dev-storage1 kernel: [58279.573768] sd 4:0:10:0: [sdp] 4096-byte physical blocks
Jul  3 06:38:29 dev-storage1 kernel: [58279.626371] sd 4:0:10:0: [sdp] Write Protect is off
Jul  3 06:38:29 dev-storage1 kernel: [58279.626376] sd 4:0:10:0: [sdp] Mode Sense: 7f 00 00 08
Jul  3 06:38:29 dev-storage1 kernel: [58279.627052] sd 4:0:10:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  3 06:38:29 dev-storage1 kernel: [58279.722780]  sdp: unknown partition table
Jul  3 06:38:29 dev-storage1 kernel: [58279.785171] sd 4:0:10:0: [sdp] Attached SCSI disk
Jul  3 06:38:45 dev-storage1 kernel: [58296.071974] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:45 dev-storage1 kernel: [58296.104706] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:45 dev-storage1 kernel: [58296.125410] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:46 dev-storage1 kernel: [58296.347134] md: super_written gets error=-19, uptodate=0
Jul  3 06:38:46 dev-storage1 kernel: [58296.373160] md: super_written gets error=-19, uptodate=0
Jul  3 14:00:27 dev-storage1 kernel: [84721.683301] md: super_written gets error=-19, uptodate=0
Jul  3 14:00:27 dev-storage1 kernel: [84721.717956] md: super_written gets error=-19, uptodate=0
Jul  3 14:00:27 dev-storage1 kernel: [84721.974395] md: super_written gets error=-19, uptodate=0
Jul  3 14:00:27 dev-storage1 kernel: [84721.997145] md: super_written gets error=-19, uptodate=0
Jul  3 14:01:01 dev-storage1 kernel: [84755.610249] md: super_written gets error=-19, uptodate=0
Jul  3 14:01:01 dev-storage1 kernel: [84755.652918] md: super_written gets error=-19, uptodate=0
Jul  3 14:01:01 dev-storage1 kernel: [84755.673944] md: super_written gets error=-19, uptodate=0
Jul  3 14:01:01 dev-storage1 kernel: [84755.694312] quiet_error: 24 callbacks suppressed
Jul  3 14:01:01 dev-storage1 kernel: [84755.694318] Buffer I/O error on device md127, logical block 2067791905
Jul  3 14:01:01 dev-storage1 kernel: [84755.694326] lost page write due to I/O error on md127
Jul  3 14:01:01 dev-storage1 kernel: [84755.897413] md: super_written gets error=-19, uptodate=0
Jul  3 14:01:01 dev-storage1 kernel: [84755.918495] md: super_written gets error=-19, uptodate=0
Jul  4 14:00:34 dev-storage1 kernel: [170882.380831] md: super_written gets error=-19, uptodate=0
Jul  4 14:00:34 dev-storage1 kernel: [170882.415605] md: super_written gets error=-19, uptodate=0
Jul  4 14:00:34 dev-storage1 kernel: [170882.671923] md: super_written gets error=-19, uptodate=0
Jul  4 14:00:34 dev-storage1 kernel: [170882.694429] md: super_written gets error=-19, uptodate=0
Jul  4 14:01:08 dev-storage1 kernel: [170916.387597] md: super_written gets error=-19, uptodate=0
Jul  4 14:01:08 dev-storage1 kernel: [170916.423033] md: super_written gets error=-19, uptodate=0
Jul  4 14:01:08 dev-storage1 kernel: [170916.444517] Buffer I/O error on device md127, logical block 2067791905
Jul  4 14:01:08 dev-storage1 kernel: [170916.444524] lost page write due to I/O error on md127
Jul  4 14:01:08 dev-storage1 kernel: [170916.646795] md: super_written gets error=-19, uptodate=0
Jul  4 14:01:08 dev-storage1 kernel: [170916.667910] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:07 dev-storage1 kernel: [229786.969375] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:07 dev-storage1 kernel: [229787.001133] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:07 dev-storage1 kernel: [229787.264457] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:07 dev-storage1 kernel: [229787.284359] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:41 dev-storage1 kernel: [229821.534543] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:41 dev-storage1 kernel: [229821.568091] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:42 dev-storage1 kernel: [229821.793719] md: super_written gets error=-19, uptodate=0
Jul  5 06:25:42 dev-storage1 kernel: [229821.821779] md: super_written gets error=-19, uptodate=0
Jul  5 14:00:41 dev-storage1 kernel: [257043.062362] md: super_written gets error=-19, uptodate=0
Jul  5 14:00:41 dev-storage1 kernel: [257043.096332] md: super_written gets error=-19, uptodate=0
Jul  5 14:00:41 dev-storage1 kernel: [257043.353502] md: super_written gets error=-19, uptodate=0
Jul  5 14:00:41 dev-storage1 kernel: [257043.372982] md: super_written gets error=-19, uptodate=0
Jul  5 14:01:15 dev-storage1 kernel: [257077.148922] md: super_written gets error=-19, uptodate=0
Jul  5 14:01:15 dev-storage1 kernel: [257077.183874] md: super_written gets error=-19, uptodate=0
Jul  5 14:01:15 dev-storage1 kernel: [257077.205482] Buffer I/O error on device md127, logical block 2067791905
Jul  5 14:01:15 dev-storage1 kernel: [257077.205491] lost page write due to I/O error on md127
Jul  5 14:01:15 dev-storage1 kernel: [257077.408139] md: super_written gets error=-19, uptodate=0
Jul  5 14:01:15 dev-storage1 kernel: [257077.430487] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:08 dev-storage1 kernel: [315941.667994] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:08 dev-storage1 kernel: [315941.701458] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:08 dev-storage1 kernel: [315941.959147] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:08 dev-storage1 kernel: [315941.980677] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:42 dev-storage1 kernel: [315975.882227] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:42 dev-storage1 kernel: [315975.911833] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:42 dev-storage1 kernel: [315976.141403] md: super_written gets error=-19, uptodate=0
Jul  6 06:25:42 dev-storage1 kernel: [315976.169041] md: super_written gets error=-19, uptodate=0
Jul  6 14:00:48 dev-storage1 kernel: [343203.728029] md: super_written gets error=-19, uptodate=0
Jul  6 14:00:48 dev-storage1 kernel: [343203.761823] md: super_written gets error=-19, uptodate=0
Jul  6 14:00:48 dev-storage1 kernel: [343204.019107] md: super_written gets error=-19, uptodate=0
Jul  6 14:00:48 dev-storage1 kernel: [343204.041347] md: super_written gets error=-19, uptodate=0
Jul  6 14:01:22 dev-storage1 kernel: [343238.117700] md: super_written gets error=-19, uptodate=0
Jul  6 14:01:22 dev-storage1 kernel: [343238.153053] md: super_written gets error=-19, uptodate=0
Jul  6 14:01:22 dev-storage1 kernel: [343238.173113] Buffer I/O error on device md127, logical block 2067791905
Jul  6 14:01:22 dev-storage1 kernel: [343238.173123] lost page write due to I/O error on md127
Jul  6 14:01:22 dev-storage1 kernel: [343238.372889] md: super_written gets error=-19, uptodate=0
Jul  6 14:01:22 dev-storage1 kernel: [343238.393954] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:07 dev-storage1 kernel: [402094.372432] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:07 dev-storage1 kernel: [402094.405765] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:07 dev-storage1 kernel: [402094.655548] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:07 dev-storage1 kernel: [402094.676942] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:42 dev-storage1 kernel: [402129.208784] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:42 dev-storage1 kernel: [402129.244327] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:42 dev-storage1 kernel: [402129.467991] md: super_written gets error=-19, uptodate=0
Jul  7 06:25:42 dev-storage1 kernel: [402129.491687] md: super_written gets error=-19, uptodate=0
Jul  7 14:00:55 dev-storage1 kernel: [429364.393602] md: super_written gets error=-19, uptodate=0
Jul  7 14:00:55 dev-storage1 kernel: [429364.443065] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.619062] sd 4:0:2:0: [sdd] Synchronizing SCSI cache
Jul  7 14:01:37 dev-storage1 kernel: [429406.619127] sd 4:0:2:0: [sdd]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  7 14:01:37 dev-storage1 kernel: [429406.619415] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221102000000)
Jul  7 14:01:37 dev-storage1 kernel: [429406.860149] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.860155] md/raid10:md127: Disk failure on sdd, disabling device.
Jul  7 14:01:37 dev-storage1 kernel: [429406.860157] md/raid10:md127: Operation continuing on 9 devices.
Jul  7 14:01:37 dev-storage1 kernel: [429406.860177] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.888238] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.909143] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.930558] md: super_written gets error=-19, uptodate=0
Jul  7 14:01:37 dev-storage1 kernel: [429406.951439] RAID10 conf printout:
Jul  7 14:01:37 dev-storage1 kernel: [429406.951443]  --- wd:9 rd:12
Jul  7 14:01:37 dev-storage1 kernel: [429406.951446]  disk 0, wo:0, o:1, dev:sdb
Jul  7 14:01:37 dev-storage1 kernel: [429406.951449]  disk 2, wo:0, o:1, dev:sdc
Jul  7 14:01:37 dev-storage1 kernel: [429406.951451]  disk 3, wo:1, o:0, dev:sdd
Jul  7 14:01:37 dev-storage1 kernel: [429406.951453]  disk 5, wo:0, o:1, dev:sdf
Jul  7 14:01:37 dev-storage1 kernel: [429406.951456]  disk 6, wo:0, o:1, dev:sdi
Jul  7 14:01:37 dev-storage1 kernel: [429406.951458]  disk 7, wo:0, o:1, dev:sdg
Jul  7 14:01:37 dev-storage1 kernel: [429406.951460]  disk 8, wo:0, o:1, dev:sdj
Jul  7 14:01:37 dev-storage1 kernel: [429406.951462]  disk 9, wo:0, o:1, dev:sdk
Jul  7 14:01:37 dev-storage1 kernel: [429406.951465]  disk 10, wo:0, o:1, dev:sdl
Jul  7 14:01:37 dev-storage1 kernel: [429406.951467]  disk 11, wo:0, o:1, dev:sdm
Jul  7 14:01:37 dev-storage1 kernel: [429406.951527] RAID10 conf printout:
Jul  7 14:01:37 dev-storage1 kernel: [429406.951532]  --- wd:9 rd:12
Jul  7 14:01:37 dev-storage1 kernel: [429406.951535]  disk 0, wo:0, o:1, dev:sdb
Jul  7 14:01:37 dev-storage1 kernel: [429406.951537]  disk 2, wo:0, o:1, dev:sdc
Jul  7 14:01:37 dev-storage1 kernel: [429406.951540]  disk 5, wo:0, o:1, dev:sdf
Jul  7 14:01:37 dev-storage1 kernel: [429406.951542]  disk 6, wo:0, o:1, dev:sdi
Jul  7 14:01:37 dev-storage1 kernel: [429406.951544]  disk 7, wo:0, o:1, dev:sdg
Jul  7 14:01:37 dev-storage1 kernel: [429406.951546]  disk 8, wo:0, o:1, dev:sdj
Jul  7 14:01:37 dev-storage1 kernel: [429406.951549]  disk 9, wo:0, o:1, dev:sdk
Jul  7 14:01:37 dev-storage1 kernel: [429406.951551]  disk 10, wo:0, o:1, dev:sdl
Jul  7 14:01:37 dev-storage1 kernel: [429406.951553]  disk 11, wo:0, o:1, dev:sdm
Jul  7 14:01:51 dev-storage1 kernel: [429420.898133] scsi 4:0:11:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  7 14:01:51 dev-storage1 kernel: [429420.898143] scsi 4:0:11:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x5000c5004a44f42a)
Jul  7 14:01:51 dev-storage1 kernel: [429420.898147] scsi 4:0:11:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(1)
Jul  7 14:01:51 dev-storage1 kernel: [429420.898290] scsi 4:0:11:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  7 14:01:51 dev-storage1 kernel: [429420.898297] scsi 4:0:11:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  7 14:01:51 dev-storage1 kernel: [429420.898514] sd 4:0:11:0: Attached scsi generic sg3 type 0
Jul  7 14:01:51 dev-storage1 kernel: [429420.898858] sd 4:0:11:0: [sdq] physical block alignment offset: 4096
Jul  7 14:01:51 dev-storage1 kernel: [429420.898867] sd 4:0:11:0: [sdq] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  7 14:01:51 dev-storage1 kernel: [429420.898872] sd 4:0:11:0: [sdq] 4096-byte physical blocks
Jul  7 14:01:51 dev-storage1 kernel: [429420.957177] sd 4:0:11:0: [sdq] Write Protect is off
Jul  7 14:01:51 dev-storage1 kernel: [429420.957183] sd 4:0:11:0: [sdq] Mode Sense: 7f 00 00 08
Jul  7 14:01:51 dev-storage1 kernel: [429420.957882] sd 4:0:11:0: [sdq] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  7 14:01:51 dev-storage1 kernel: [429421.030777]  sdq: unknown partition table
Jul  7 14:01:51 dev-storage1 kernel: [429421.099310] sd 4:0:11:0: [sdq] Attached SCSI disk
Jul  7 14:02:07 dev-storage1 kernel: [429436.579265] md: super_written gets error=-19, uptodate=0
Jul  7 14:02:07 dev-storage1 kernel: [429436.612518] md: super_written gets error=-19, uptodate=0
Jul  7 14:02:50 dev-storage1 kernel: [429479.409214] sd 4:0:1:0: [sdc] Synchronizing SCSI cache
Jul  7 14:02:50 dev-storage1 kernel: [429479.409290] sd 4:0:1:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  7 14:02:50 dev-storage1 kernel: [429479.409297] Buffer I/O error on device md127, logical block 2067791905
Jul  7 14:02:50 dev-storage1 kernel: [429479.409300] lost page write due to I/O error on md127
Jul  7 14:02:50 dev-storage1 kernel: [429479.409502] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221101000000)
Jul  7 14:02:50 dev-storage1 kernel: [429479.612173] md: super_written gets error=-19, uptodate=0
Jul  7 14:02:50 dev-storage1 kernel: [429479.612192] md: super_written gets error=-19, uptodate=0
Jul  7 14:02:50 dev-storage1 kernel: [429479.639212] md: super_written gets error=-19, uptodate=0
Jul  7 14:02:50 dev-storage1 kernel: [429479.639222] md: super_written gets error=-19, uptodate=0
Jul  7 14:03:04 dev-storage1 kernel: [429493.162396] scsi 4:0:12:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  7 14:03:04 dev-storage1 kernel: [429493.162407] scsi 4:0:12:0: SATA: handle(0x0009), sas_addr(0x4433221101000000), phy(1), device_name(0x5000c5004a46ceca)
Jul  7 14:03:04 dev-storage1 kernel: [429493.162411] scsi 4:0:12:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(2)
Jul  7 14:03:04 dev-storage1 kernel: [429493.162518] scsi 4:0:12:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  7 14:03:04 dev-storage1 kernel: [429493.162526] scsi 4:0:12:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  7 14:03:04 dev-storage1 kernel: [429493.162782] sd 4:0:12:0: Attached scsi generic sg2 type 0
Jul  7 14:03:04 dev-storage1 kernel: [429493.163136] sd 4:0:12:0: [sdr] physical block alignment offset: 4096
Jul  7 14:03:04 dev-storage1 kernel: [429493.163143] sd 4:0:12:0: [sdr] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  7 14:03:04 dev-storage1 kernel: [429493.163146] sd 4:0:12:0: [sdr] 4096-byte physical blocks
Jul  7 14:03:04 dev-storage1 kernel: [429493.217763] sd 4:0:12:0: [sdr] Write Protect is off
Jul  7 14:03:04 dev-storage1 kernel: [429493.217768] sd 4:0:12:0: [sdr] Mode Sense: 7f 00 00 08
Jul  7 14:03:04 dev-storage1 kernel: [429493.218501] sd 4:0:12:0: [sdr] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  7 14:03:04 dev-storage1 kernel: [429493.289491]  sdr: unknown partition table
Jul  7 14:03:04 dev-storage1 kernel: [429493.351632] sd 4:0:12:0: [sdr] Attached SCSI disk
Jul  7 15:38:20 dev-storage1 kernel: [435193.023742] sd 4:0:10:0: [sdp] Synchronizing SCSI cache
Jul  7 15:38:20 dev-storage1 kernel: [435193.023794] sd 4:0:10:0: [sdp]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  7 15:38:20 dev-storage1 kernel: [435193.024209] mpt2sas0: removing handle(0x000d), sas_addr(0x4433221104000000)
Jul  7 15:38:29 dev-storage1 kernel: [435202.541557] scsi 4:0:13:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  7 15:38:29 dev-storage1 kernel: [435202.541567] scsi 4:0:13:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c5004a123b93)
Jul  7 15:38:29 dev-storage1 kernel: [435202.541571] scsi 4:0:13:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(7)
Jul  7 15:38:29 dev-storage1 kernel: [435202.541693] scsi 4:0:13:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  7 15:38:29 dev-storage1 kernel: [435202.541699] scsi 4:0:13:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  7 15:38:29 dev-storage1 kernel: [435202.541978] sd 4:0:13:0: Attached scsi generic sg5 type 0
Jul  7 15:38:29 dev-storage1 kernel: [435202.542230] sd 4:0:13:0: [sdp] physical block alignment offset: 4096
Jul  7 15:38:29 dev-storage1 kernel: [435202.542240] sd 4:0:13:0: [sdp] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  7 15:38:29 dev-storage1 kernel: [435202.542245] sd 4:0:13:0: [sdp] 4096-byte physical blocks
Jul  7 15:38:30 dev-storage1 kernel: [435202.594827] sd 4:0:13:0: [sdp] Write Protect is off
Jul  7 15:38:30 dev-storage1 kernel: [435202.594832] sd 4:0:13:0: [sdp] Mode Sense: 7f 00 00 08
Jul  7 15:38:30 dev-storage1 kernel: [435202.595551] sd 4:0:13:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  7 15:38:30 dev-storage1 kernel: [435202.666733]  sdp: unknown partition table
Jul  7 15:38:30 dev-storage1 kernel: [435202.728676] sd 4:0:13:0: [sdp] Attached SCSI disk
Jul  7 15:48:21 dev-storage1 kernel: [435792.305634] sd 4:0:13:0: [sdp] Synchronizing SCSI cache
Jul  7 15:48:21 dev-storage1 kernel: [435792.305685] sd 4:0:13:0: [sdp]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  7 15:48:21 dev-storage1 kernel: [435792.305961] mpt2sas0: removing handle(0x000d), sas_addr(0x4433221104000000)
Jul  7 15:48:21 dev-storage1 kernel: [435792.307158] sd 4:0:9:0: [sdo] Synchronizing SCSI cache
Jul  7 15:48:21 dev-storage1 kernel: [435792.307201] sd 4:0:9:0: [sdo]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  7 15:48:21 dev-storage1 kernel: [435792.307477] mpt2sas0: removing handle(0x000f), sas_addr(0x4433221105000000)
Jul  7 15:48:30 dev-storage1 kernel: [435801.077761] scsi 4:0:14:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  7 15:48:30 dev-storage1 kernel: [435801.077773] scsi 4:0:14:0: SATA: handle(0x000f), sas_addr(0x4433221105000000), phy(5), device_name(0x5000c5004a44edbe)
Jul  7 15:48:30 dev-storage1 kernel: [435801.077780] scsi 4:0:14:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(6)
Jul  7 15:48:30 dev-storage1 kernel: [435801.077876] scsi 4:0:14:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  7 15:48:30 dev-storage1 kernel: [435801.077884] scsi 4:0:14:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  7 15:48:30 dev-storage1 kernel: [435801.078164] sd 4:0:14:0: Attached scsi generic sg5 type 0
Jul  7 15:48:30 dev-storage1 kernel: [435801.078467] sd 4:0:14:0: [sdo] physical block alignment offset: 4096
Jul  7 15:48:30 dev-storage1 kernel: [435801.078476] sd 4:0:14:0: [sdo] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  7 15:48:30 dev-storage1 kernel: [435801.078481] sd 4:0:14:0: [sdo] 4096-byte physical blocks
Jul  7 15:48:30 dev-storage1 kernel: [435801.134074] sd 4:0:14:0: [sdo] Write Protect is off
Jul  7 15:48:30 dev-storage1 kernel: [435801.134079] sd 4:0:14:0: [sdo] Mode Sense: 7f 00 00 08
Jul  7 15:48:30 dev-storage1 kernel: [435801.134786] sd 4:0:14:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  7 15:48:30 dev-storage1 kernel: [435801.208179]  sdo: unknown partition table
Jul  7 15:48:30 dev-storage1 kernel: [435801.276258] sd 4:0:14:0: [sdo] Attached SCSI disk
Jul  7 15:48:30 dev-storage1 kernel: [435801.822171] scsi 4:0:15:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4C PQ: 0 ANSI: 6
Jul  7 15:48:30 dev-storage1 kernel: [435801.822180] scsi 4:0:15:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c5004a123b93)
Jul  7 15:48:30 dev-storage1 kernel: [435801.822185] scsi 4:0:15:0: SATA: enclosure_logical_id(0x500605b00448c4f0), slot(7)
Jul  7 15:48:30 dev-storage1 kernel: [435801.822272] scsi 4:0:15:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jul  7 15:48:30 dev-storage1 kernel: [435801.822279] scsi 4:0:15:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
Jul  7 15:48:30 dev-storage1 kernel: [435801.822589] sd 4:0:15:0: Attached scsi generic sg7 type 0
Jul  7 15:48:30 dev-storage1 kernel: [435801.822886] sd 4:0:15:0: [sdp] physical block alignment offset: 4096
Jul  7 15:48:30 dev-storage1 kernel: [435801.822896] sd 4:0:15:0: [sdp] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jul  7 15:48:30 dev-storage1 kernel: [435801.822900] sd 4:0:15:0: [sdp] 4096-byte physical blocks
Jul  7 15:48:30 dev-storage1 kernel: [435801.875888] sd 4:0:15:0: [sdp] Write Protect is off
Jul  7 15:48:30 dev-storage1 kernel: [435801.875893] sd 4:0:15:0: [sdp] Mode Sense: 7f 00 00 08
Jul  7 15:48:30 dev-storage1 kernel: [435801.876484] sd 4:0:15:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  7 15:48:31 dev-storage1 kernel: [435801.947660]  sdp: unknown partition table
Jul  7 15:48:31 dev-storage1 kernel: [435802.009745] sd 4:0:15:0: [sdp] Attached SCSI disk
Jul  7 15:49:14 dev-storage1 kernel: [435845.153305] sd 4:0:14:0: [sdo] Synchronizing SCSI cache
Jul  7 15:49:14 dev-storage1 kernel: [435845.153356] sd 4:0:14:0: [sdo]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
... snip rest ...
