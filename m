From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 17:20:12 +0200
Message-ID: <20110330152011.GA6863@apartia.fr>
References: <20110330080823.GA9167@apartia.fr>
 <4D933435.3010709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D933435.3010709@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 09:46:29AM -0400, Joe Landman wrote:
> On 03/30/2011 04:08 AM, Louis-David Mitterrand wrote:
> >Hi,
> >
> >I am seeing horrific performance on a Dell T610 with a LSISAS2008 (D=
ell
> >H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm rai=
d6.
> >
> >The LSI card is upgraded to the latest 9.00 firmware:
> >http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_=
hbas/internal/sas9211-8i/index.html
> >and the 2.6.38.2 kernel uses the newer mpt2sas driver.
> >
> >On the T610 this command takes 20 minutes:
> >
> >	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  22.64s user 3.34s system 2=
% cpu 20:00.69 total
>=20
> Get rid of the "v" option.  And do an
>=20
> 	sync
> 	echo 3 > /proc/sys/vm/drop_caches
>=20
> before the test.  Make sure your file system is local, and not NFS
> mounted (this could easily explain the timing BTW).

fs are local on both machines.

> Try a similar test on your two units, without the "v" option.  Then

- T610:

	tar -xjf linux-2.6.37.tar.bz2  24.09s user 4.36s system 2% cpu 20:30.9=
5 total

- PE2900:

	tar -xjf linux-2.6.37.tar.bz2  17.81s user 3.37s system 64% cpu 33.062=
 total

Still a huge difference.

> try to get useful information about the MD raid, and file system
> atop this.
>=20
> For our MD raid Delta-V system
>=20
> [root@vault t]# mdadm --detail /dev/md2

- T610:

/dev/md1:
        Version : 1.2
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
     Array Size : 841863168 (802.86 GiB 862.07 GB)
  Used Dev Size : 140310528 (133.81 GiB 143.68 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Mar 30 17:11:22 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : grml:1
           UUID : 1434a46a:f2b751cd:8604803c:b545de8c
         Events : 2532

    Number   Major   Minor   RaidDevice State
       0       8       82        0      active sync   /dev/sdf2
       1       8       50        1      active sync   /dev/sdd2
       2       8        2        2      active sync   /dev/sda2
       3       8       18        3      active sync   /dev/sdb2
       4       8       34        4      active sync   /dev/sdc2
       5       8       66        5      active sync   /dev/sde2
       6       8      114        6      active sync   /dev/sdh2
       7       8       98        7      active sync   /dev/sdg2

- PE2900:

/dev/md1:
        Version : 1.2
  Creation Time : Mon Oct 25 10:17:30 2010
     Raid Level : raid6
     Array Size : 841863168 (802.86 GiB 862.07 GB)
  Used Dev Size : 140310528 (133.81 GiB 143.68 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Mar 30 17:12:17 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : grml:1
           UUID : 224f5112:b8a3c0d2:49361f8f:abed9c4f
         Events : 1507

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
       5       8       82        5      active sync   /dev/sdf2
       6       8       98        6      active sync   /dev/sdg2
       7       8      114        7      active sync   /dev/sdh2

> [root@vault t]# mount | grep md2

- T610:

/dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D262144)

- PE2900:

/dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D262144)

> [root@vault t]# grep md2 /etc/fstab

- T610:

/dev/mapper/cmd1	/		xfs	defaults,inode64,delaylog,logbsize=3D262144	0	0

- PE2900:

/dev/mapper/cmd1	/		xfs	defaults,inode64,delaylog,logbsize=3D262144	0	0

> [root@vault t]# dd if=3D/dev/md2 of=3D/dev/null bs=3D32k count=3D3200=
0

- T610:

32000+0 enregistrements lus
32000+0 enregistrements =E9crits
1048576000 octets (1,0 GB) copi=E9s, 1,70421 s, 615 MB/s

- PE2900:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 2.02322 s, 518 MB/s

> [root@vault t]# dd if=3D/dev/zero of=3D/backup/t/big.file bs=3D32k co=
unt=3D32000

- T610:

32000+0 enregistrements lus
32000+0 enregistrements =E9crits
1048576000 octets (1,0 GB) copi=E9s, 0,870001 s, 1,2 GB/s

- PE2900:

32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 9.11934 s, 115 MB/s

> Some 'lspci -vvv' output,=20

- T610:

02:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2=
008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)
	Subsystem: Dell PERC H200 Integrated
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: I/O ports at fc00 [size=3D256]
	Region 1: Memory at df2b0000 (64-bit, non-prefetchable) [size=3D64K]
	Region 3: Memory at df2c0000 (64-bit, non-prefetchable) [size=3D256K]
	Expansion ROM at df100000 [disabled] [size=3D1M]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [68] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1u=
s
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L=
1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Select=
able De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- C=
omplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [a8] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [c0] MSI-X: Enable- Count=3D15 Masked-
		Vector table: BAR=3D1 offset=3D0000e000
		PBA: BAR=3D1 offset=3D0000f800
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfT=
LP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt+ UnxCmplt+ RxOF- MalfT=
LP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt- UnxCmplt- RxOF+ Malf=
TLP+ ECRC+ UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [138 v1] Power Budgeting <?>
	Kernel driver in use: mpt2sas

- PE2900:

01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 107=
8 (rev 04)
	Subsystem: Dell PERC 6/i Integrated RAID Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ St=
epping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fc480000 (64-bit, non-prefetchable) [size=3D256K]
	Region 2: I/O ports at ec00 [size=3D256]
	Region 3: Memory at fc440000 (64-bit, non-prefetchable) [size=3D256K]
	Expansion ROM at fc300000 [disabled] [size=3D32K]
	Capabilities: [b0] Express (v1) Endppcilib: sysfs_read_vpd: read faile=
d: Connection timed out
oint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 =
unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 2048 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, =
L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive- BWM=
gmt- ABWMgmt-
	Capabilities: [c4] MSI: Enable- Count=3D1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d4] MSI-X: Enable- Count=3D4 Masked-
		Vector table: BAR=3D0 offset=3D0003e000
		PBA: BAR=3D0 offset=3D00fff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [ec] Vital Product Data
		Not readable
	Capabilities: [100 v1] Power Budgeting <?>
	Kernel driver in use: megaraid_sas
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
