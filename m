From: "Sandra Escandor" <sescandor@evertz.com>
Subject: Resolving mdadm built RAID issue
Date: Fri, 8 Jul 2011 14:07:04 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD8CB1E@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to help someone out in the field with some RAID issues, and
I'm a bit stuck. The situation is that our server has an ftp server
storing data onto a RAID10. There was an Ethernet connection loss (looks
like it was during an ftp transfer) and then the RAID experienced a
failure. From the looks of the dmesg output below, I suspect that it
could be a member disk failure (perhaps they need to get a new member
disk?). But, even still, this shouldn't cause the RAID to become
completely unusable, since RAID10 should provide redundancy - a resync
would start automatically once a new disk is inserted, correct? 

Can anyone provide some light onto what the dmesg output could mean?

Thanks,
Sandra

Some system info:
mdadm 3.1.4
Linux kernel 2.6.32-5-amd64
RAID10 (intel imsm container)

Snippet of dmesg:

Jul  7 14:49:40 ecs-1u kernel: [ 4479.396658] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396662] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396667] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 7c 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396675] end_request: I/O error,
dev sde, sector 1236499584
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396707] raid10: Disk failure on
sde, disabling device.
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396709] raid10: Operation
continuing on 3 devices.
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396796] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396798] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396800] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 a4 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396805] end_request: I/O error,
dev sde, sector 1236509824
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396936] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396938] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396940] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 a8 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.396946] end_request: I/O error,
dev sde, sector 1236510848
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397063] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397064] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397066] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 ac 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397070] end_request: I/O error,
dev sde, sector 1236511872
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397171] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397172] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397174] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 b0 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397177] end_request: I/O error,
dev sde, sector 1236512896
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397280] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397281] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397283] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 b4 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397286] end_request: I/O error,
dev sde, sector 1236513920
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397389] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397390] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397392] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 b8 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397396] end_request: I/O error,
dev sde, sector 1236514944
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397504] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397505] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397507] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 bc 80 00 04 00 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397510] end_request: I/O error,
dev sde, sector 1236515968
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397611] sd 4:0:0:0: [sde]
Unhandled error code
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397612] sd 4:0:0:0: [sde] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397614] sd 4:0:0:0: [sde] CDB:
Write(10): 2a 00 49 b3 c0 80 00 03 80 00
Jul  7 14:49:40 ecs-1u kernel: [ 4479.397617] end_request: I/O error,
dev sde, sector 1236516992
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461228] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461231] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461234] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461243] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461246] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.461248] md: md126: recovery done.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597908] RAID10 conf printout:
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597911]  --- wd:3 rd:4
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597914]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597916]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597918]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:41 ecs-1u kernel: [ 4480.597920]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598155] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598159] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598162] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598169] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598171] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.598174] md: md126: recovery done.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731082] RAID10 conf printout:
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731084]  --- wd:3 rd:4
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731086]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731087]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731089]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731091]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731309] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731313] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731317] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731327] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731330] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.731333] md: md126: recovery done.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867425] RAID10 conf printout:
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867429]  --- wd:3 rd:4
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867433]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867436]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867439]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867442]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867604] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867611] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867614] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867621] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867623] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4480.867625] md: md126: recovery done.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000526] RAID10 conf printout:
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000528]  --- wd:3 rd:4
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000530]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000532]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000533]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000534]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000712] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000716] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000720] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000727] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000730] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.000732] md: md126: recovery done.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136554] RAID10 conf printout:
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136558]  --- wd:3 rd:4
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136561]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136565]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136568]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136570]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136758] md: recovery of RAID array
md126
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136762] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136766] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136773] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136776] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:41 ecs-1u kernel: [ 4481.136778] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272465] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272469]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272473]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272476]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272479]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272482]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272634] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272641] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272644] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272651] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272654] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.272656] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405433] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405435]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405437]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405439]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405440]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405441]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405702] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405705] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405708] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405715] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405718] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.405720] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541360] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541364]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541367]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541369]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541371]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541374]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541546] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541548] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541550] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541554] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541555] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.541556] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677110] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677114]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677118]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677121]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677124]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677126]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677274] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677276] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677277] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677281] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677282] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.677283] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811859] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811863]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811866]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811868]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811870]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811873]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811979] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811981] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811982] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811986] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811987] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.811988] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944831] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944832]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944834]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944835]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944836]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944837]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944965] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944967] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944968] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944972] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944973] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4481.944974] md: md126: recovery done.
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079035] RAID10 conf printout:
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079038]  --- wd:3 rd:4
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079041]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079043]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079046]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079048]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079224] md: recovery of RAID array
md126
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079228] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079230] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079237] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079251] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:42 ecs-1u kernel: [ 4482.079254] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213760] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213764]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213766]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213769]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213771]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213774]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213884] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213885] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213887] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213890] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213892] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.213893] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346704] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346708]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346711]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346713]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346716]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346718]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346916] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346920] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346922] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346929] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346932] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.346934] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481054] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481057]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481060]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481063]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481065]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481067]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481257] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481261] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481263] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481271] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481273] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.481274] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615623] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615627]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615629]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615632]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615634]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615636]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615713] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615717] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615719] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615726] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615729] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.615731] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748473] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748476]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748479]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748482]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748484]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748486]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748668] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748671] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748674] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748681] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748683] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.748685] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883229] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883233]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883236]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883241]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883242]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883243]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883436] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883440] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883443] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883450] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883452] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4482.883454] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017787] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017791]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017795]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017798]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017802]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017804]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017955] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017958] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017962] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017970] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017972] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.017975] md: md126: recovery done.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150936] RAID10 conf printout:
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150940]  --- wd:3 rd:4
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150943]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150946]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150949]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:43 ecs-1u kernel: [ 4483.150951]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151172] md: recovery of RAID array
md126
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151176] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151179] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151187] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151189] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:43 ecs-1u kernel: [ 4483.151191] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284018] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284022]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284026]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284029]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284032]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284035]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284230] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284232] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284238] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284245] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284248] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.284250] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417019] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417023]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417027]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417030]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417033]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417035]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417260] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417265] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417268] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417275] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417278] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.417280] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550229] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550233]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550236]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550239]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550243]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550245]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550457] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550461] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550463] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550470] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550473] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.550475] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683361] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683363]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683365]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683367]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683368]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683370]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683532] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683534] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683535] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683547] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683548] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.683550] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816429] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816432]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816435]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816438]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816440]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816442]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816542] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816543] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816545] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816551] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816552] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.816554] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950371] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950376]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950380]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950382]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950384]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950387]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950503] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950506] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950508] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950516] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950518] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4483.950519] md: md126: recovery done.
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083284] RAID10 conf printout:
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083287]  --- wd:3 rd:4
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083289]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083290]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083292]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083293]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083509] md: recovery of RAID array
md126
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083511] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083512] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083516] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083518] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:44 ecs-1u kernel: [ 4484.083519] md: md126: recovery done.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216526] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216531]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216535]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216537]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216539]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216542]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216643] md: recovery of RAID array
md126
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216646] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216649] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216660] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216661] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.216662] md: md126: recovery done.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349375] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349378]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349380]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349381]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349383]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349384]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349566] md: recovery of RAID array
md126
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349568] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349570] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349576] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349578] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.349579] md: md126: recovery done.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482545] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482549]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482551]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482554]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482556]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482558]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482753] md: recovery of RAID array
md126
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482755] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482757] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482762] md: using 128k window,
over a total of 732572288 blocks.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482764] md: resuming recovery of
md126 from checkpoint.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.482766] md: md126: recovery done.
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615633] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615637]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615640]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615642]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615644]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615646]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615665] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615667]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615669]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615671]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615673]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.615675]  disk 3, wo:1, o:0,
dev:sde
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676891] RAID10 conf printout:
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676894]  --- wd:3 rd:4
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676898]  disk 0, wo:0, o:1,
dev:sdb
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676900]  disk 1, wo:0, o:1,
dev:sdc
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676902]  disk 2, wo:0, o:1,
dev:sdd
Jul  7 14:49:45 ecs-1u kernel: [ 4484.676955] md: unbind<sde>
Jul  7 14:49:45 ecs-1u kernel: [ 4484.712368] md: export_rdev(sde)

