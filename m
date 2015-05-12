From: James J <james.j@shiftmail.org>
Subject: MD RAID hot-replace wants to rewrite to the source! (and fails, and
 kicks)
Date: Tue, 12 May 2015 18:14:07 +0200
Message-ID: <555226CF.6040606@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Neil and other RAID developers,

I came across a problem of want_replacement not working as intended. Or 
at least not working as I think was intended.

The kernel is this, quite old
     3.4.34 (vanilla)
apologies if the behaviour has been fixed, but I don't recall to having 
seen this problem mentioned in patches or on the ML so I suppose this 
report is still valid.

Disk sdl in our storage server had shown one read error in smart check 
long and was apparently dying rapidly.
I issued want_replacement so to replicate sdl to the spare sdm.
It started correctly, like this:

     md54 : active raid5 sde1[0] sdh1[2] sdm1[5](R) sdf1[1] sdl1[6] sdi1[3]
             11603730432 blocks super 1.2 level 5, 1024k chunk, 
algorithm 2 [5/5] [UUUUU]
             [>....................]  recovery =  0.2% 
(6609916/2900932608) finish=598.6min speed=80573K/sec
             bitmap: 1/173 pages [4KB], 8192KB chunk

but then it met read errors in sdl (source) and instead of skipping 
those or rewriting those on just sdm, it tried to rewrite those (only or 
also) on sdl, i.e. the source.
Sdl was dying and was not capable of accepting the rewrites, so it was 
kicked by MD, the array went to degraded state, and the process 
restarted (or maybe continued) with reconstruction with one failed disk.

So it went from this:

     md54 : active raid5 sde1[0] sdh1[2] sdm1[5](R) sdf1[1] sdl1[6] sdi1[3]
             11603730432 blocks super 1.2 level 5, 1024k chunk, 
algorithm 2 [5/5] [UUUUU]
             [>....................]  recovery =  0.3% 
(11584992/2900932608) finish=1279.9min speed=37621K/sec
             bitmap: 1/173 pages [4KB], 8192KB chunk

To this:

     md54 : active raid5 sde1[0] sdh1[2] sdm1[5](R) sdf1[1] sdl1[6](F) 
sdi1[3]
             11603730432 blocks super 1.2 level 5, 1024k chunk, 
algorithm 2 [5/4] [UUUU_]
             [>....................]  recovery =  1.4% 
(41691236/2900932608) finish=578.6min speed=82352K/sec
             bitmap: 1/173 pages [4KB], 8192KB chunk

 From dmesg one cannot detect that MD performed a rewrite on sdl, but I 
can tell that from smartctl -x /dev/sdl, for which the last recorded 
error is:

     Error 17 [16] occurred at disk power-on lifetime: 15114 hours (629 
days + 18 hours)
     When the command that caused the error occurred, the device was 
active or idle.

     After command completion occurred, registers were:
     ER -- ST COUNT  LBA_48  LH LM LL DV DC
     -- -- -- == -- == == == -- -- -- -- --
     40 -- 51 00 00 00 00 01 62 a8 a0 40 00  Error: WP at LBA = 
0x0162a8a0 = 23242912

     Commands leading to the command that caused the error were:
     CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
     -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
     61 04 00 00 40 00 00 01 62 ab c0 40 00 10d+00:06:33.287  WRITE 
FPDMA QUEUED
     61 04 00 00 38 00 00 01 62 9f c0 40 00 10d+00:06:33.287  WRITE 
FPDMA QUEUED
     61 04 00 00 30 00 00 01 62 c3 c0 40 00 10d+00:06:33.285  WRITE 
FPDMA QUEUED
     61 04 00 00 28 00 00 01 62 c7 c0 40 00 10d+00:06:33.276  WRITE 
FPDMA QUEUED
     60 04 00 00 20 00 00 01 62 5f c0 40 00 10d+00:06:33.276  READ FPDMA 
QUEUED

which is a write error, and was not present before the replacement 
operation.

I thought the whole point of want_replacement was to NOT attempt to 
correct read errors onto the source. There is no point in doing that, 
doing that would just risk to make the source fail.

During a replacement read errors should IMHO remain read errors on the 
source. Even if it happens afterwards that normal array operation wants 
to read from exactly such sector which has not been rewritten, it will 
still receive a read error from the source. No problem because after 
this it has other 2 places to read such data from: sdm (replacement 
drive, if it has already passed that point), or reconstruction from the 
other members of the array. After this, again MD would try to perform a 
rewrite: also such rewrite (not coming from the reconstruction process) 
should again go just to the replacement drive and never to the source. 
Read errors on the source should remain read errors.

Here is an extract of the dmesg:

         ( LOTS of "Unhandled error code" and "read error corrected" for 
sdl1 before this )
     [865020.041576] end_request: I/O error, dev sdl, sector 23240640
     [865020.041831] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.041834] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.041837] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 af c0 
00 04 00 00
     [865020.041842] end_request: I/O error, dev sdl, sector 23244736
     [865020.041994] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.041996] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.041998] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 b3 c0 
00 04 00 00
     [865020.042004] end_request: I/O error, dev sdl, sector 23245760
     [865020.042153] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042155] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042158] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 b7 c0 
00 04 00 00
     [865020.042163] end_request: I/O error, dev sdl, sector 23246784
     [865020.042315] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042317] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042320] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 bb c0 
00 04 00 00
     [865020.042325] end_request: I/O error, dev sdl, sector 23247808
     [865020.042476] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042478] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042481] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 bf c0 
00 04 00 00
     [865020.042486] end_request: I/O error, dev sdl, sector 23248832
     [865020.042636] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042638] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042641] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 c7 c0 
00 04 00 00
     [865020.042647] end_request: I/O error, dev sdl, sector 23250880
     [865020.042797] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042799] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042801] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 cf c0 
00 04 00 00
     [865020.042807] end_request: I/O error, dev sdl, sector 23252928
     [865020.042956] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.042958] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.042961] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 d3 c0 
00 04 00 00
     [865020.042966] end_request: I/O error, dev sdl, sector 23253952
     [865020.100097] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100124] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100133] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100142] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100152] sd 4:0:11:0: [sdl] Unhandled error code
     [865020.100157] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100169] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.100174] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_SOFT_ERROR 
driverbyte=DRIVER_OK
     [865020.100181] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 d7 c0 
00 04 00 00
     [865020.100202] end_request: I/O error, dev sdl, sector 23254976
     [865020.106716] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106725] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106734] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106743] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106752] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106761] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106771] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106780] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865020.106902] sd 4:0:11:0: [sdl] Unhandled sense code
     [865020.106906] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
     [865020.106910] sd 4:0:11:0: [sdl]  Sense Key : Medium Error [current]
     [865020.106915] Info fld=0x162abc0
     [865020.106917] sd 4:0:11:0: [sdl]  Add. Sense: Unrecovered read error
     [865020.106923] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 ab c0 
00 04 00 00
     [865020.106932] end_request: critical target error, dev sdl, sector 
23243712
     [865022.912537] sd 4:0:11:0: [sdl] Unhandled sense code
     [865022.912543] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
     [865022.912548] sd 4:0:11:0: [sdl]  Sense Key : Medium Error [current]
     [865022.912554] Info fld=0x162dfc0
     [865022.912556] sd 4:0:11:0: [sdl]  Add. Sense: Unrecovered read error
     [865022.912561] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 df c0 
00 00 08 00
     [865022.912571] end_request: critical target error, dev sdl, sector 
23257024
     [865022.951721] raid5_end_read_request: 118 callbacks suppressed
     [865022.951726] md/raid:md54: read error corrected (8 sectors at 
23177152 on sdl1)
     [865022.951733] md/raid:md54: read error corrected (8 sectors at 
23177160 on sdl1)
     [865022.951737] md/raid:md54: read error corrected (8 sectors at 
23177168 on sdl1)
     [865022.951741] md/raid:md54: read error corrected (8 sectors at 
23177176 on sdl1)
     [865022.951744] md/raid:md54: read error corrected (8 sectors at 
23177184 on sdl1)
     [865022.951748] md/raid:md54: read error corrected (8 sectors at 
23177192 on sdl1)
     [865022.951751] md/raid:md54: read error corrected (8 sectors at 
23177200 on sdl1)
     [865022.951755] md/raid:md54: read error corrected (8 sectors at 
23177208 on sdl1)
     [865022.951758] md/raid:md54: read error corrected (8 sectors at 
23177216 on sdl1)
     [865022.951762] md/raid:md54: read error corrected (8 sectors at 
23177224 on sdl1)
     [865029.982668] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982685] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982694] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982722] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982731] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982740] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982764] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982804] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982812] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982821] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982830] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982839] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982848] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982857] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982866] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982875] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982884] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982893] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982903] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982912] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982921] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982930] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982939] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982948] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.982957] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865029.983003] sd 4:0:11:0: [sdl] Unhandled sense code
     [865029.983008] sd 4:0:11:0: [sdl]  Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
     [865029.983013] sd 4:0:11:0: [sdl]  Sense Key : Medium Error [current]
     [865029.983018] Info fld=0x1625c27
     [865029.983021] sd 4:0:11:0: [sdl]  Add. Sense: Unrecovered read error
     [865029.983026] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 5b c0 
00 04 00 00
     [865029.983036] end_request: critical target error, dev sdl, sector 
23223232
     [865029.990723] md/raid:md54: read error NOT corrected!! (sector 
23190464 on sdl1).
     [865029.990728] md/raid:md54: Disk failure on sdl1, disabling device.
     [865029.990729] md/raid:md54: Operation continuing on 4 devices.
     [865030.004221] md/raid:md54: read error not correctable (sector 
23190472 on sdl1).
     [865030.004224] md/raid:md54: read error not correctable (sector 
23190480 on sdl1).
     [865030.004227] md/raid:md54: read error not correctable (sector 
23190488 on sdl1).
     [865030.004231] md/raid:md54: read error not correctable (sector 
23190496 on sdl1).
     [865030.004234] md/raid:md54: read error not correctable (sector 
23190504 on sdl1).
     [865030.004237] md/raid:md54: read error not correctable (sector 
23190512 on sdl1).
     [865030.004240] md/raid:md54: read error not correctable (sector 
23190520 on sdl1).
     [865030.004243] md/raid:md54: read error not correctable (sector 
23190528 on sdl1).
     [865030.004246] md/raid:md54: read error not correctable (sector 
23190536 on sdl1).
     [865030.004250] md/raid:md54: read error not correctable (sector 
23190544 on sdl1).
     [865030.063169] raid5_end_read_request: 1142 callbacks suppressed
     [865030.063174] md/raid:md54: read error corrected (8 sectors at 
23200704 on sdl1)
     [865030.063181] md/raid:md54: read error corrected (8 sectors at 
23200712 on sdl1)
     [865030.063185] md/raid:md54: read error corrected (8 sectors at 
23200720 on sdl1)
     [865030.063189] md/raid:md54: read error corrected (8 sectors at 
23200728 on sdl1)
     [865030.063192] md/raid:md54: read error corrected (8 sectors at 
23200736 on sdl1)
     [865030.063196] md/raid:md54: read error corrected (8 sectors at 
23200744 on sdl1)
     [865030.063199] md/raid:md54: read error corrected (8 sectors at 
23200752 on sdl1)
     [865030.063203] md/raid:md54: read error corrected (8 sectors at 
23200760 on sdl1)
     [865030.063207] md/raid:md54: read error corrected (8 sectors at 
23200768 on sdl1)
     [865030.063210] md/raid:md54: read error corrected (8 sectors at 
23200776 on sdl1)
     [865031.472160] md: md54: recovery done.
     [865031.586603] md: recovery of RAID array md54
     [865031.586629] md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
     [865031.586633] md: using maximum available idle IO bandwidth (but 
not more than 80000 KB/sec) for recovery.
     [865031.586647] md: using 128k window, over a total of 2900932608k.
     [865031.586650] md: resuming recovery of md54 from checkpoint.
     [865038.511922] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865038.511934] mpt2sas0: log_info(0x31080000): originator(PL), 
code(0x08), sub_code(0x0000)
     [865038.512018] sd 4:0:11:0: [sdl] Unhandled sense code
     [865038.512032] sd 4:0:11:0: [sdl]
     [865038.512037] sd 4:0:11:0: attempting task abort! 
scmd(ffff880063d16500)
     [865038.512044] sd 4:0:11:0: [sdl] CDB: Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
     [865038.512050] sd 4:0:11:0: [sdl]  Sense Key : Medium Error [current]
     [865038.512057] ATA command pass through(16)Info fld=0x162a8a0
     [865038.512062] :
     [865038.512064] sd 4:0:11:0: [sdl]   85Add. Sense: Unrecovered read 
error 08 2e 00 d0 00 01 00 00 00 4f 00 c2 00 b0 00
     [865038.512082]
     [865038.512085] scsi target4:0:11: handle(0x001a), 
sas_address(0x443322110a000000), phy(10)
     [865038.512091] scsi target4:0:11: 
enclosure_logical_id(0x500062b2000c2f80), slot(10)
     [865038.512096] sd 4:0:11:0: [sdl] CDB: Read(10): 28 00 01 62 a7 c0 
00 04 00 00
     [865038.512106] end_request: critical target error, dev sdl, sector 
23242688
     [865038.519787] raid5_end_read_request: 117 callbacks suppressed
     [865038.519790] md/raid:md54: read error not correctable (sector 
23209920 on sdl1).
     [865038.519796] md/raid:md54: read error not correctable (sector 
23209928 on sdl1).
     [865038.519799] md/raid:md54: read error not correctable (sector 
23209936 on sdl1).
     [865038.519803] md/raid:md54: read error not correctable (sector 
23209944 on sdl1).
     [865038.519806] md/raid:md54: read error not correctable (sector 
23209952 on sdl1).
     [865038.519809] md/raid:md54: read error not correctable (sector 
23209960 on sdl1).
     [865038.519813] md/raid:md54: read error not correctable (sector 
23209968 on sdl1).
     [865038.519816] md/raid:md54: read error not correctable (sector 
23209976 on sdl1).
     [865038.519819] md/raid:md54: read error not correctable (sector 
23209984 on sdl1).
     [865038.519822] md/raid:md54: read error not correctable (sector 
23209992 on sdl1).
     [865042.322285] sd 4:0:11:0: task abort: SUCCESS scmd(ffff880063d16500)
     [865043.156822] raid5_end_read_request: 2294 callbacks suppressed
     [865043.156828] md/raid:md54: read error corrected (8 sectors at 
23211968 on sdm1)
     [865043.156835] md/raid:md54: read error corrected (8 sectors at 
23211976 on sdm1)
     [865043.156838] md/raid:md54: read error corrected (8 sectors at 
23211984 on sdm1)
     [865043.156842] md/raid:md54: read error corrected (8 sectors at 
23211992 on sdm1)
     [865043.156845] md/raid:md54: read error corrected (8 sectors at 
23212000 on sdm1)
     [865043.156848] md/raid:md54: read error corrected (8 sectors at 
23212008 on sdm1)
     [865043.156852] md/raid:md54: read error corrected (8 sectors at 
23212016 on sdm1)
     [865043.156855] md/raid:md54: read error corrected (8 sectors at 
23212024 on sdm1)
     [865043.156858] md/raid:md54: read error corrected (8 sectors at 
23212032 on sdm1)
     [865043.156861] md/raid:md54: read error corrected (8 sectors at 
23212040 on sdm1)
     -- End of dmesg.---

(The recovery is still running. Let's hope I don't have ANY bad sector 
on the other 4 disks... )

Also you can notice some strange dmesg logs at 865043 which are a bit 
confusing. I am guessing it is a leftover of the reconstruction process 
which saw sdm1 suddenly take the place of sdl1 while there were still 
ongoing rewrites. Note that smartctl -x /dev/sdm does not report any 
read or write error during operation, so I am quite sure it cannot 
really be a read error from sdm1.

Thank you
JJ

