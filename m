From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: (unknown)
Date: Sun, 30 Nov 2014 13:54:35 +0000
Message-ID: <CADNH=7G7_wNR=bii6sWpLexXX8OcSac=7Cyim5+7ZP5bdhgesQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

Should I be worried? I'm not seeing this often, and ata6 seems to be
healthy. Message:

[236279.768693] INFO: task transmission-da:1050 blocked for more than
120 seconds.
[236279.768709]       Not tainted 3.18.0-997-generic #201411142105
[236279.768720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[236279.768735] transmission-da D f25fa780     0  1050      1 0x0000000=
0
[236279.768738]  f0717c78 00200086 00000000 f25fa780 00200246 aeadd839
0000d6b8 c15d1509
[236279.768741]  f2584200 c1b532c0 f63b08c0 c1b532c0 f2584200 f6bcf2c0
efcae200 f3cbbd40
[236279.768744]  f2d57200 f25fa780 f2d572a8 00200246 00000000 f0717c70
c160651f f0717c60
[236279.768747] Call Trace:
[236279.768753]  [<c15d1509>] ? __dev_queue_xmit+0x1a9/0x480
[236279.768756]  [<c160651f>] ? ip_finish_output+0x21f/0x4a0
[236279.768758]  [<c1604430>] ? ip_forward_options+0x1f0/0x1f0
[236279.768762]  [<c16cb173>] schedule+0x23/0x60
[236279.768765]  [<c1256b57>] wait_transaction_locked+0x67/0x90
[236279.768768]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.768770]  [<c1256cde>] add_transaction_credits+0x9e/0x1c0
[236279.768772]  [<c1256fb7>] start_this_handle+0x117/0x280
[236279.768774]  [<c12572a4>] ? jbd2__journal_start.part.7+0x24/0x180
[236279.768776]  [<c12572f5>] jbd2__journal_start.part.7+0x75/0x180
[236279.768779]  [<c114bef9>] ? get_page_from_freelist+0x1b9/0x3c0
[236279.768781]  [<c1257463>] jbd2__journal_start+0x63/0x70
[236279.768784]  [<c123f56c>] __ext4_journal_start_sb+0x5c/0xc0
[236279.768787]  [<c1218624>] ? ext4_dirty_inode+0x34/0x60
[236279.768789]  [<c1218624>] ext4_dirty_inode+0x34/0x60
[236279.768792]  [<c11c7b25>] __mark_inode_dirty+0x35/0x270
[236279.768793]  [<c114c23a>] ? __alloc_pages_nodemask+0x13a/0x910
[236279.768796]  [<c11bb347>] update_time.part.13+0x57/0xa0
[236279.768798]  [<c11bb3b5>] update_time+0x25/0x30
[236279.768799]  [<c11bb439>] file_update_time+0x79/0xc0
[236279.768802]  [<c1146a9a>] __generic_file_write_iter+0x17a/0x420
[236279.768805]  [<c1199701>] ? memcg_check_events+0xb1/0xc0
[236279.768807]  [<c120cc6d>] ext4_file_write_iter+0x11d/0x550
[236279.768810]  [<c10bd339>] ? update_process_times+0x59/0x70
[236279.768813]  [<c116e1a7>] ? __handle_mm_fault+0x1d7/0x290
[236279.768827]  [<f920e560>] ? reada_start_machine_worker+0x10/0x130 [=
btrfs]
[236279.768829]  [<c11a38ff>] new_sync_write+0x6f/0xb0
[236279.768830]  [<c11a3890>] ? do_sync_readv_writev+0x90/0x90
[236279.768832]  [<c11a42a6>] vfs_write+0xa6/0x1d0
[236279.768834]  [<c11a47e3>] SyS_pwrite64+0x93/0xa0
[236279.768836]  [<c16ce89f>] sysenter_do_call+0x12/0x12
[236279.768845] INFO: task md0_raid6:8494 blocked for more than 120 sec=
onds.
[236279.768858]       Not tainted 3.18.0-997-generic #201411142105
[236279.768869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[236279.768883] md0_raid6       D 00000008     0  8494      2 0x0000000=
0
[236279.768885]  e78ade90 00000046 f6290000 00000008 e78ade30 d0750f81
0000d6b7 00000000
[236279.768888]  f3733c17 c1b532c0 f63b08c0 c1b532c0 e78ade48 f6bbf2c0
e7b00620 c19daa40
[236279.768891]  e7756010 f07c4600 e78ade90 c1563ad7 00000010 00000000
00001000 f70ee3e0
[236279.768894] Call Trace:
[236279.768897]  [<c1563ad7>] ? write_sb_page+0x147/0x2c0
[236279.768899]  [<c1097691>] ? prepare_to_wait_event+0x71/0xd0
[236279.768901]  [<c16cb173>] schedule+0x23/0x60
[236279.768903]  [<c155e79d>] md_super_wait+0x3d/0x70
[236279.768904]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.768907]  [<c15657e7>] bitmap_unplug.part.24+0x117/0x120
[236279.768909]  [<f89a6ff5>] ? __release_stripe+0x15/0x20 [raid456]
[236279.768911]  [<c1565810>] bitmap_unplug+0x20/0x30
[236279.768914]  [<f89b0b6d>] raid5d+0x9d/0x2a0 [raid456]
[236279.768915]  [<c15587c4>] md_thread+0xe4/0x110
[236279.768917]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.768919]  [<c15586e0>] ? md_rdev_init+0x100/0x100
[236279.768921]  [<c107a76b>] kthread+0x9b/0xb0
[236279.768923]  [<c16ce7c1>] ret_from_kernel_thread+0x21/0x30
[236279.768925]  [<c107a6d0>] ? flush_kthread_worker+0x80/0x80
[236279.768926] INFO: task jbd2/md0-8:8521 blocked for more than 120 se=
conds.
[236279.768939]       Not tainted 3.18.0-997-generic #201411142105
[236279.768950] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[236279.768964] jbd2/md0-8      D d0c8066c     0  8521      2 0x0000000=
0
[236279.768966]  e79d7e38 00000046 00000066 d0c8066c f6bcf308 f901623b
0000d6b7 e79d7de8
[236279.768968]  c114e420 c1b532c0 f63b08c0 c1b532c0 43180010 f6bbf2c0
f0b34360 c19daa40
[236279.768971]  00000066 00000001 f6bcf308 003595ef 00000000 a6f6f9de
00000066 f6bcf308
[236279.768974] Call Trace:
[236279.768984]  [<c114e420>] ? account_page_dirtied+0x90/0x100
[236279.768988]  [<c108e406>] ? dequeue_task_fair+0x316/0x6b0
[236279.768990]  [<c1088fcd>] ? sched_clock_cpu+0x10d/0x170
[236279.768992]  [<c16cb173>] schedule+0x23/0x60
[236279.768994]  [<c1259b41>] jbd2_journal_commit_transaction+0x1f1/0x1=
480
[236279.768996]  [<c108c18f>] ? set_next_entity+0xbf/0xf0
[236279.768999]  [<c100f95f>] ? __switch_to+0x10f/0x470
[236279.769001]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.769004]  [<c125e0a0>] kjournald2+0xa0/0x210
[236279.769005]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.769007]  [<c125e000>] ? commit_timeout+0x10/0x10
[236279.769009]  [<c107a76b>] kthread+0x9b/0xb0
[236279.769010]  [<c16ce7c1>] ret_from_kernel_thread+0x21/0x30
[236279.769012]  [<c107a6d0>] ? flush_kthread_worker+0x80/0x80
[236279.769016] INFO: task kworker/u4:0:12352 blocked for more than 120=
 seconds.
[236279.769040]       Not tainted 3.18.0-997-generic #201411142105
[236279.769063] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[236279.769100] kworker/u4:0    D 0b583c00     0 12352      2 0x0000000=
0
[236279.769104] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
[236279.769105]  f07779b0 00000046 e78018d8 0b583c00 f0777948 d07347a2
0000d6b7 f89ac8d4
[236279.769108]  f724a2e0 c1b532c0 f63b08c0 c1b532c0 f077797c f6bcf2c0
d0c80620 f25eee40
[236279.769110]  c1564201 e7756000 c0055f48 f32f2600 f0777d34 f0777d44
f077799c f07779b0
[236279.769113] Call Trace:
[236279.769115]  [<f89ac8d4>] ? raid5_unplug+0xc4/0x160 [raid456]
[236279.769117]  [<c1564201>] ? bitmap_checkpage+0xb1/0x110
[236279.769120]  [<c12fb623>] ? blk_flush_plug_list+0x83/0x1b0
[236279.769122]  [<c16cb173>] schedule+0x23/0x60
[236279.769124]  [<f89af45e>] get_active_stripe+0x24e/0x450 [raid456]
[236279.769126]  [<f89accc6>] ? add_stripe_bio+0x356/0x410 [raid456]
[236279.769128]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.769130]  [<f89b2631>] make_request+0x1a1/0x6a0 [raid456]
[236279.769132]  [<c10976f0>] ? prepare_to_wait_event+0xd0/0xd0
[236279.769133]  [<c1557a50>] md_make_request+0xc0/0x1e0
[236279.769136]  [<c132a644>] ? radix_tree_lookup+0x14/0x20
[236279.769139]  [<c12f6eb7>] generic_make_request.part.74+0x57/0x90
[236279.769141]  [<c12f8edf>] generic_make_request+0x4f/0x60
[236279.769143]  [<c12f8f5a>] submit_bio+0x6a/0x140
[236279.769145]  [<c114d736>] ? account_page_writeback+0x26/0x30
[236279.769147]  [<c1219470>] ext4_io_submit+0x20/0x40
[236279.769150]  [<c12194c6>] io_submit_add_bh.isra.6+0x36/0x90
[236279.769152]  [<c1219648>] ext4_bio_write_page+0xf8/0x1f0
[236279.769154]  [<c1211dc9>] mpage_submit_page+0x89/0xc0
[236279.769156]  [<c121225d>] mpage_map_and_submit_buffers+0x11d/0x200
[236279.769158]  [<c121785d>] mpage_map_and_submit_extent+0x6d/0x290
[236279.769160]  [<c1217f39>] ext4_writepages+0x4b9/0x6b0
[236279.769162]  [<f89a6f1f>] ? do_release_stripe+0xaf/0x170 [raid456]
[236279.769165]  [<c11c7385>] ? __writeback_single_inode+0x75/0x170
[236279.769167]  [<c11c71b5>] ? write_inode+0x45/0xd0
[236279.769169]  [<c114f261>] do_writepages+0x21/0x40
[236279.769171]  [<c11c7348>] __writeback_single_inode+0x38/0x170
[236279.769173]  [<c11c88a5>] writeback_sb_inodes+0x1c5/0x290
[236279.769175]  [<c11c89e4>] __writeback_inodes_wb+0x74/0xa0
[236279.769178]  [<c11c8c2a>] wb_writeback+0x21a/0x2b0
[236279.769180]  [<c11c8e77>] wb_do_writeback+0x127/0x150
[236279.769182]  [<c132f5fe>] ? vsnprintf+0x1be/0x3a0
[236279.769184]  [<c11ca840>] bdi_writeback_workfn+0x70/0x1a0
[236279.769186]  [<c10743d1>] ? pwq_dec_nr_in_flight+0x41/0x90
[236279.769187]  [<c1075511>] process_one_work+0x121/0x3a0
[236279.769189]  [<c1086da0>] ? default_wake_function+0x10/0x20
[236279.769191]  [<c1075d20>] worker_thread+0xf0/0x370
[236279.769192]  [<c109719f>] ? __wake_up_locked+0x1f/0x30
[236279.769194]  [<c1075c30>] ? create_worker+0x1b0/0x1b0
[236279.769196]  [<c107a76b>] kthread+0x9b/0xb0
[236279.769197]  [<c16ce7c1>] ret_from_kernel_thread+0x21/0x30
[236279.769199]  [<c107a6d0>] ? flush_kthread_worker+0x80/0x80
[236325.668648] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6 frozen
[236325.668688] ata6.00: failed command: FLUSH CACHE EXT
[236325.668711] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 26
[236325.668711]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[236325.668771] ata6.00: status: { DRDY }
[236325.668792] ata6: hard resetting link
[236325.988624] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[236326.001713] ata6.00: configured for UDMA/133
[236326.001716] ata6.00: retrying FLUSH 0xea Emask 0x4
[236326.001775] ata6: EH complete

Details:

=E2=94=9Cscsi 6:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JR0B501861}
=E2=94=82=E2=94=94sdc 1.82t [8:32] MD raid6 (6) inactive 'ion:md0'
{0ad2603e-e432-83ee-0218-077398e716ef}
=E2=94=82 =E2=94=9Csdc1 1.82t [8:33] MD raid6 (1/5) (w/ sda1,sdb1,sdd1,=
sde1) in_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
=E2=94=82 =E2=94=82=E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 51=
2k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
=E2=94=82 =E2=94=82                 ext4 '6TB_RAID6' {9e3c1fbe-8228-4b3=
8-9047-66a5e2429e5f}

(unrelated, how do I clear old superblock off the block device without
messing with partitions or other superblocks?)

smartctl:

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     SAMSUNG SpinPoint F4 EG (AF)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2H7JR0B501861
LU WWN Device Id: 5 0000f0 0500b6118
=46irmware Version: 1AQ10001
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Sun Nov 30 13:54:40 2014 GMT
[....]
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       1
  2 Throughput_Performance  0x0026   055   033   000    Old_age
Always       -       19044
  3 Spin_Up_Time            0x0023   067   065   025    Pre-fail
Always       -       10188
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       76
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       24173
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       68
181 Program_Fail_Cnt_Total  0x0022   100   100   000    Old_age
Always       -       3143559
191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
194 Temperature_Celsius     0x0002   064   052   000    Old_age
Always       -       30 (Min/Max 12/48)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       6
223 Load_Retry_Count        0x0032   252   252   000    Old_age
Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       78

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     24089   =
      -
# 2  Extended offline    Completed without error       00%     24019   =
      -

Regards
MAthias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
