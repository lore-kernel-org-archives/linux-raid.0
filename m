From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Fri, 14 Nov 2008 18:55:42 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to find out what the root cause of this error/problem is:
https://bugzilla.redhat.com/show_bug.cgi?id=462425

It seems like every week or other week someone else reports this on the 
linux-raid mailing list.

I have enabled debugging in the libata.h file and I find that ata15 is 
constantly being accessed for some reason, why is this?

The first two disks are md/RAID1, the other volume is not being written to or 
read:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000HLFS-0 Rev: 04.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000HLFS-0 Rev: 04.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi10 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi11 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi12 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi13 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD3000GLFS-0 Rev: 03.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi14 Channel: 00 Id: 00 Lun: 00
   Vendor: _NEC     Model: DVD_RW ND-3520A  Rev: 1.04
   Type:   CD-ROM                           ANSI  SCSI revision: 05

What is the purpose of this, what is it doing?
Also in relation to the "ATAPI" message, is that for ATA or ATAPI, e.g. if 
I disable CDROM support, will those messages stop?

Nov 14 18:50:41 p34 kernel: [ 1205.558414] ata_sff_host_intr: ata15: protocol 5 task_state 3
Nov 14 18:50:41 p34 kernel: [ 1205.558420] ata_sff_hsm_move: ata15: protocol 5 task_state 3 (dev_stat 0x51)
Nov 14 18:50:41 p34 kernel: [ 1205.558422] ata_sff_hsm_move: ata15: protocol 5 task_state 4 (dev_stat 0x51)
Nov 14 18:50:41 p34 kernel: [ 1205.558433] ata_scsi_timed_out: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558434] ata_scsi_timed_out: EXIT, ret=0
Nov 14 18:50:41 p34 kernel: [ 1205.558438] ata_scsi_error: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558440] ata_port_flush_task: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558443] ata15: ata_port_flush_task: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.558450] ata_eh_link_autopsy: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558452] atapi_eh_request_sense: ATAPI request sense
Nov 14 18:50:41 p34 kernel: [ 1205.558454] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 18:50:41 p34 kernel: [ 1205.558494] ata_sff_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x60 0x0
Nov 14 18:50:41 p34 kernel: [ 1205.558496] ata_sff_tf_load: device 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.558509] ata_sff_exec_command: ata15: cmd 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.558526] ata_sff_hsm_move: ata15: protocol 6 task_state 1 (dev_stat 0x58)
Nov 14 18:50:41 p34 kernel: [ 1205.558527] atapi_send_cdb: send cdb
Nov 14 18:50:41 p34 kernel: [ 1205.558697] ata_sff_host_intr: ata15: protocol 6 task_state 2
Nov 14 18:50:41 p34 kernel: [ 1205.558703] ata_sff_hsm_move: ata15: protocol 6 task_state 2 (dev_stat 0x58)
Nov 14 18:50:41 p34 kernel: [ 1205.558713] atapi_pio_bytes: ata15: xfering 18 bytes
Nov 14 18:50:41 p34 kernel: [ 1205.558715] __atapi_pio_bytes: data read
Nov 14 18:50:41 p34 kernel: [ 1205.558825] ata_sff_host_intr: ata15: protocol 6 task_state 2
Nov 14 18:50:41 p34 kernel: [ 1205.558831] ata_sff_hsm_move: ata15: protocol 6 task_state 2 (dev_stat 0x50)
Nov 14 18:50:41 p34 kernel: [ 1205.558833] ata_sff_hsm_move: ata15: protocol 6 task_state 3 (dev_stat 0x50)
Nov 14 18:50:41 p34 kernel: [ 1205.558834] ata_sff_hsm_move: ata15: dev 0 command complete, drv_stat 0x50
Nov 14 18:50:41 p34 kernel: [ 1205.558858] ata_port_flush_task: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558860] ata15: ata_port_flush_task: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.558865] ata_eh_link_autopsy: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.558866] ata_eh_recover: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558868] ata_eh_revalidate_and_attach: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558869] ata_eh_recover: EXIT, rc=0
Nov 14 18:50:41 p34 kernel: [ 1205.558870] atapi_qc_complete: ENTER, err_mask 0x0
Nov 14 18:50:41 p34 kernel: [ 1205.558874] ata_scsi_error: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.558882] ata_scsi_dump_cdb: CDB (15:0,0,0) 4a 01 00 00 10 00 00 00 08
Nov 14 18:50:41 p34 kernel: [ 1205.558883] ata_scsi_translate: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.558885] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 18:50:41 p34 kernel: [ 1205.558917] ata_sff_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x8 0x0
Nov 14 18:50:41 p34 kernel: [ 1205.558920] ata_sff_tf_load: device 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.558932] ata_sff_exec_command: ata15: cmd 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.558937] ata_scsi_translate: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.558951] ata_sff_hsm_move: ata15: protocol 6 task_state 1 (dev_stat 0x58)
Nov 14 18:50:41 p34 kernel: [ 1205.558952] atapi_send_cdb: send cdb
Nov 14 18:50:41 p34 kernel: [ 1205.559120] ata_sff_host_intr: ata15: protocol 6 task_state 2
Nov 14 18:50:41 p34 kernel: [ 1205.559126] ata_sff_hsm_move: ata15: protocol 6 task_state 2 (dev_stat 0x58)
Nov 14 18:50:41 p34 kernel: [ 1205.559126] atapi_pio_bytes: ata15: xfering 8 bytes
Nov 14 18:50:41 p34 kernel: [ 1205.559126] __atapi_pio_bytes: data read
Nov 14 18:50:41 p34 kernel: [ 1205.559258] ata_sff_host_intr: ata15: protocol 6 task_state 2
Nov 14 18:50:41 p34 kernel: [ 1205.559264] ata_sff_hsm_move: ata15: protocol 6 task_state 2 (dev_stat 0x50)
Nov 14 18:50:41 p34 kernel: [ 1205.559266] ata_sff_hsm_move: ata15: protocol 6 task_state 3 (dev_stat 0x50)
Nov 14 18:50:41 p34 kernel: [ 1205.559268] ata_sff_hsm_move: ata15: dev 0 command complete, drv_stat 0x50
Nov 14 18:50:41 p34 kernel: [ 1205.559269] atapi_qc_complete: ENTER, err_mask 0x0
Nov 14 18:50:41 p34 kernel: [ 1205.559297] ata_scsi_dump_cdb: CDB (15:0,0,0) 1e 00 00 00 00 00 00 00 00
Nov 14 18:50:41 p34 kernel: [ 1205.559299] ata_scsi_translate: ENTER
Nov 14 18:50:41 p34 kernel: [ 1205.559301] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 18:50:41 p34 kernel: [ 1205.559333] ata_sff_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
Nov 14 18:50:41 p34 kernel: [ 1205.559335] ata_sff_tf_load: device 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.559348] ata_sff_exec_command: ata15: cmd 0xA0
Nov 14 18:50:41 p34 kernel: [ 1205.559352] ata_scsi_translate: EXIT
Nov 14 18:50:41 p34 kernel: [ 1205.559369] ata_sff_hsm_move: ata15: protocol 5 task_state 1 (dev_stat 0x58)
Nov 14 18:50:41 p34 kernel: [ 1205.559371] atapi_send_cdb: send cdb
Nov 14 18:50:41 p34 kernel: [ 1205.559517] ata_sff_host_intr: ata15: protocol 5 task_state 3
Nov 14 18:50:41 p34 kernel: [ 1205.559523] ata_sff_hsm_move: ata15: protocol 5 task_state 3 (dev_stat 0x50)
Nov 14 18:50:41 p34 kernel: [ 1205.559525] ata_sff_hsm_move: ata15: dev 0 command complete, drv_stat 0x50
Nov 14 18:50:41 p34 kernel: [ 1205.559526] atapi_qc_complete: ENTER, err_mask 0x0

