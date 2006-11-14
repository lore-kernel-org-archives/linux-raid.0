From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[4]: RAID1 submirror failure causes reboot?
Date: Tue, 14 Nov 2006 13:36:12 +0300
Message-ID: <77664873.20061114133612@2ka.mipt.ru>
References: <1007879814.20061110111729@2ka.mipt.ru>
 <17748.15156.405065.904318@cse.unsw.edu.au>
 <208777171.20061110155306@2ka.mipt.ru>
 <17752.7205.373640.220014@cse.unsw.edu.au> <20061113201105.GD15031@kernel.dk>
 <17752.60436.276119.191856@cse.unsw.edu.au> <20061114072857.GI15031@kernel.dk>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061114072857.GI15031@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jim Klimov <klimov@2ka.mipt.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Jens,

JA> Then lets wait for Jim to repeat his testing with all the debugging
JA> options enabled, that should make us a little wiser.
Ok, I'll enable the kernel rebuilt with these options and report any
findings later. So far, I'll move to the other questions aroused.

I remember when I ran with most of debugging ON last week, it made the
server run darn slow, with LA around 40-60 and little responsiveness,
and numerous messages like: 
  Hangcheck: hangcheck value past margin!
  BUG: soft lockup detected on CPU#1!
which hide the interesting traces :)
However, I can post these captured traces of several system lifetimes
to the list or privately.

Concerning other questions:
1) The workload on the software raid is rather small. It's a set of
   system partitions which keep fileserver's logs, etc. The file
   storage is on 3Ware cards and has substantial load. MD arrays are
   checked nightly, though (echo check > sync_action), and most often
   this triggers the problem. These drives only contain mirrored
   partitions, so there should be no I/O to these drives around
   MD, except for rare cases of lilo running :)

2) I have installed a third submirror disk this weekend, it's an IDE
   slave device hdd (near the failing hdc). Since then I got errors
   on other partitions, attached below as "2*)".
   
3) The failures which lead to reboots are usually preceded by a long
   history of dma_intr errors 0x40 and 0x51, but that sample I sent
   was rather full. A few errors preceded it every 5 seconds, making
   the full trace like this:

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
[87403.795270] Code: ff ff ff b9 0b 00 14 c0 8d f0 <0>Kernel panic - not syncing: Fatal exception in interrupt
smp_call_function+0x12b/0x130
[87403.935200]  [<c013e66f>] 


2*) The new problem log:

... rebuilding new spare partitions into a 3-way array went well...
[114683.721498]  --- wd:3 rd:3
[114683.721508]  disk 0, wo:0, o:1, dev:hdc10
[114683.721541]  disk 1, wo:0, o:1, dev:hda10
[114683.721556]  disk 2, wo:0, o:1, dev:hdd10
[115150.208060] RAID1 conf printout:
[115150.211893]  --- wd:3 rd:3
[115150.214923]  disk 0, wo:0, o:1, dev:hdc8
[115150.219269]  disk 1, wo:0, o:1, dev:hda8
[115150.224022]  disk 2, wo:0, o:1, dev:hdd8
[115296.149849] RAID1 conf printout:
[115296.149868]  --- wd:3 rd:3
[115296.149895]  disk 0, wo:0, o:1, dev:hdc7
[115296.149915]  disk 1, wo:0, o:1, dev:hda7
[115296.149931]  disk 2, wo:0, o:1, dev:hdd7
[115460.641824] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[115460.649294] hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=28433205, sector=28433023
[115460.658774] ide: failed opcode was: unknown
[115460.663287] end_request: I/O error, dev hdc, sector 28433023
[115465.938995] hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
[115465.946451] hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=28433201, sector=28433031
[115465.957536] ide: failed opcode was: unknown
[115465.962041] end_request: I/O error, dev hdc, sector 28433031
[115488.743391] hdc: dma_timer_expiry: dma status == 0x60
[115488.748714] hdc: DMA timeout retry
[115488.752450] hdc: timeout waiting for DMA
[115488.979377] hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[115488.987829] ide: failed opcode was: unknown
[115488.992469] hdc: drive not ready for command
[115518.991827] hdc: lost interrupt
[115518.995201] hdc: task_out_intr: status=0x58 { DriveReady SeekComplete DataRequest }
[115519.003493] ide: failed opcode was: unknown
[115524.009004] hdc: status timeout: status=0xd0 { Busy }
[115524.014441] ide: failed opcode was: unknown
[115524.018988] hdc: drive not ready for command
[115524.114548] ide1: reset: success
[115524.198619] raid1: Disk failure on hdc6, disabling device. 
[115524.198624]         Operation continuing on 2 devices
[115524.209260] hdc: task_out_intr: status=0x50 { DriveReady SeekComplete }
[115544.209530] hdc: dma_timer_expiry: dma status == 0x20
[115544.215027] hdc: DMA timeout retry
[115544.218669] hdc: timeout waiting for DMA
[115544.461490] hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[115544.469875] ide: failed opcode was: unknown
[115544.474388] hdc: drive not ready for command
[115544.503556] RAID1 conf printout:
[115544.507091]  --- wd:1 rd:2
[115544.510120]  disk 0, wo:0, o:1, dev:hdd1
[115544.712573] ------------[ cut here ]------------
[115544.717459] kernel BUG at mm/filemap.c:541!
[115544.721902] invalid opcode: 0000 [#1]
[115544.725806] SMP 
[115544.728015] Modules linked in: w83781d hwmon_vid i2c_isa i2c_core w83627hf_wdt
[115544.735981] CPU:    0
[115544.735983] EIP:    0060:[<c013c436>]    Not tainted VLI
[115544.735986] EFLAGS: 00010046   (2.6.18.2server #4) 
[115544.749248] EIP is at unlock_page+0xf/0x28
[115544.753589] eax: 00000000   ebx: c1f5d8c0   ecx: eab25680   edx: c1f5d8c0
[115544.760627] esi: f6a78f00   edi: 00000001   ebp: 00000000   esp: c0481e7c
[115544.767703] ds: 007b   es: 007b   ss: 0068
[115544.772033] Process swapper (pid: 0, ti=c0480000 task=c040e460 task.ti=c0480000)
[115544.779512] Stack: eab25674 c017bed6 f6a78f00 00000000 c017be7c c016069e 00000003 c2e2aa20 
[115544.788824]        c0115cf1 00000020 f6a78f00 00003400 f6a78f00 00000000 c024f8ac f7f37a00 
[115544.798171]        f7f37a00 00000001 c04fcd94 00000001 00000000 00000000 00000000 00002c00 
[115544.807683] Call Trace:
[115544.810797]  [<c017bed6>] mpage_end_io_read+0x5a/0x6e
[115544.816407]  [<c017be7c>] mpage_end_io_read+0x0/0x6e
[115544.821865]  [<c016069e>] bio_endio+0x5f/0x84
[115544.826749]  [<c0115cf1>] find_busiest_group+0x153/0x4df
[115544.832582]  [<c024f8ac>] __end_that_request_first+0x1ec/0x31c
[115544.838889]  [<c02b508a>] __ide_end_request+0x56/0xe4
[115544.844462]  [<c02b5159>] ide_end_request+0x41/0x65
[115544.849671]  [<c02bad69>] task_end_request+0x37/0x7e
[115544.854950]  [<c02baed9>] task_out_intr+0x84/0xb9
[115544.860128]  [<c01243bd>] del_timer+0x56/0x58
[115544.864839]  [<c02bae55>] task_out_intr+0x0/0xb9
[115544.869760]  [<c02b6a4b>] ide_intr+0xb7/0x132
[115544.874467]  [<c013a2f4>] handle_IRQ_event+0x26/0x59
[115544.879740]  [<c013a3ae>] __do_IRQ+0x87/0xed
[115544.884368]  [<c0105199>] do_IRQ+0x31/0x69
[115544.888843]  [<c0103746>] common_interrupt+0x1a/0x20
[115544.894124]  [<c0100c4f>] default_idle+0x35/0x5b
[115544.899233]  [<c0100d03>] cpu_idle+0x7a/0x83
[115544.903844]  [<c0486810>] start_kernel+0x16a/0x194
[115544.908950]  [<c0486286>] unknown_bootoption+0x0/0x1b6
[115544.914384] Code: e8 5e ff ff ff b9 __wake_up+0x38/0x4e
[115545.083930]  [<c01243bd>] 


-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

