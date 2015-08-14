From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: Problems with Seagate 8TB SMR archive drives
Date: Fri, 14 Aug 2015 11:22:06 -0700
Message-ID: <55CE31CE.8080100@aeoncomputing.com>
References: <55CE2ACA.50203@bnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55CE2ACA.50203@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tejas,

You are probably running firmware AR13 or older. The drives are designed 
for very power efficient archive use and they have a very aggressive 
spin down timer. Once they drop to a slower speed or stopped it will 
take a significant time to get back up to ready. I would highly suggest 
updating to code AR14 or AR15.

The drives aren't really intended for your use model. Perhaps a cron job 
that does a dd read (direct mode) of a hundred MBs or so from the md 
device to dev/null every couple minutes might be enough to keep them 
warm and not spun down.

--Jeff


On 8/14/15 10:52 AM, Tejas Rao wrote:
> I am aware that the Seagate SMR 8tb archive drives are not meant to be 
> used in a RAID environment as they lack TLER/ERC support.
>
> We are trying to use these drives with mdraid and are seeing problems. 
> It seems that after writing to these drives for few hours, 
> occasionally some drives stop responding for few minutes and recover 
> on its own later. (This was expected).
>
> I have increased the device timeouts to 480 seconds now 
> (sys/block/<device>/device/timeout). The md device is assembled on top 
> of dm-multipath devices and dm-multipath is configured to retry 50 
> times (no_path_retry=50). I have also changed queue_depth for each 
> device to 1 (NCQ disabled).
>
> Usually when I see retries and a drive stops responding, it recovers 
> on its own after few minutes and the md layer does not fail the disk. 
> Occasionally though, the md layer fails the disk after ~15 seconds or 
> so of the drive becoming non-responsive. See below.
>
> sdlm and sdfb are the same disk (mpathaw, dm-231,dm-226). Why does the 
> md layer not wait for 480 seconds before failing the disk. As you can 
> see the drive recovered after ~ 8 minutes but the md layer failed it 
> after ~15 seconds.
>
> What other tunables can I tune to avoid kicking a drive out early.
>
> Aug 14 13:01:12 dc045 kernel: mpt2sas3: log_info(0x31120303): 
> originator(PL), code(0x12), sub_code(0x0303)
> Aug 14 13:01:12 dc045 kernel: mpt2sas3: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:01:12 dc045 kernel: mpt2sas1: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:05:24 dc045 kernel: mpt2sas3: log_info(0x31120303): 
> originator(PL), code(0x12), sub_code(0x0303)
> Aug 14 13:05:24 dc045 kernel: mpt2sas3: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:05:24 dc045 kernel: mpt2sas1: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:12:19 dc045 kernel: mpt2sas3: log_info(0x31120303): 
> originator(PL), code(0x12), sub_code(0x0303)
> Aug 14 13:12:19 dc045 kernel: mpt2sas3: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:12:19 dc045 kernel: mpt2sas1: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:12:35 dc045 kernel: __ratelimit: 2 callbacks suppressed
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Write(10): 2a 
> 00 55 6a 5e c8 00 00 b8 00
> Aug 14 13:12:35 dc045 kernel: __ratelimit: 14 callbacks suppressed
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] CDB: Write(10): 2a 
> 00 55 6a 5f 80 00 00 10 00
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Write(10): 2a 
> 00 55 6a 5f 90 00 03 38 00
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] CDB: Read(16): 88 
> 00 00 00 00 01 d5 59 50 a8 00 00 00 08 00 00
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Read(16): 88 
> 00 00 00 00 01 d5 59 50 b0 00 00 00 80 00 00
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] CDB: Read(10): 28 
> 00 55 6a 78 00 00 00 50 00
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 7874367664
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 1433040896
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 25:0:42:0: [sdfb] CDB: Write(10): 2a 
> 00 00 00 08 08 00 00 01 00
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdfb, sector 2056
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Read(10): 28 
> 00 55 6a 7b e0 00 00 20 00
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdlm, sector 1433041888
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 1433041888
> Aug 14 13:12:35 dc045 kernel: mpt2sas1: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Read(10): 28 
> 00 00 00 00 00 00 00 08 00
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdlm, sector 0
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 2056
> Aug 14 13:12:35 dc045 kernel: md: super_written gets error=-121, 
> uptodate=0
> Aug 14 13:12:35 dc045 kernel: md/raid:md8: Disk failure on dm-231, 
> disabling device.
> Aug 14 13:12:35 dc045 kernel: md/raid:md8: Operation continuing on 13 
> devices.
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Unhandled sense code
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Result: 
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] Sense Key : 
> Hardware Error [current]
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] <<vendor>> ASC=0x81 
> ASCQ=0x0ASC=0x81 ASCQ=0x0
> Aug 14 13:12:35 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Write(10): 2a 
> 00 55 6a 62 c8 00 04 00 00
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdlm, sector 1433035464
> Aug 14 13:12:35 dc045 kernel: mpt2sas3: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 1433035464
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdfb, sector 1433036488
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 1433036488
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdlm, sector 1433037512
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 1433037512
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> sdfb, sector 2128
> Aug 14 13:12:35 dc045 kernel: end_request: critical target error, dev 
> dm-226, sector 2128
> Aug 14 13:12:35 dc045 kernel: md: super_written gets error=-121, 
> uptodate=0
> Aug 14 13:12:36 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:12:36 dc045 multipathd: checker failed path 68:320 in map 
> mpathaw
> Aug 14 13:12:36 dc045 multipathd: mpathaw: remaining active paths: 1
> Aug 14 13:12:36 dc045 kernel: device-mapper: multipath: Failing path 
> 68:320.
> Aug 14 13:13:17 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:13:25 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:13:25 dc045 multipathd: checker failed path 129:208 in map 
> mpathaw
> Aug 14 13:13:25 dc045 multipathd: mpathaw: Entering recovery mode: 
> max_retries=50
> Aug 14 13:13:25 dc045 multipathd: mpathaw: remaining active paths: 0
> Aug 14 13:13:25 dc045 kernel: device-mapper: multipath: Failing path 
> 129:208.
> Aug 14 13:13:25 dc045 multipathd: mpathaw: Entering recovery mode: 
> max_retries=50
> Aug 14 13:13:27 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:13:35 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:13:37 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:13:45 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:13:47 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:13:55 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:13:57 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:05 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:07 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:15 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:17 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:25 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:27 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:35 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:37 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:46 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:48 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:14:56 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:14:58 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:06 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:08 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:16 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:18 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:26 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:28 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:36 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:38 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:46 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:48 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:15:56 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:15:58 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:06 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:08 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:16 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:18 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:26 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:28 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:37 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:39 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:47 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:49 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:16:57 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:16:59 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:07 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:09 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:17 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:19 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:27 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:29 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:37 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:39 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:47 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:49 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:17:57 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:17:59 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:07 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:18:09 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:17 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:18:19 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:28 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:18:30 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:38 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:18:40 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:48 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:18:50 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:18:58 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:00 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:08 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:10 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:18 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:20 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:28 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:30 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:38 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:40 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:48 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:19:50 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:19:58 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:20:00 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:20:08 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:20:11 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:20:19 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:20:21 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:20:29 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is down
> Aug 14 13:20:31 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is down
> Aug 14 13:20:37 dc045 kernel: sd 25:0:42:0: attempting task abort! 
> scmd(ffff881c6e49aec0)
> Aug 14 13:20:37 dc045 kernel: sd 25:0:42:0: [sdfb] CDB: Write(10): 2a 
> 00 55 6a 72 c8 00 01 68 00
> Aug 14 13:20:37 dc045 kernel: scsi target25:0:42: handle(0x0037), 
> sas_address(0x5000c5007b2ee20d), phy(18)
> Aug 14 13:20:37 dc045 kernel: scsi target25:0:42: 
> enclosure_logical_id(0x500093d00104c000), slot(39)
> Aug 14 13:20:37 dc045 kernel: sd 27:0:42:0: attempting task abort! 
> scmd(ffff880c35fba7c0)
> Aug 14 13:20:37 dc045 kernel: sd 27:0:42:0: [sdlm] CDB: Write(10): 2a 
> 00 55 6a 6e c8 00 04 00 00
> Aug 14 13:20:37 dc045 kernel: scsi target27:0:42: handle(0x0037), 
> sas_address(0x5000c5007b2ee20e), phy(18)
> Aug 14 13:20:37 dc045 kernel: scsi target27:0:42: 
> enclosure_logical_id(0x500093d00104c000), slot(39)
> Aug 14 13:20:37 dc045 kernel: sd 25:0:42:0: task abort: SUCCESS 
> scmd(ffff881c6e49aec0)
> Aug 14 13:20:37 dc045 kernel: sd 27:0:42:0: task abort: SUCCESS 
> scmd(ffff880c35fba7c0)
> Aug 14 13:20:37 dc045 kernel: mpt2sas3: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(7), width(8)
> Aug 14 13:20:37 dc045 kernel: mpt2sas1: 
> _scsih_sas_broadcast_primitive_event: enter: phy number(5), width(8)
> Aug 14 13:20:39 dc045 multipathd: mpathaw: sdfb - directio checker 
> reports path is up
> Aug 14 13:20:39 dc045 multipathd: 129:208: reinstated
> Aug 14 13:20:39 dc045 multipathd: mpathaw: queue_if_no_path enabled
> Aug 14 13:20:39 dc045 multipathd: mpathaw: Recovered to normal mode
> Aug 14 13:20:39 dc045 multipathd: mpathaw: remaining active paths: 1
> Aug 14 13:20:41 dc045 multipathd: mpathaw: sdlm - directio checker 
> reports path is up
> Aug 14 13:20:41 dc045 multipathd: 68:320: reinstated
> Aug 14 13:20:41 dc045 multipathd: mpathaw: remaining active paths: 2
> Aug 14 13:21:12 dc045 kernel: md: unbind<dm-231>
> Aug 14 13:21:12 dc045 kernel: md: export_rdev(dm-231)
>
>
>
>
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x1001   f: 858-412-3845
m: 619-204-9061

4170 Morena Boulevard, Suite D - San Diego, CA 92117

High-performance Computing / Lustre Filesystems / Scale-out Storage

