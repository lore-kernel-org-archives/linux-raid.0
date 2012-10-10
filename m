From: GuoZhong Han <hanguozhong@meganovo.com>
Subject: task xfssyncd blocked while raid5 was in recovery
Date: Wed, 10 Oct 2012 11:14:05 +0800
Message-ID: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, every one:

Recently, a problem has troubled me for a long time.

I created a 4*2T (sda, sdb, sdc, sdd) raid5 with XFS file system, 128K
chuck size and 2048 strip_cache_size. The mdadm 3.2.2, kernel 2.6.38
and mkfs.xfs 3.1.1 were used. When the raid5 was in recovery and the
schedule reached 47%, I/O errors occurred in sdb. The following was
the output:



=2E.....

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

=85=85

d 0:0:1:0: [sdb]  Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE

sd 0:0:1:0: [sdb]  Sense Key : Aborted Command [current] [descriptor]

Descriptor sense data with sense descriptors (in hex):

        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00

        00 00 00 f7

sd 0:0:1:0: [sdb]  Add. Sense: No additional sense information

sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 6f 4c cc 80 00 04 00 00

end_request: I/O error, dev sdb, sector 1867304064

hrtimer: interrupt took 28024956 ns

ata2: status=3D0x41 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translatedserver RspCode F688 Ctrl 0 Idx A6F Len 70 ATA stat/err =
0x

41/04 to SCSI SK00 00 64 65 35 64 62 65 65 31 3A 32 64 38 35 63 37 30
63 3A 39 64 31 63 33 63 38 39 3A 32 32 64 39 32 65 32 31 00 00 00 00
00 00/ASC/ASCQ 0xb/00 /00

00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
2F 00 00 00 ata2: status=3D0x4

1 { DriveReady Error }

ata2: error=3D0x04 { DriveStatusError }

ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00

sd 0:0:1:0: [sdb]  Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE

sd 0:0:1:0: [sdb]  Sense Key : Aborted Command [current] [descriptor]

Descriptor sense data with sense descriptors (in hex):

        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00

        00 00 00 f7

sd 0:0:1:0: [sdb]  Add. Sense: No additional sense information

sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 6f 4c a4 80 00 04 00 00

end_request: I/O error, dev sdb, sector 1867293824

ata2: status=3D0x41 { DriveReady Error }

=85=85



Then, there were lots of error messages about the file system. The
following was the output:



=2E.....

INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.

xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000

  frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)

  frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)

  frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp
0xfffffe008d7ffd18)

  frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)

  frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18=
)

  frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)

  frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe5=
0)

  frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)

  frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)

  frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)

  frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)

  frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)

  frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80=
)

  frame 13: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp
0xfffffe008d7fffe8)

INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.

xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000

  frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)

  frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)

  frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp
0xfffffe008d7ffd18)

  frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)

  frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18=
)

  frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)

  frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe5=
0)

  frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)

  frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)

  frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)

  frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)

  frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)

  frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80=
)

  frame 13: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp
0xfffffe008d7fffe8)

INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.

xfssyncd/md127  D fffffff7000216d0     0  1058      2 0x00000000

  frame 0: 0xfffffff700020570 __switch_to+0x1b8/0x1c0 (sp 0xfffffe008d7=
ff900)

  frame 1: 0xfffffff7000216d0 schedule+0x918/0x1538 (sp 0xfffffe008d7ff=
9d0)

  frame 2: 0xfffffff700022a90 schedule_timeout+0x268/0x5b0 (sp
0xfffffe008d7ffd18)

  frame 3: 0xfffffff700024ee0 __down+0xd8/0x158 (sp 0xfffffe008d7ffda8)

  frame 4: 0xfffffff70085da78 down.cold+0x8/0x28 (sp 0xfffffe008d7ffe18=
)

  frame 5: 0xfffffff700750788 xfs_buf_lock+0xd0/0x120 (sp 0xfffffe008d7=
ffe38)

  frame 6: 0xfffffff700821b40 xfs_getsb+0x38/0x78 (sp 0xfffffe008d7ffe5=
0)

  frame 7: 0xfffffff70077e230 xfs_trans_getsb+0xe0/0x100 (sp 0xfffffe00=
8d7ffe68)

  frame 8: 0xfffffff7006babc0 xfs_mod_sb+0x88/0x198 (sp 0xfffffe008d7ff=
e88)

  frame 9: 0xfffffff7007a6480 xfs_fs_log_dummy+0x68/0xe0 (sp 0xfffffe00=
8d7ffeb8)

  frame 10: 0xfffffff70079c6c0 xfs_sync_worker+0xe0/0xe8 (sp 0xfffffe00=
8d7ffed8)

  frame 11: 0xfffffff700570a00 xfssyncd+0x240/0x328 (sp 0xfffffe008d7ff=
ef0)

  frame 12: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe008d7fff80=
)

=2E.....



The output said =93INFO: task xfssyncd/md127:1058 blocked for more than
120 seconds=94. What did that mean? I used =93cat /proc/mdstat=94 to se=
e the
state of the raid5. The output was:



Personalities : [raid0] [raid6] [raid5] [raid4]

md127 : active raid5 sdd[3] sdc[2] sdb[1](F) sda[0]

      5860540032 blocks super 1.2 level 5, 128k chunk, algorithm 2 [4/3=
] [U_UU]

        resync=3DPENDING



unused devices: <none>



     The state of the raid5 was =93PENDING=94. I had never seen such a
state of raid5 before. After that, I wrote a program to access the
raid5, there was no response any more. Then I used =93ps aux| task
xfssyncd=94 to see the state of =93xfssyncd=94. Unfortunately, there wa=
s no
response yet. Then I tried =93ps aux=94. There were outputs, but the
program could exit with =93Ctrl+d=94 or =93Ctrl+z=94. And when I tested=
 the
write performance for raid5, I/O errors often occurred. I did not know
why this I/O errors occurred so frequently.

     What was the problem? Can any one help me?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
