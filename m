From: Info@quantum-sci.net
Subject: Re: Help
Date: Thu, 27 Aug 2009 05:47:16 -0700
Message-ID: <200908270547.16549.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <1ed3b9f9d3d17505f68e7a882aef5f7c.squirrel@neil.brown.name> <200908250618.38810.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908250618.38810.Info@quantum-sci.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


OK I think I've resolved this, so don't worry about me anymore.



On Tuesday 25 August 2009 06:18:38 Info@quantum-sci.net wrote:
> On Monday 24 August 2009 16:38:41 you wrote:
> > You'll need to provide a lot more information, starting with
> > kernel log at all relevant times (and don't use 'grep', just cut out
> > of contiguous section of the log including a few lines before and
> > after anything that might be relevant).
> > And "mdadm -E" of any relevant device.
> 
> # mdadm -E /dev/sdb
> mdadm: No md superblock detected on /dev/sdb.
> #
> 
> Aug 22 21:17:17 localhost kernel: [    3.048020] ata4: SATA link down (SStatus 0 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.048037] ata6: SATA link down (SStatus 0 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.048045] ata5: SATA link down (SStatus 0 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.048054] ata3: SATA link down (SStatus 0 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.201035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.201044] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 22 21:17:17 localhost kernel: [    3.204330] ata2.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
> Aug 22 21:17:17 localhost kernel: [    3.204333] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> Aug 22 21:17:17 localhost kernel: [    3.206097] ata1.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
> Aug 22 21:17:17 localhost kernel: [    3.206100] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> Aug 22 21:17:17 localhost kernel: [    3.207345] ata2.00: configured for UDMA/133
> Aug 22 21:17:17 localhost kernel: [    3.211122] ata1.00: configured for UDMA/133
> Aug 22 21:17:17 localhost kernel: [    3.211203] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
> Aug 22 21:17:17 localhost kernel: [    3.211406] sd 0:0:0:0: [sda] 3907029168 512-byte hardware sectors: (2.00 TB/1.81 TiB)
> Aug 22 21:17:17 localhost kernel: [    3.211417] sd 0:0:0:0: [sda] Write Protect is off
> Aug 22 21:17:17 localhost kernel: [    3.211435] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 22 21:17:17 localhost kernel: [    3.211495]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
> Aug 22 21:17:17 localhost kernel: [    3.211568] scsi 1:0:0:0: Direct-Access     ATA      WDC WD20EADS-00S 04.0 PQ: 0 ANSI: 5
> Aug 22 21:17:17 localhost kernel: [    3.211719] sd 1:0:0:0: [sdb] 3907029168 512-byte hardware sectors: (2.00 TB/1.81 TiB)
> Aug 22 21:17:17 localhost kernel: [    3.211728] sd 1:0:0:0: [sdb] Write Protect is off
> Aug 22 21:17:17 localhost kernel: [    3.211746] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 22 21:17:17 localhost kernel: [    3.211798]  sdb:<5>sd 1:0:0:0: Attached scsi generic sg1 type 0
> Aug 22 21:17:17 localhost kernel: [    3.222483]  sdb1 sdb2 sdb3
> Aug 22 21:17:17 localhost kernel: [    3.222744] sd 1:0:0:0: [sdb] Attached SCSI disk
> Aug 22 21:17:17 localhost kernel: [    3.223107]  sda1 sda2 sda3
> Aug 22 21:17:17 localhost kernel: [    3.223321] sd 0:0:0:0: [sda] Attached SCSI disk
> 
> ...
> 
> Aug 22 21:17:17 localhost kernel: [    4.719904] md: md0 stopped.
> Aug 22 21:17:17 localhost kernel: [    4.756229] md: bind<sdb1>
> Aug 22 21:17:17 localhost kernel: [    4.756348] md: bind<sda1>
> Aug 22 21:17:17 localhost kernel: [    4.756365] md: kicking non-fresh sdb1 from array!
> Aug 22 21:17:17 localhost kernel: [    4.756370] md: unbind<sdb1>
> Aug 22 21:17:17 localhost kernel: [    4.761035] md: export_rdev(sdb1)
> Aug 22 21:17:17 localhost kernel: [    4.762357] raid1: raid set md0 active with 1 out of 2 mirrors
> Aug 22 21:17:17 localhost kernel: [    4.768650] md0: bitmap initialized from disk: read 10/10 pages, set 198 bits
> Aug 22 21:17:17 localhost kernel: [    4.768653] created bitmap (151 pages) for device md0
> Aug 22 21:17:17 localhost kernel: [    4.777530] md: md1 stopped.
> Aug 22 21:17:17 localhost kernel: [    4.777616]  md0: unknown partition table
> Aug 22 21:17:17 localhost kernel: [    4.781705] md: bind<sdb2>
> Aug 22 21:17:17 localhost kernel: [    4.781820] md: bind<sda2>
> Aug 22 21:17:17 localhost kernel: [    4.783078] raid10: raid set md1 active with 2 out of 2 devices
> Aug 22 21:17:17 localhost kernel: [    4.791063] md1: bitmap initialized from disk: read 13/13 pages, set 0 bits
> Aug 22 21:17:17 localhost kernel: [    4.791066] created bitmap (193 pages) for device md1
> Aug 22 21:17:17 localhost kernel: [    4.827200] md: md2 stopped.
> Aug 22 21:17:17 localhost kernel: [    4.827294]  md1: unknown partition table
> Aug 22 21:17:17 localhost kernel: [    4.835293] md: bind<sdb3>
> Aug 22 21:17:17 localhost kernel: [    4.835413] md: bind<sda3>
> Aug 22 21:17:17 localhost kernel: [    4.846525] raid10: raid set md2 active with 2 out of 2 devices
> Aug 22 21:17:17 localhost kernel: [    4.862129] md2: bitmap initialized from disk: read 14/14 pages, set 0 bits
> Aug 22 21:17:17 localhost kernel: [    4.862132] created bitmap (223 pages) for device md2
> Aug 22 21:17:17 localhost kernel: [    4.898461]  md2: unknown partition table
> 
> ...
> 
> Hm, how would the superblock have been destroyed?  This is a little disturbing.
> 
> 
> 
> 

