From: Per Andreas Buer <perbu@linpro.no>
Subject: poor performance with raid1 / raid0
Date: 18 Jun 2003 14:32:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.

I have two 70GB drives and a 140GB disk set up in RAID1 across the 140GB
drive and a RAID0 built over the 70GB disks. Both the RAID0 and the big
disk are quite fast (transfers ~ 110MB/s and 70MB/s) - but the mirror is
dead slow.

Resync lokes like this: 

md1 : active raid1 md11[2] sdd1[0]
      497856 blocks [2/1] [U_]
      [=========>...........]  recovery = 48.0% (240188/497856)
      finish=15.6min speed=272K/sec

If this configuration unwise in some respect?

Plain 2.4.20-kernel with some fixes (ext3 and ptrace bugs). Adaptec
7899P (rev 08).~

# cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DDYS-T18350M     Rev: SA2A
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: FUJITSU  Model: MAN3735MC        Rev: 0109
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: FUJITSU  Model: MAN3735MC        Rev: 0109
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: SEAGATE  Model: ST3146807LC      Rev: 0004
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: SUPER    Model: GEM354 REV001    Rev: 1.04
  Type:   Processor                        ANSI SCSI revision: 02


-- 
There are only 10 different kinds of people in the world, 
those who understand binary, and those who don't.
