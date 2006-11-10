From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: RAID1 submirror failure causes reboot?
Date: Fri, 10 Nov 2006 11:17:29 +0300
Message-ID: <1007879814.20061110111729@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Linux RAID,

  One of our servers using per-partition mirroring has a
  frequently-failing partition, hdc11 below.

  When it is dubbed failing, the server usually crashes
  with a stacktrace like below. This seems strange, because
  the other submirror, hda11 is alive and well, and this
  should all be transparent thru the RAID layer? This is
  what it's for?

  After the reboot I usually succeed in hot-adding hdc11
  back to the mirror, although several times it was not
  marked dead at all and rebuilt by itself after reboot.
  Also seems rather incorrect: if it died, it should be
  marked so (perhaps in metadata on a live mirror)?

  Overall, uncool (although mirroring has saved us many
  times, thanks!)

Nov 10 03:56:51 video kernel: [84443.270516] md: syncing RAID array md11
Nov 10 03:56:52 video kernel: [84443.270532] md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/
disc.
Nov 10 03:56:54 video kernel: [84443.270544] md: using maximum available idle IO bandwidth (but not more
 than 200000 KB/sec) for reconstruction.
Nov 10 03:56:55 video kernel: [84443.270565] md: using 128k window, over a total of 65430144 blocks.
Nov 10 03:56:56 video kernel: [84443.271478] RAID1 conf printout:
Nov 10 03:57:01 video kernel: [84443.275446]  --- wd:2 rd:2
Nov 10 03:57:10 video kernel: [84443.278773]  disk 0, wo:0, o:1, dev:hdc10
Nov 10 03:57:11 video kernel: [84443.283272]  disk 1, wo:0, o:1, dev:hda10
[87319.049902] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[87319.057393] hdc: dma_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315631
[87319.067205] ide: failed opcode was: unknown
[87323.956399] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[87323.963681] hdc: dma_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315631
[87323.973171] ide: failed opcode was: unknown
[87328.846265] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[87328.853485] hdc: dma_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315631
[87328.862834] ide: failed opcode was: unknown
[87333.736127] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[87333.743535] hdc: dma_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315631
[87333.752876] ide: failed opcode was: unknown
[87333.806569] ide1: reset: success
[87338.675891] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87338.685143] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
[87338.694791] ide: failed opcode was: unknown
[87343.557424] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87343.566388] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
[87343.576105] ide: failed opcode was: unknown
[87348.472226] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87348.481170] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
[87348.490843] ide: failed opcode was: unknown
[87353.387028] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87353.395735] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
[87353.405500] ide: failed opcode was: unknown
[87353.461342] ide1: reset: success
[87358.326783] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87358.335739] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87358.345395] ide: failed opcode was: unknown
[87363.208313] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87363.217319] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87363.228371] ide: failed opcode was: unknown
[87368.106472] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87368.115414] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87368.125275] ide: failed opcode was: unknown
[87372.979686] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87372.988706] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87372.998849] ide: failed opcode was: unknown
[87373.052152] ide1: reset: success
[87377.927744] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87377.936682] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87377.946399] ide: failed opcode was: unknown
[87382.800953] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87382.809881] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87382.819511] ide: failed opcode was: unknown
[87387.682479] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87387.691473] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87387.701287] ide: failed opcode was: unknown
[87392.564004] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87392.572790] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87392.582454] ide: failed opcode was: unknown
[87392.635961] ide1: reset: success
[87397.528687] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
[87397.537607] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
[87397.547335] ide: failed opcode was: unknown
[87397.551897] end_request: I/O error, dev hdc, sector 176315718
[87398.520820] raid1: Disk failure on hdc11, disabling device. 
[87398.520826]  Operation continuing on 1 devices
[87398.531579] blk: request botched
[87398.535098] hdc: task_out_intr: status=0x50 { DriveReady SeekComplete }
[87398.542129] ide: failed opcode was: unknown
[87403.582775] ------------[ cut here ]------------
[87403.587748] kernel BUG at mm/filemap.c:541!
[87403.592082] invalid opcode: 0000 [#1]
[87403.596063] SMP 
[87403.598217] Modules linked in: w83781d hwmon_vid i2c_isa i2c_core w83627hf_wdt
[87403.606114] CPU:    0
[87403.606117] EIP:    0060:[<c01406a7>]    Not tainted VLI
[87403.606120] EFLAGS: 00010046   (2.6.18.2debug #1) 
[87403.619728] EIP is at unlock_page+0x12/0x2d
[87403.624170] eax: 00000000   ebx: c2d5caa8   ecx: e8148680   edx: c2d5caa8
[87403.631543] esi: da71c600   edi: 00000001   ebp: c04cfe28   esp: c04cfe24
[87403.638924] ds: 007b   es: 007b   ss: 0068
[87403.643419] Process swapper (pid: 0, ti=c04ce000 task=c041e500 task.ti=c04ce000)
[87403.650774] Stack: e81487e8 c04cfe3c c0180e0a da71c600 00000000 c0180dac c04cfe64 c0164af9 
[87403.659985]        f7d49000 c04cfe84 f2dea5a0 f2dea5a0 00000000 da71c600 00000000 da71c600 
[87403.669288]        c04cfea8 c0256778 c041e500 00000000 c04cbd90 00000046 00000000 00000000 
[87403.678603] Call Trace:
[87403.681462]  [<c0103bba>] show_stack_log_lvl+0x8d/0xaa
[87403.686911]  [<c0103ddc>] show_registers+0x1b0/0x221
[87403.692306]  [<c0103ffc>] die+0x124/0x1ee
[87403.696558]  [<c0104165>] do_trap+0x9f/0xa1
[87403.700988]  [<c0104427>] do_invalid_op+0xa7/0xb1
[87403.706012]  [<c0103871>] error_code+0x39/0x40
[87403.710794]  [<c0180e0a>] mpage_end_io_read+0x5e/0x72
[87403.716154]  [<c0164af9>] bio_endio+0x56/0x7b
[87403.720798]  [<c0256778>] __end_that_request_first+0x1e0/0x301
[87403.726985]  [<c02568a4>] end_that_request_first+0xb/0xd
[87403.732699]  [<c02bd73c>] __ide_end_request+0x54/0xe1
[87403.738214]  [<c02bd807>] ide_end_request+0x3e/0x5c
[87403.743382]  [<c02c35df>] task_error+0x5b/0x97
[87403.748113]  [<c02c36fa>] task_in_intr+0x6e/0xa2
[87403.753120]  [<c02bf19e>] ide_intr+0xaf/0x12c
[87403.757815]  [<c013e5a7>] handle_IRQ_event+0x23/0x57
[87403.763135]  [<c013e66f>] __do_IRQ+0x94/0xfd
[87403.767802]  [<c0105192>] do_IRQ+0x32/0x68
[87403.772278]  [<c010372e>] common_interrupt+0x1a/0x20
[87403.777586]  [<c0100cfe>] cpu_idle+0x7d/0x86
[87403.782184]  [<c01002b7>] rest_init+0x23/0x25
[87403.786869]  [<c04d4889>] start_kernel+0x175/0x19d
[87403.791963]  [<00000000>] 0x0
[87403.795270] Code: ff ff ff b9 0b 00 14 c0 8d 55 dc c7 04 24 02 00 00 00 e8 21 26 25 00 eb dc 55 89 e5
 53 89 c3 31 c0 f0 0f b3 03 19 c0 85 c0 75 08 <0f> 0b 1d 02 6c bf 3b c0 89 d8 e8 34 ff ff ff 89 da 31 c9
 e8 24 
[87403.819040] EIP: [<c01406a7>] unlock_page+0x12/0x2d SS:ESP 0068:c04cfe24
[87403.826101]  <0>Kernel panic - not syncing: Fatal exception in interrupt  

-- 
Best regards,
 Jim Klimov                          mailto:klimov@2ka.mipt.ru

