From: Marc MERLIN <marc@merlins.org>
Subject: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 10:14:16 -0800
Message-ID: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, I have 2 drives on a 5x6TB array that have respectively 1 and 8
pending sectors in smart.

Currently, I have a check running, but it will take a while...

echo check > /sys/block/md7/md/sync_action 
md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
      23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [==>..................]  check = 10.5% (615972996/5860390400) finish=4822.1min speed=18125K/sec
      bitmap: 3/44 pages [12KB], 65536KB chunk

My understanding is that eventually it will find the bad sectors that can't be read
and rewrite new ones (block remapping) after reading the remaining 4 drives.

But that may take up to 3 days, just due to how long the check will take and size of the drives
(they are on a SATA port multiplier, so I don't get a lot of speed).

Now, I was trying to see if I could just manually remap the block if I can read it at
least once.
Smart shows:
# 3  Extended offline    Completed: read failure       90%       289         1287409520
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       1

So, trying to read the block until it reads ok and gets remapped, would be great
but that didn't work:
myth:/mnt/btrfs_bigbackup/DS2/backup# dd if=/dev/sdh skip=1287409520 count=1 of=- | more  
dd: reading `/dev/sdh': Input/output error  
0+0 records in  
0+0 records out  
0 bytes (0 B) copied, 9.79192 s, 0.0 kB/s  
myth:/mnt/btrfs_bigbackup/DS2/backup# dd if=/dev/sdh skip=1287409520 count=1 of=- | more  
dd: reading `/dev/sdh': Input/output error  
0+0 records in  
0+0 records out  
0 bytes (0 B) copied, 4.54204 s, 0.0 kB/s  
ata5.04: exception Emask 0x0 SAct 0x1c000 SErr 0x0 action 0x0
ata5.04: failed command: READ FPDMA QUEUED
ata5.04: cmd 60/08:80:70:4f:bc/00:00:4c:00:00/40 tag 16 ncq dma 4096 in
         res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0x409 (media error) <F>
ata5.04: status: { DRDY ERR }
ata5.04: error: { UNC }
ata5.04: configured for UDMA/133
sd 4:4:0:0: [sdh] tag#16 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 4:4:0:0: [sdh] tag#16 Sense Key : Medium Error [current] 
sd 4:4:0:0: [sdh] tag#16 Add. Sense: Unrecovered read error - auto reallocate failed
sd 4:4:0:0: [sdh] tag#16 CDB: Read(16) 88 00 00 00 00 00 4c bc 4f 70 00 00 00 08 00 00
print_req_error: I/O error, dev sdh, sector 1287409520
Buffer I/O error on dev sdh, logical block 160926190, async page read
ata5: EH complete

That's not very unexpected.
However, I can get 
hdparm --read-sector 1287409520 /dev/sdh
to work sometimes.
I've gotten garbage, sometimes 0, and sometimes what seems like good data (and gotten
the same data more than once).


hdparm --read-sector 1287409520 /dev/sdh

/dev/sdh:
reading sector 1287409520: SG_IO: bad/missing sense data, sb[]:  70 00 03 00 00 00 00 0a 40 51 e0 01 11 04 00 00 a0 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00
succeeded

6843 7261 6361 6574 2072 6564 6976 6563
3a73 200a 3120 6d20 6d65 200a 3420 2f20
6564 2f76 6376 302f 200a 3420 7420 7974
200a 3420 7420 7974 0a53 2020 2035 642f
7665 742f 7974 200a 3520 2f20 6564 2f76
6f63 736e 6c6f 0a65 2020 2035 642f 7665
702f 6d74 0a78 2020 2036 706c 200a 3720
7620 7363 200a 3031 6d20 7369 0a63 3120
2033 6e69 7570 0a74 3120 2034 6f73 6e75
2f64 696d 6578 0a72 3120 2034 6f73 6e75
2f64 7364 0a70 3120 2034 6f73 6e75 2f64
7561 6964 0a6f 3120 2034 6f73 6e75 2f64
6461 7073 200a 3132 7320 0a67 3220 2039
6266 200a 3138 7620 6469 6f65 6c34 6e69
7875 310a 3631 6120 736c 0a61 3231 2038
7470 0a6d 3331 2036 7470 0a73 3831 2030
7375 0a62 3831 2039 7375 5f62 6564 6976
6563 320a 3632 6420 6d72 320a 3234 6d20
6465 6169 320a 3334 6820 6469 6172 0a77
3432 2034 6966 6572 6977 6572 320a 3534
6e20 6d76 0a65 3432 2036 656d 0a69 3432
2037 7561 0a78 3432 2038 7362 0a67 3432
2039 6177 6374 6468 676f 320a 3035 7220
6374 320a 3135 6420 7861 320a 3235 6420
6d69 636d 6c74 320a 3335 6e20 6364 6c74
320a 3435 6720 6970 636f 6968 0a70 420a
6f6c 6b63 6420 7665 6369 7365 0a3a 2020
2032 6466 200a 3820 7320 0a64 2020 2039
646d 200a 3131 7320 0a72 3620 2035 6473
200a 3636 7320 0a64 3620 2037 6473 200a
3836 7320 0a64 3620 2039 6473 200a 3037
7320 0a64 3720 2031 6473 310a 3832 7320


Should I stick this data into a 512 byte file and write it back with dd in the right place?
(sadly hdparm –write-sector does not seem to take input and just writes 0's instead)

Does that sound like a good plan, or is there another better way to fix my issue?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
