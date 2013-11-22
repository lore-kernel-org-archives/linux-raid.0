From: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
Subject: ARC-1120 and MD very sloooow
Date: Fri, 22 Nov 2013 12:13:16 +0100
Message-ID: <1385118796.8091.31.camel@bews002.euractiv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got a bunch of servers with a ARC-1120 8-Port PCI-X to SATA RAID
Controller.


        $ lspci -d 17d3:1120 -v
        02:0e.0 RAID bus controller: Areca Technology Corp. ARC-1120 8-Port PCI-X to SATA RAID Controller
        	Subsystem: Areca Technology Corp. ARC-1120 8-Port PCI-X to SATA RAID Controller
        	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping+ SERR- FastB2B- DisINTx-
        	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        	Latency: 32 (32000ns min), Cache Line Size: 32 bytes
        	Interrupt: pin A routed to IRQ 16
        	Region 0: Memory at fceff000 (32-bit, non-prefetchable) [size=4K]
        	Region 2: Memory at fdc00000 (32-bit, prefetchable) [size=4M]
        	[virtual] Expansion ROM at fce00000 [disabled] [size=64K]
        	Capabilities: [c0] Power Management version 2
        		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        	Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
        		Address: 0000000000000000  Data: 0000
        	Capabilities: [e0] PCI-X non-bridge device
        		Command: DPERE+ ERO- RBC=1024 OST=8
        		Status: Dev=02:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=1024 DMOST=4 DMCRS=32 RSCEM- 266MHz- 533MHz-
        	Kernel driver in use: arcmsr


They are all running Debian Wheezy (7) and kernel versoin 3.2.


        $ uname -srvmo
        Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux


I don't want to use the hardware RAID capabilities of this SATA
controller, I prefer to bet on Linux's software RAID. So I configured
the drives in the ARC-1120 controller as just a bunch of drives (JBOD)
and then use mdadm to create some RAID arrays.

For instance:


        $ cat /proc/mdstat 
        Personalities : [raid1] [raid10] 
        md3 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]
              7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
              
        md2 : active raid1 sda4[0] sdb4[1]
              67893176 blocks super 1.2 [2/2] [UU]
              
        md1 : active raid1 sda3[0] sdb3[1]
              4205556 blocks super 1.2 [2/2] [UU]
              
        md0 : active raid1 sda2[0] sdb2[1]
              509940 blocks super 1.2 [2/2] [UU]
              
        unused devices: <none>
        
        # mount
        [...]
        /dev/md3 on /srv type xfs (rw,nosuid,nodev,noexec,noatime,attr2,delaylog,inode64,sunit=2048,swidth=4096,noquota)
        
        # xfs_info /dev/md3 
        meta-data=/dev/md3               isize=256    agcount=32, agsize=30523648 blks
                 =                       sectsz=512   attr=2
        data     =                       bsize=4096   blocks=976755712, imaxpct=5
                 =                       sunit=256    swidth=512 blks
        naming   =version 2              bsize=4096   ascii-ci=0
        log      =internal               bsize=4096   blocks=476936, version=2
                 =                       sectsz=512   sunit=8 blks, lazy-count=1
        realtime =none                   extsz=4096   blocks=0, rtextents=0


The issue is that disk access is very slow and I cannot spot why. Here
is some data when I try to access the file system.


        # dd if=/dev/zero of=/srv/test.zero bs=512K count=6000
        6000+0 records in
        6000+0 records out
        3145728000 bytes (3.1 GB) copied, 82.2142 s, 38.3 MB/s
        
        # dd if=/srv/store/video/test.zero of=/dev/null
        6144000+0 records in
        6144000+0 records out
        3145728000 bytes (3.1 GB) copied, 12.0893 s, 260 MB/s
        
        First run:
        $ time ls /srv/files
        [...]
        real	9m59.609s
        user	0m0.408s
        sys	0m0.176s
        
        Second run:
        $ time ls /srv/files
        [...]
        real	0m0.257s
        user	0m0.108s
        sys	0m0.088s
        
        $ ls -l /srv/files | wc -l
        17189


I guess the controller is what's is blocking here as I encounter the
issue only on servers where it is installed. I tried many settings like
enabling or disabling cache but nothing changed.

Any advise would be appreciated.

--
Jimmy



