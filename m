From: "Gabor Z. Papp" <gzp@myhost.mynet>
Subject: IDE Software RAID5 with linux 2.4.20-pre
Date: Sat, 28 Sep 2002 10:59:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020928085932.GG511@gzp2.gzp.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

lo lo all,

I would like build a raid5 host with 4 IC35L060AVVA07-0
disks, running 0 spare disks.
Created 1-1 full size partition on each disk.
I have found Neil's wonderful mdadm tool, and ran the command:

mdadm -C /dev/md0 -l5 -x0 -n4 /dev/hd[aceg]1 2>&1 | tee log.raid5create

Here comes the logfile:

mdadm: /dev/hda1 appears to contain an ext2fs file system
    size=60050936K  mtime=Thu Jan  1 00:00:00 1970
mdadm: /dev/hdc1 appears to contain an ext2fs file system
    size=60050936K  mtime=Thu Jan  1 00:00:00 1970
mdadm: /dev/hdc1 appear to be part of a raid array:
    level=5 devices=4 ctime=Sat Sep 28 08:01:58 2002
mdadm: /dev/hde1 appears to contain an ext2fs file system
    size=60051568K  mtime=Thu Jan  1 00:00:00 1970
mdadm: /dev/hde1 appear to be part of a raid array:
    level=5 devices=4 ctime=Sat Sep 28 08:01:58 2002
mdadm: /dev/hdg1 appears to contain an ext2fs file system
    size=60051568K  mtime=Thu Jan  1 00:00:00 1970
mdadm: /dev/hdg1 appear to be part of a raid array:
    level=5 devices=4 ctime=Sat Sep 28 08:01:58 2002
Continue creating array? mdadm: array /dev/md0 started.

Well, I started... dmesg says:


ICH2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x9800-0x9807, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x9808-0x980f, BIOS settings: hdc:DMA, hdd:pio

PDC20268: (U)DMA Burst Bit ENABLED Primary MASTER Mode Secondary MASTER Mode.
    ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xa408-0xa40f, BIOS settings: hdg:pio, hdh:pio
hda: IC35L060AVVA07-0, ATA DISK drive
hdc: IC35L060AVVA07-0, ATA DISK drive
hde: IC35L060AVVA07-0, ATA DISK drive
hdg: IC35L060AVVA07-0, ATA DISK drive

blk: queue c037efa4, I/O limit 4095Mb (mask 0xffffffff)
hda: 120103200 sectors (61493 MB) w/1863KiB Cache, CHS=7476/255/63, UDMA(100)
blk: queue c037f308, I/O limit 4095Mb (mask 0xffffffff)
hdc: 120103200 sectors (61493 MB) w/1863KiB Cache, CHS=119150/16/63, UDMA(100)
blk: queue c037f66c, I/O limit 4095Mb (mask 0xffffffff)
hde: 120103200 sectors (61493 MB) w/1863KiB Cache, CHS=119150/16/63, UDMA(33)
blk: queue c037f9d0, I/O limit 4095Mb (mask 0xffffffff)
hdg: 120103200 sectors (61493 MB) w/1863KiB Cache, CHS=119150/16/63, UDMA(33)

md: bind<ide/host0/bus0/target0/lun0/part1,1>
md: bind<ide/host0/bus1/target0/lun0/part1,2>
md: bind<ide/host2/bus0/target0/lun0/part1,3>
md: bind<ide/host2/bus1/target0/lun0/part1,4>
md: ide/host2/bus1/target0/lun0/part1's event counter: 00000000
md: ide/host2/bus0/target0/lun0/part1's event counter: 00000000
md: ide/host0/bus1/target0/lun0/part1's event counter: 00000000
md: ide/host0/bus0/target0/lun0/part1's event counter: 00000000
md0: max total readahead window set to 768k
md0: 3 data-disks, max readahead per data-disk: 256k
raid5: spare disk ide/host2/bus1/target0/lun0/part1
raid5: device ide/host2/bus0/target0/lun0/part1 operational as raid disk 2
raid5: device ide/host0/bus1/target0/lun0/part1 operational as raid disk 1
raid5: device ide/host0/bus0/target0/lun0/part1 operational as raid disk 0
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 4339kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target0/lun0/part1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus0/target0/lun0/part1
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target0/lun0/part1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus0/target0/lun0/part1
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
md: updating md0 RAID superblock on device
md: ide/host2/bus1/target0/lun0/part1 [events: 00000001]<6>(write) ide/host2/bus1/target0/lun0/part1's sb offset: 60051456
md: recovery thread got woken up ...
md0: resyncing spare disk ide/host2/bus1/target0/lun0/part1 to replace failed disk
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target0/lun0/part1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus0/target0/lun0/part1
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target0/lun0/part1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus0/target0/lun0/part1
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
md: using 124k window, over a total of 60050816 blocks.
md: ide/host2/bus0/target0/lun0/part1 [events: 00000001]<6>(write) ide/host2/bus0/target0/lun0/part1's sb offset: 60051456
md: ide/host0/bus1/target0/lun0/part1 [events: 00000001]<6>(write) ide/host0/bus1/target0/lun0/part1's sb offset: 60051456
md: ide/host0/bus0/target0/lun0/part1 [events: 00000001]<6>(write) ide/host0/bus0/target0/lun0/part1's sb offset: 60050816

Personalities : [raid5] 
read_ahead 1024 sectors
md0 : active raid5 ide/host2/bus1/target0/lun0/part1[4] ide/host2/bus0/target0/lun0/part1[2] ide/host0/bus1/target0/lun0/part1[1] ide/host0/bus0/target0/lun0/part1[0]
      180154368 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [>....................]  recovery =  3.3% (2023372/60051456) finish=27.4min speed=35245K/sec
unused devices: <none>

Seems like one of the disks failed? Or what happening?
