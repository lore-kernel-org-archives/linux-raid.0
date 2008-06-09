From: Richard Scobie <richard@sauce.co.nz>
Subject: Reallocating sd device
Date: Mon, 09 Jun 2008 12:17:48 +1200
Message-ID: <484C76AC.801@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Testing a 16 SATA drive (/dev/sd[c-r]1), md RAID, with drives installed 
in a hotswap SAS/SATA enclosure.

Failed out /dev/sdd1, ejected the drive from the enclosure, reinserted 
it and the system added it back as /dev/sds:

Jun  9 11:24:37 flash2 kernel: mptsas: ioc0: removing sata device, 
channel 0, id 30, phy 5
Jun  9 11:24:37 flash2 kernel: sd 4:0:1:0: [sdd] Synchronizing SCSI cache

Jun  9 11:24:37 flash2 kernel: sd 4:0:1:0: [sdd] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK

Jun  9 11:26:38 flash2 kernel: mptsas: ioc0: attaching sata device, 
channel 0, id 30, phy 5

Jun  9 11:26:38 flash2 kernel: scsi 4:0:17:0: Direct-Access     ATA 
  WDC WD7500AYYS-0 4G30 PQ: 0 ANSI: 5

Jun  9 11:26:38 flash2 kernel: sd 4:0:17:0: [sds] 1465149168 512-byte 
hardware sectors (750156 MB)

Rebooting shows the offline drive back as /dev/sdd.

Is there a safe, (OK to do on a mounted, active array), way of changing 
the sds back to sdd, prior to adding it back into the array, without 
having to reboot?

Regards,

Richard
