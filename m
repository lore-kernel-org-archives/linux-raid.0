From: Olivier Mueller <om-lists-linux@omx.ch>
Subject: "megaraid mbox: critical hardware error" on new dell poweredge
	1850, suse 9.2, kernel 2.6.8
Date: Sun, 23 Jan 2005 00:23:17 +0100
Message-ID: <1106436197.14192.4.camel@bigapple.omnis.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm trying to get a quite standard "suse linux 9.2" setup working
on a brand new dell poweredge 1850 with 2 scsi disks in raid1 setup.

Installation went completely fine, everything is working. But now (and
every time), after 2-3h of uptime and some high disk I/O load (rsync of
some GB of data), it badly crashes with the following messages:
                                                                       =
                                                                       =
        =20
-------------------------------------------------------------------
megaraid: aborting-1164069 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164069:48[255:0], fw owner
megaraid: aborting-1164070 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164070:59[255:0], fw owner
megaraid: aborting-1164071 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164071:19[255:0], fw owner
megaraid: aborting-1164072 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164072:18[255:0], fw owner
megaraid: aborting-1164073 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164073:20[255:0], fw owner
megaraid: aborting-1164074 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164074:32[255:0], fw owner
megaraid: aborting-1164075 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164075:13[255:0], fw owner
megaraid: aborting-1164076 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164076:8[255:0], fw owner
megaraid: aborting-1164077 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164076:8[255:0], fw owner
megaraid: aborting-1164077 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164077:33[255:0], fw owner
megaraid: aborting-1164078 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164078:60[255:0], fw owner
megaraid: aborting-1164079 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164079:0[255:0], fw owner
megaraid: aborting-1164080 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164080:63[255:0], fw owner
megaraid: aborting-1164081 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164081:44[255:0], fw owner
megaraid: aborting-1164082 cmd=3D2a <c=3D1 t=3D0 l=3D0>
megaraid abort: 1164082:53[255:0], fw owner
megaraid: reseting the host...
megaraid: 14 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 14 commands to complete:180
megaraid mbox: Wait for 14 commands to complete:175
megaraid mbox: Wait for 14 commands to complete:170
megaraid mbox: Wait for 14 commands to complete:165
megaraid mbox: Wait for 14 commands to complete:160
megaraid mbox: Wait for 14 commands to complete:155
megaraid mbox: Wait for 14 commands to complete:150
megaraid mbox: Wait for 14 commands to complete:145
megaraid mbox: Wait for 14 commands to complete:140
megaraid mbox: Wait for 14 commands to complete:135
megaraid mbox: Wait for 14 commands to complete:130
megaraid mbox: Wait for 14 commands to complete:125
megaraid mbox: Wait for 14 commands to complete:120
megaraid mbox: Wait for 14 commands to complete:115
megaraid mbox: Wait for 14 commands to complete:110
megaraid mbox: Wait for 14 commands to complete:105
megaraid mbox: Wait for 14 commands to complete:100
megaraid mbox: Wait for 14 commands to complete:95
megaraid mbox: Wait for 14 commands to complete:90
megaraid mbox: Wait for 14 commands to complete:85
megaraid mbox: Wait for 14 commands to complete:80
megaraid mbox: Wait for 14 commands to complete:75
megaraid mbox: Wait for 14 commands to complete:70
megaraid mbox: Wait for 14 commands to complete:65
megaraid mbox: Wait for 14 commands to complete:60
megaraid mbox: Wait for 14 commands to complete:55
megaraid mbox: Wait for 14 commands to complete:50
megaraid mbox: Wait for 14 commands to complete:45
megaraid mbox: Wait for 14 commands to complete:40
megaraid mbox: Wait for 14 commands to complete:35
megaraid mbox: Wait for 14 commands to complete:30
megaraid mbox: Wait for 14 commands to complete:25
megaraid mbox: Wait for 14 commands to complete:20
megaraid mbox: Wait for 14 commands to complete:15
megaraid mbox: Wait for 14 commands to complete:10
megaraid mbox: Wait for 14 commands to complete:5
megaraid mbox: Wait for 14 commands to complete:0
megaraid mbox: critical hardware error!
megaraid: reseting the host...
megaraid: hw error, cannot reset
megaraid: reseting the host...
megaraid: hw error, cannot reset
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
[...]
scsi: Device offlined - not ready after error recovery: host 0 channel =
1
id 0 lun 0
SCSI error : <0 1 0 0> return code =3D 0x6000000
end_request: I/O error, dev sda, sector 105704481
Buffer I/O error on device sda8, logical block 855051
lost page write due to I/O error on sda8
scsi0 (0:0): rejecting I/O to offline device
Buffer I/O error on device sda8, logical block 855052
lost page write due to I/O error on sda8
Buffer I/O error on device sda8, logical block 855053
lost page write due to I/O error on sda8
Buffer I/O error on device sda8, logical block 855054
lost page write due to I/O error on sda8
Buffer I/O error on device sda8, logical block 855060
lost page write due to I/O error on sda8
SCSI error : <0 1 0 0> return code =3D 0x6000000
end_request: I/O error, dev sda, sector 105704609
scsi0 (0:0): rejecting I/O to offline device
SCSI error : <0 1 0 0> return code =3D 0x6000000
end_request: I/O error, dev sda, sector 105704737
scsi0 (0:0): rejecting I/O to offline device
SCSI error : <0 1 0 0> return code =3D 0x6000000
[...]
scsi0 (0:0): rejecting I/O to offline device
SCSI error : <0 1 0 0> return code =3D 0x6000000
end_request: I/O error, dev sda, sector 105705889
scsi0 (0:0): rejecting I/O to offline device
scsi0 (0:0): rejecting I/O to offline device
scsi0 (0:0): rejecting I/O to offline device
scsi0 (0:0): rejecting I/O to offline device
EXT3-fs error (device sda5) in ext3_reserve_inode_write: IO failure
scsi0 (0:0): rejecting I/O to offline device
scsi0 (0:0): rejecting I/O to offline device
EXT3-fs error (device sda5) in ext3_dirty_inode: IO failure
scsi0 (0:0): rejecting I/O to offline device
ext3_abort called.
EXT3-fs error (device sda5): ext3_journal_start: Detected aborted
journal
Remounting filesystem read-only
[...]
-------------------------------------------------------------------
                                                                       =
                                                                       =
        =20
And then, complete crash, system not reacting anymore.
                                                                       =
                                                                       =
        =20
                                                                       =
                                                                       =
        =20
Not really nice, isn't it? :)  Now I'm trying to find a solution...
In the meantime, if you already saw somthing like that,
feedback/pointers would be very welcome. Merci!  I will try with knoppi=
x
and some *BSD, but the chances that the HW is really bad are low: on
reboot everything runs completely fine, for some hours...

A consistancy check of the RAID array took about 1h, but reported
no problems.

                                                                       =
                                                                       =
       =20
Some more infos:
                                                                       =
                                                                       =
        =20
Loaded modules:
                                                                       =
                                                                       =
        =20
ext3                  128744  5
jbd                    76964  1 ext3
megaraid_mbox          35216  6
megaraid_mm            14752  1 megaraid_mbox
sd_mod                 22144  7
scsi_mod              121412  5 sg,st,sr_mod,megaraid_mbox,sd_mod
                                                                       =
                                                                       =
        =20
                                                                       =
                                                                       =
        =20
# uname -a
Linux pe1850 2.6.8-24.10-smp #1 SMP Wed Dec 22 11:54:27 UTC 2004 i686
i686 i386 GNU/Linux
                                                                       =
                                                                       =
        =20
                                                                       =
                                                                       =
        =20
dmesg messages about scsi subsystem:
                                                                       =
                                                                       =
        =20
SCSI subsystem initialized
megaraid cmm: 2.20.2.0 (Release Date: Thu Aug 19 09:58:33 EDT 2004)
megaraid: 2.20.4.0 (Release Date: Mon Sep 27 22:15:07 EDT 2004)
megaraid: probe new device 0x1028:0x0013:0x1028:0x016c: bus 2:slot
14:func 0
ACPI: PCI interrupt 0000:02:0e.0[A] -> GSI 46 (level, low) -> IRQ 201
megaraid: fw version:[513O] bios version:[H418]
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
  Vendor: PE/PV     Model: 1x2 SCSI BP       Rev: 1.0
  Type:   Processor                          ANSI SCSI revision: 02
scsi[0]: scanning scsi channel 1 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID1   69G  Rev: 513O
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 143114240 512-byte hdwr sectors (73274 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
Attached scsi disk sda at scsi0, channel 1, id 0, lun 0
                                                                       =
                                                                       =
        =20
                                                                       =
                                                                       =
        =20
                                                                       =
                                                                       =
        =20
regards,
Olivier

--=20
_______________________________________________________
 Olivier M=FCller - PGP key ID: 0x0E84D2EA - Switzerland=20
    E-Mail: http://omx.ch/mail/ - AIM/iChat: swix3k


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
