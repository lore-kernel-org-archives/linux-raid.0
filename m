From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Problems with 2.6.14.3
Date: Sun, 04 Dec 2005 22:17:25 +0900
Message-ID: <4392EC65.7080500@tequila.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58837C2ED5338803206A0F44"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58837C2ED5338803206A0F44
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I have a debian/testing box running with the latest upgrade. mdadm is
1.12.0 and I upgrade the kernel frmo 2.6.12.3 to 2.6.14.3 and then
things went very wrong.

Because of a planned power down in our building I upgraded the kernel,
shut it down and got a bunch of SCSI timeout warnings. I rebooted after
that, the raid was fine, but then during the next shutdown it kicked out
a disk.

Today (Sunday) I restarted the box and things went very bad from
beginning. It started the raid in degraded mode (3 running 1 missing)
and during mount I just got a lot of SCSI error messages.

Well, after a lot of trying I lost all the raid drives (all marked F). I
started to check the HDs with badblocks if there is something wrong when
a co-worker told me that the first shutdown with the old kernel worked
fine and that 2.6.14.3 might be the issues. So I rebooted with the old
kernel, and yes, now it re-creates the raid with the first kicked out
disk. it works fine, no SCSI errors.

My RAID-5 looks like this: Adaptec ASC-29320LP U320 with 4 externel
160GB HDs as a RAID-5, no spare.

Does anyone have similar experiences, or should I report this to the
kernel ML?

SCSI error message below:
Dec  4 17:45:58 ramen kernel: [  872.482452] scsi0:0:1:0: Attempting to
queue an ABORT message:CDB: 0x28 0x0 0x0 0x0 0x3 0x3f 0x0 0x4 0x0 0x0
Dec  4 17:45:58 ramen kernel: [  872.498791] scsi0: At time of recovery,
card was not paused
Dec  4 17:45:58 ramen kernel: [  872.515195] >>>>>>>>>>>>>>>>>> Dump
Card State Begins <<<<<<<<<<<<<<<<<
Dec  4 17:45:58 ramen kernel: [  872.515198] scsi0: Dumping Card State
at program address 0x19b Mode 0x33
Dec  4 17:45:58 ramen kernel: [  872.550152] Card was paused
Dec  4 17:45:58 ramen kernel: [  872.568043] HS_MAILBOX[0x0]
INTCTL[0x80]:(SWTMINTMASK)
Dec  4 17:45:58 ramen kernel: [  872.586812] SEQINTSTAT[0x0]
SAVED_MODE[0x11] DFFSTAT[0x31]:(CURRFIFO_1|FIFO0FREE|FIFO1FREE)
Dec  4 17:45:58 ramen kernel: [  872.606831]
SCSISIGI[0x4]:(P_DATAOUT|BSYI) SCSIPHASE[0x0]
Dec  4 17:45:58 ramen kernel: [  872.627219] SCSIBUS[0xc2]
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
Dec  4 17:45:58 ramen kernel: [  872.648146] SCSISEQ0[0x0]
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
Dec  4 17:45:58 ramen kernel: [  872.669507] SEQCTL0[0x10]:(FASTMODE)
SEQINTCTL[0x0]
Dec  4 17:45:59 ramen kernel: [  872.691244]
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)
Dec  4 17:45:59 ramen kernel: [  872.713450] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0]
Dec  4 17:45:59 ramen kernel: [  872.736030] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0]:(HIPERR|HIZERO)
Dec  4 17:45:59 ramen kernel: [  872.759377]
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Dec  4 17:45:59 ramen kernel: [  872.783150] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0]
Dec  4 17:45:59 ramen kernel: [  872.807400] LQOSTAT0[0x0] LQOSTAT1[0x0]
LQOSTAT2[0x80]
Dec  4 17:45:59 ramen kernel: [  872.831766]
Dec  4 17:45:59 ramen kernel: [  872.831767] SCB Count = 8 CMDS_PENDING
= 6 LASTSCB 0x6 CURRSCB 0x6 NEXTSCB 0x0
Dec  4 17:45:59 ramen kernel: [  872.881425] qinstart = 159 qinfifonext
= 159
Dec  4 17:45:59 ramen kernel: [  872.881428] QINFIFO:
Dec  4 17:45:59 ramen kernel: [  872.907428] WAITING_TID_QUEUES:
Dec  4 17:45:59 ramen kernel: [  872.956264]        0 ( 0x3 )
Dec  4 17:45:59 ramen kernel: [  872.980695]        2 ( 0x5 )
Dec  4 17:45:59 ramen kernel: [  873.004636] Pending list:
Dec  4 17:45:59 ramen kernel: [  873.004947]   5 FIFO_USE[0x6]
SCB_CONTROL[0x40]:(DISCENB)
Dec  4 17:45:59 ramen kernel: [  873.051973] SCB_SCSIID[0x27]
Dec  4 17:45:59 ramen kernel: [  873.052350]   3 FIFO_USE[0x0]
SCB_CONTROL[0x40]:(DISCENB)
Dec  4 17:45:59 ramen kernel: [  873.099136] SCB_SCSIID[0x7]
Dec  4 17:45:59 ramen kernel: [  873.099503]   7 FIFO_USE[0x0]
SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB)
Dec  4 17:45:59 ramen kernel: [  873.147364] SCB_SCSIID[0x7]
Dec  4 17:45:59 ramen kernel: [  873.147731]   0 FIFO_USE[0x0]
SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB)
Dec  4 17:45:59 ramen kernel: [  873.197085] SCB_SCSIID[0x37]
Dec  4 17:45:59 ramen kernel: [  873.197462]   1 FIFO_USE[0x0]
SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB)
Dec  4 17:45:59 ramen kernel: [  873.247564] SCB_SCSIID[0x17]
Dec  4 17:45:59 ramen kernel: [  873.247939] Total 5
Dec  4 17:45:59 ramen kernel: [  873.297844] Kernel Free SCB list: 6 4 2
Dec  4 17:45:59 ramen kernel: [  873.322901] Sequencer Complete
DMA-inprog list:
Dec  4 17:45:59 ramen kernel: [  873.347887] Sequencer Complete list:
Dec  4 17:45:59 ramen kernel: [  873.372757] Sequencer DMA-Up and
Complete list:
Dec  4 17:45:59 ramen kernel: [  873.397838]
Dec  4 17:45:59 ramen kernel: [  873.397839] scsi0: FIFO0 Free, LONGJMP
== 0x80ff, SCB 0x0
Dec  4 17:45:59 ramen kernel: [  873.447886]
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
Dec  4 17:45:59 ramen kernel: [  873.474158] SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Dec  4 17:45:59 ramen kernel: [  873.500551]
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0]
Dec  4 17:45:59 ramen kernel: [  873.526472] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO)
Dec  4 17:45:59 ramen kernel: [  873.552460] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0
Dec  4 17:45:59 ramen kernel: [  873.578595] CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Dec  4 17:45:59 ramen kernel: [  873.579140] scsi0: FIFO1 Free, LONGJMP
== 0x81ec, SCB 0x1
Dec  4 17:45:59 ramen kernel: [  873.628866]
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
Dec  4 17:45:59 ramen kernel: [  873.654578] SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Dec  4 17:46:00 ramen kernel: [  873.680447]
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0]
Dec  4 17:46:00 ramen kernel: [  873.706135] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO)
Dec  4 17:46:00 ramen kernel: [  873.732248] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0
Dec  4 17:46:00 ramen kernel: [  873.757961] CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Dec  4 17:46:00 ramen kernel: [  873.758503] LQIN: 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Dec  4 17:46:00 ramen kernel: [  873.809687] scsi0: LQISTATE = 0x0,
LQOSTATE = 0x0, OPTIONMODE = 0x42
Dec  4 17:46:00 ramen kernel: [  873.835664] scsi0: OS_SPACE_CNT = 0x20
MAXCMDCNT = 0x0
Dec  4 17:46:00 ramen kernel: [  873.861473]
SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
Dec  4 17:46:00 ramen kernel: [  873.887289] CCSCBCTL[0x0]
Dec  4 17:46:00 ramen kernel: [  873.912834] scsi0: REG0 == 0x1, SINDEX
= 0x1e0, DINDEX = 0xe1
Dec  4 17:46:00 ramen kernel: [  873.938608] scsi0: SCBPTR == 0x6,
SCB_NEXT == 0xff40, SCB_NEXT2 == 0x3
Dec  4 17:46:00 ramen kernel: [  873.964455] CDB 28 0 0 0 7 3f
Dec  4 17:46:00 ramen kernel: [  873.989932] STACK: 0x0 0x0 0x0 0x0 0x0
0x0 0x184 0x19b
Dec  4 17:46:00 ramen kernel: [  873.990750] <<<<<<<<<<<<<<<<< Dump Card
State Ends >>>>>>>>>>>>>>>>>>

-- 
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]

--------------enig58837C2ED5338803206A0F44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDkuxnjBz/yQjBxz8RAqFlAKC9glQWq3LCVUdWdHYO4jmRTEUJMACgz2tq
ZYVtcr1YmCY4ostHGyhNnMM=
=08qM
-----END PGP SIGNATURE-----

--------------enig58837C2ED5338803206A0F44--
