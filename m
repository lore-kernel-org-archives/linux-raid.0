From: Oliver Elphick <olly@lfix.co.uk>
Subject: Linux dpti driver in 2.4 kernel with Adaptec 2400A card
Date: 03 Jan 2003 17:26:12 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1041614772.19602.379.camel@linda.lfix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to install Debian Linux with kernel 2.4.20 on a machine with an
Adaptec 2400A RAID card with 3 40Gb IDE disks attached.  The machine has
no disks other than those connected to this card. 

I am able to boot the system, and the RAID card is recognised (as
/dev/sda) but it cannot be accessed.  I get these messages recorded by
dmesg:

SCSI subsystem driver Revision: 1.00
Loading Adaptec I20 RAID: Version 2.4 Build 5
Detecting Adaptec RAID controllers...
Adaptec I20 RAID controller 0 at f8898000 size=100000 irq=11
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: HIGHPOINT    Device: IDEhpt370    Rev: 00000001
TID 009  Vendor: HIGHPOINT    Device: IDEhpt370    Rev: 00000001
TID 010  Vendor: HIGHPOINT    Device: IDEhpt370    Rev: 00000001
TID 011  Vendor: HIGHPOINT    Device: IDEhpt370    Rev: 00000001
TID 519  Vendor: ADAPTEC      Device: RAID-5       Rev: 370L
scsi0 : Vendor: Adaptec  Model: 2400A            FW:370L
  Vendor: ADAPTEC   Model: RAID-5            Rev: 370L
  Type:   Direct-Access                      ANSI SCSI revision: 02
[scsi1: Adaptec SCSI card]
[scsi2: IDE-SCSI]
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 156327936 512-byte hdwr sectors (80040 MB)
Partition check:
 sda:<4>dpti0: SCSI Data Protect-Device (0,0,0) hba_status=0x0, dev_status=0x2, cmd=0x28
dpti0: Trying to reset device
dpti0: Device reset not supported
dpti0: Bus reset: SCSI Bus 0: tid: 11
dpti0: Bus reset success.
scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
SCSI disk error:  host 0 channel 0 id 0 lun 0 return code = 30002
 I/O error: dev 08:00, sector 0
 I/O error: dev 08:00, sector 2
 I/O error: dev 08:00, sector 0
 unable to read partition table

I can't find any previous references to this problem and I'm stuck. 
What can I do to get this working, please?

-- 
Oliver Elphick                                Oliver.Elphick@lfix.co.uk
Isle of Wight, UK                             http://www.lfix.co.uk/oliver
GPG: 1024D/3E1D0C1C: CA12 09E0 E8D5 8870 5839  932A 614D 4C34 3E1D 0C1C
                 ========================================
     "I love them that love me; and those that seek me early
      shall find me."                Proverbs 8:17 

