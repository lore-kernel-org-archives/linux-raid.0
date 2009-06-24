From: Neil Brown <neilb@suse.de>
Subject: Re: help please
Date: Wed, 24 Jun 2009 19:28:14 +1000
Message-ID: <19009.61870.937267.380076@notabene.brown>
References: <OF4A69EBA3.01FB682F-ON852575DE.0051EB68-802575DE.00521E0F@pt.com>
	<efbcb4173b866e6407787256ba1ea15a.squirrel@neil.brown.name>
	<OF9266A41E.AA29AB09-ON852575DE.007396F5-802575DE.007403D4@pt.com>
	<19009.40318.938280.11068@notabene.brown>
	<OF57F66995.3162498E-ON852575DF.002B0896-802575DF.002C4606@pt.com>
	<571272403b4a19fc0ac3e14ed5cbf7f4.squirrel@neil.brown.name>
	<OF8294A8F0.9741D566-ON852575DF.0030728E-802575DF.00307250@pt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ken Rowe on Wednesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: Ken Rowe <klr@pt.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Wed, June 24, 2009 6:03 pm, Ken Rowe wrote:
> > Morning Neil,
> >
> > Sorry for being so vague
> > Here is the data from the raid once the drives are built and all is well,
> > then if I remove the power and restart the raid  a drive is removed and
> > that is what I am trying to understand what /how/why does mdadm remove the
> > drive. What  makes the discussion to remove the drive and why. Is it just
> > it was not able to read /write to the drive, or is there some logic to how
> > this is determined.

Thanks for all the extra detail.

It looks like the array is being assembled by mdadm from the initrd,
though it might be from a regular init script, I cannot be 100%
certain.

In either case, there is no apparent attempt to include sdb at that
point.
The most likely explanation is that the mdadm.conf in question (either
in initrd or root filesystem) has an error and is not causing all the
drives to be found.

If this is true, then a normal reboot will have the same effect as the
power loss.

First I would try to re-create the initrd and see if the problem goes
away.
If it doesn't then post the mdadm.conf so we can have a look at it.

Also it might be instructive to stop the array, then
  mdadm --assemble /dev/md0 -vv

as the messages might be helpful.

NeilBrown



> >
> >
> > Welcome to NexusWare (810p0698.51 092300)
> >
> > (none) login: rot
> > Password:
> > Login incorrect
> >
> > (none) login: root
> > CPC5900: cat /proc/mdstat
> > Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> > md0 : active raid1 sda[0] sdb[1]
> >       390711296 blocks [2/2] [UU]
> >       [>....................]  resync =  2.8% (11151360/390711296)
> > finish=366.5min speed=17256K/sec
> >
> > unused devices: <none>
> > CPC5900: mdadm --monitor --mail=sysadmin --delay=300 /dev/md0
> > making device /dev/sata0(2048)
> > Alert [/dev/sata0]: DriveInserted ((null))
> > making device /dev/sata1(2064)
> > Alert [/dev/sata1]: DriveInserted ((null))
> > Alert [/dev/md0]: Rebuild20 ((null))
> > Alert [/dev/md0]: Rebuild40 ((null))
> > Alert [/dev/md0]: Rebuild60 ((null))
> > Alert [/dev/md0]: Rebuild80 ((null))
> > Alert [/dev/md0]: RebuildFinished ((null))
> >
> > CPC5900: cat /proc/mdstat
> > Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> > md0 : active raid1 sda[0] sdb[1]
> >       390711296 blocks [2/2] [UU]
> >
> > CPC5900: mdadm -D --scan /dev/md0
> > /dev/md0:
> >         Version : 00.90.03
> >   Creation Time : Tue Jun 23 16:51:39 2009
> >      Raid Level : raid1
> >      Array Size : 390711296 (372.61 GiB 400.09 GB)
> >   Used Dev Size : 390711296 (372.61 GiB 400.09 GB)
> >    Raid Devices : 2
> >   Total Devices : 2
> > Preferred Minor : 0
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Wed Jun 24 00:29:09 2009
> >           State : clean
> >  Active Devices : 2
> > Working Devices : 2
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >            UUID : 2d43feef:7c252d04:df893f9e:a6918d0a
> >          Events : 0.8
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8        0        0      active sync   /dev/sda
> >        1       8       16        1      active sync   /dev/sdb
> > CPC5900:
> >
> >
> >
> > This is what I get when the raid has lost power
> >
> >
> > CPC5900: mdadm -D --scan /dev/md0
> > /dev/md0:
> >         Version : 00.90.03
> >   Creation Time : Tue Jun 23 16:51:39 2009
> >      Raid Level : raid1
> >      Array Size : 390711296 (372.61 GiB 400.09 GB)
> >   Used Dev Size : 390711296 (372.61 GiB 400.09 GB)
> >    Raid Devices : 2
> >   Total Devices : 1
> > Preferred Minor : 0
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Wed Jun 24 08:55:55 2009
> >           State : clean, degraded
> >  Active Devices : 1
> > Working Devices : 1
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >            UUID : 2d43feef:7c252d04:df893f9e:a6918d0a
> >          Events : 0.12
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       0        0        0      removed
> >        1       8       16        1      active sync   /dev/sdb
> > CPC5900:
> >
> > This is the messages log
> >
> > Jun 24 08:50:49 (none) kernel: aic94xx: device 0000:00:02.0: SAS addr 0,
> > PCBA SN, 0 phys, 8 enabled phys, flash present, BIOS not present0
> > Jun 24 08:50:53 (none) login[837]: ROOT LOGIN on `ttyS0'
> > Jun 24 08:50:57 (none) kernel: md: linear personality registered for 
> level
> > -1
> > Jun 24 08:50:57 (none) kernel: md: raid0 personality registered for 
> level
> > 0
> > Jun 24 08:50:57 (none) kernel: md: raid1 personality registered for 
> level
> > 1
> > Jun 24 08:50:57 (none) kernel: raid5: measuring checksumming speed
> > Jun 24 08:50:57 (none) kernel:    8regs     :   672.000 MB/sec
> > Jun 24 08:50:57 (none) kernel:    8regs_prefetch:   592.000 MB/sec
> > Jun 24 08:50:57 (none) kernel:    32regs    :   948.000 MB/sec
> > Jun 24 08:50:57 (none) kernel:    32regs_prefetch:   823.000 MB/sec
> > Jun 24 08:50:57 (none) kernel: raid5: using function: 32regs (948.000
> > MB/sec)
> > Jun 24 08:50:58 (none) kernel: raid6: int32x1    162 MB/s
> > Jun 24 08:50:58 (none) kernel: raid6: int32x2    224 MB/s
> > Jun 24 08:50:58 (none) kernel: raid6: int32x4    274 MB/s
> > Jun 24 08:50:58 (none) kernel: raid6: int32x8    234 MB/s
> > Jun 24 08:50:58 (none) kernel: raid6: using algorithm int32x4 (274 MB/s)
> > Jun 24 08:50:58 (none) kernel: md: raid6 personality registered for 
> level
> > 6
> > Jun 24 08:50:58 (none) kernel: md: raid5 personality registered for 
> level
> > 5
> > Jun 24 08:50:58 (none) kernel: md: raid4 personality registered for 
> level
> > 4
> > Jun 24 08:51:00 (none) kernel: ata1.00: ATA-7, max UDMA/133, 781422768
> > sectors:LBA48 NCQ (depth 31/32)
> > Jun 24 08:51:00 (none) kernel: ata1.00: ata1: dev 0 multi count 0
> > Jun 24 08:51:00 (none) kernel: ata1.00: configured for UDMA/133
> > Jun 24 08:51:00 (none) kernel: scsi 0:0:0:0: Direct-Access     ATA WDC
> > WD4000YS-01M 07.0 PQ: 0 ANSI: 5
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] 781422768 512-byte
> > hardware sectors (400088 MB)
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] Write Protect is off
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> > read cache: enabled, doesn't support DPO or FUA
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] 781422768 512-byte
> > hardware sectors (400088 MB)
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] Write Protect is off
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> > read cache: enabled, doesn't support DPO or FUA
> > Jun 24 08:51:00 (none) kernel:  sda: unknown partition table
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: [sda] Attached SCSI disk
> > Jun 24 08:51:00 (none) kernel: sd 0:0:0:0: Attached scsi generic sg0 
> type
> > 0
> > Jun 24 08:51:00 (none) kernel: ata2.00: ATA-7, max UDMA/133, 781422768
> > sectors: LBA48 NCQ (depth 31/32)
> > Jun 24 08:51:00 (none) kernel: ata2.00: ata2: dev 0 multi count 0
> > Jun 24 08:51:00 (none) kernel: ata2.00: configured for UDMA/133
> > Jun 24 08:51:00 (none) kernel: scsi 0:0:1:0: Direct-Access     ATA WDC
> > WD4000YS-01M 07.0 PQ: 0 ANSI: 5
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] 781422768 512-byte
> > hardware sectors (400088 MB)
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] Write Protect is off
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] Write cache: enabled,
> > read cache: enabled, doesn't support DPO or FUA
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] 781422768 512-byte
> > hardware sectors (400088 MB)
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] Write Protect is off
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] Write cache: enabled,
> > read cache: enabled, doesn't support DPO or FUA
> > Jun 24 08:51:00 (none) kernel:  sdb: unknown partition table
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: [sdb] Attached SCSI disk
> > Jun 24 08:51:00 (none) kernel: sd 0:0:1:0: Attached scsi generic sg1 
> type
> > 0
> > Jun 24 08:51:02 (none) kernel: md: md0 stopped.
> > Jun 24 08:51:02 (none) kernel: md: bind<sdb>
> > Jun 24 08:51:02 (none) kernel: raid1: raid set md0 active with 1 out of 
> 2
> > mirrors
> > Jun 24 08:51:02 (none) kernel: md: md1 stopped.
> > Jun 24 08:51:02 (none) kernel: md: md2 stopped.
> > Jun 24 08:51:02 (none) kernel: md: md3 stopped.
> > Jun 24 08:51:02 (none) kernel: md: md4 stopped.
> > Jun 24 08:51:02 (none) kernel: Zircon PM driver v1.24
> > Jun 24 08:51:02 (none) kernel: Intel Strata Flash v%I%
> > Jun 24 08:51:03 (none) kernel: eth0: IBM emac, MAC 00:80:50:04:93:90
> > Jun 24 08:51:03 (none) kernel: eth0: Found Generic MII PHY (0x06)
> > Jun 24 08:51:03 (none) kernel: eth1: IBM emac, MAC 00:80:50:04:93:91
> > Jun 24 08:51:03 (none) kernel: eth1: Found Generic MII PHY (0x07)
> > Jun 24 08:51:03 (none) kernel: IBM OCP EMAC Ethernet driver v@(#)
> > ibm_ocp_enet.c 1.36@(#)
> > Jun 24 08:51:03 (none) kernel: ADDRCONF(NETDEV_UP): eth0: link is not
> > ready
> > Jun 24 08:51:05 (none) kernel: eth0: Link is Up
> > Jun 24 08:51:05 (none) kernel: eth0: Speed: 100, Full duplex.
> > Jun 24 08:51:05 (none) kernel: ADDRCONF(NETDEV_CHANGE): eth0: link 
> becomes
> > ready
> > Jun 24 08:51:05 (none) kernel: eth1: Link is Up
> > Jun 24 08:51:05 (none) kernel: eth1: Speed: 100, Full duplex.
> > Jun 24 08:52:03 (none) dhcpcd[1722]: timed out waiting for a valid DHCP
> > server response
> > Jun 24 08:52:03 (none) kernel: eth1: Speed: 100, Full duplex.
> > Jun 24 08:52:03 (none) xinetd[1768]: xinetd Version 2.3.14 started with 
> no
> > options compiled in.
> > Jun 24 08:52:03 (none) xinetd[1768]: Started working: 2 available 
> services
> > Jun 24 08:52:03 (none) nfsd[1773]: nfssvc: writing fds to kernel failed:
> > errno 0 (Success)
> > Jun 24 08:52:03 (none) nfsd[1773]: nfssvc: writing fds to kernel failed:
> > errno 0 (Success)
> > Jun 24 08:52:03 (none) smbd[1780]: [2009/06/24 08:52:03, 0]
> > passdb/pdb_smbpasswdc:startsmbfilepwent(241)
> > Jun 24 08:52:03 (none) smbd[1780]:   startsmbfilepwent_internal: file
> > /var/lib/samba/private/smbpasswd did not exist. File successfully 
> created.
> > Jun 24 08:52:03 (none) ejectord: version 2.10
> > Jun 24 08:55:37 (none) telnetd[1792]: doit: getaddrinfo: Name or service
> > not known
> > Jun 24 08:55:39 (none) login[1793]: ROOT LOGIN on `ttyp0' from
> > `10.81.10.134'
> > CPC5900:
> >
> > to add the removed drive I use, but first check via mdstat which drive 
> is
> > active.
> >
> > mdadm /dev/md0 --add /dev/sda
> >
> > Should the raid survive a power down and recover if the drive is not bad 
> ?
> >
> >
> > Ken Rowe
> > Senior Systems engineering consultant
> > Tel:     +44 1908 646000
> > Mob:  +44 7753 937959
> > Email: klr@pt.com
> >
> 
