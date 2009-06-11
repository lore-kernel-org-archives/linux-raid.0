From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: slow mdadm reshape, normal? lspci/iostat info
Date: Thu, 11 Jun 2009 23:11:35 +0200
Message-ID: <20090611211135.GX30825@rlogin.dk>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk> <20090611081909.GA16250@cthulhu.home.robinhill.me.uk> <20090611160741.GG30825@rlogin.dk> <20090611194552.GQ30825@rlogin.dk> <4A316E1B.9060607@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kUoBhQsr7LsiFken"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A316E1B.9060607@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--kUoBhQsr7LsiFken
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Here is some more info,=20
I only have an old Matrox card installed on the PCI bus and the Silicon con=
troller
 except for the reserved motherboard stuff.

mfs:/sys/block/md0/md# lspci -tv
-[0000:00]-+-00.0  nVidia Corporation C55 Host Bridge
           +-00.1  nVidia Corporation C55 Memory Controller
           +-00.2  nVidia Corporation C55 Memory Controller
           +-00.3  nVidia Corporation C55 Memory Controller
           +-00.4  nVidia Corporation C55 Memory Controller
           +-00.5  nVidia Corporation C55 Memory Controller
           +-00.6  nVidia Corporation C55 Memory Controller
           +-00.7  nVidia Corporation C55 Memory Controller
           +-01.0  nVidia Corporation C55 Memory Controller
           +-01.1  nVidia Corporation C55 Memory Controller
           +-01.2  nVidia Corporation C55 Memory Controller
           +-01.3  nVidia Corporation C55 Memory Controller
           +-01.4  nVidia Corporation C55 Memory Controller
           +-01.5  nVidia Corporation C55 Memory Controller
           +-01.6  nVidia Corporation C55 Memory Controller
           +-02.0  nVidia Corporation C55 Memory Controller
           +-02.1  nVidia Corporation C55 Memory Controller
           +-02.2  nVidia Corporation C55 Memory Controller
           +-09.0  nVidia Corporation MCP55 Memory Controller
           +-0a.0  nVidia Corporation MCP55 LPC Bridge
           +-0a.1  nVidia Corporation MCP55 SMBus
           +-0b.0  nVidia Corporation MCP55 USB Controller
           +-0b.1  nVidia Corporation MCP55 USB Controller
           +-0d.0  nVidia Corporation MCP55 IDE
           +-0e.0  nVidia Corporation MCP55 SATA Controller
           +-0e.1  nVidia Corporation MCP55 SATA Controller
           +-0e.2  nVidia Corporation MCP55 SATA Controller
           +-0f.0-[0000:01]--+-06.0  Matrox Graphics, Inc. MGA 1064SG [Myst=
ique]
           |                 \-07.0  Silicon Image, Inc. SiI 3114 [SATALink=
/SATARaid] Serial ATA Controller
           +-11.0  nVidia Corporation MCP55 Ethernet
           +-12.0  nVidia Corporation MCP55 Ethernet
           \-13.0-[0000:02]--
mfs:/sys/block/md0/md# cat /proc/interrupts ; sleep 5 ; cat /proc/interrupt=
s=20
           CPU0       CPU1      =20
  0:       1028          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge   =20
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 17:   51373228          0   IO-APIC-fasteoi   sata_sil
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 21:  186438698          0   IO-APIC-fasteoi   ohci_hcd:usb1, sata_nv
 22:  207200954          0   IO-APIC-fasteoi   sata_nv
 23:  169890292          0   IO-APIC-fasteoi   eth0, sata_nv
NMI:          0          0   Non-maskable interrupts
LOC:   42237922   42340136   Local timer interrupts
RES:    1091032    2105741   Rescheduling interrupts
CAL:         15        252   Function call interrupts
TLB:        729       1726   TLB shootdowns
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0
           CPU0       CPU1      =20
  0:       1028          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge   =20
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 17:   51374643          0   IO-APIC-fasteoi   sata_sil
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 21:  186443797          0   IO-APIC-fasteoi   ohci_hcd:usb1, sata_nv
 22:  207205898          0   IO-APIC-fasteoi   sata_nv
 23:  169894870          0   IO-APIC-fasteoi   eth0, sata_nv
NMI:          0          0   Non-maskable interrupts
LOC:   42239176   42341394   Local timer interrupts
RES:    1091032    2105741   Rescheduling interrupts
CAL:         15        252   Function call interrupts
TLB:        729       1731   TLB shootdowns
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0
mfs:/sys/block/md0/md# cat /proc/interrupts ; sleep 5 ; cat /proc/interrupts
           CPU0       CPU1
  0:       1028          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 17:   51375118          0   IO-APIC-fasteoi   sata_sil
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 21:  186445519          0   IO-APIC-fasteoi   ohci_hcd:usb1, sata_nv
 22:  207207539          0   IO-APIC-fasteoi   sata_nv
 23:  169896360          0   IO-APIC-fasteoi   eth0, sata_nv
NMI:          0          0   Non-maskable interrupts
LOC:   42239623   42341843   Local timer interrupts
RES:    1091032    2105741   Rescheduling interrupts
CAL:         15        252   Function call interrupts
TLB:        729       1733   TLB shootdowns
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0
           CPU0       CPU1
  0:       1028          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 17:   51376507          0   IO-APIC-fasteoi   sata_sil
 20:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 21:  186450537          0   IO-APIC-fasteoi   ohci_hcd:usb1, sata_nv
 22:  207212461          0   IO-APIC-fasteoi   sata_nv
 23:  169900833          0   IO-APIC-fasteoi   eth0, sata_nv
NMI:          0          0   Non-maskable interrupts
LOC:   42240876   42343099   Local timer interrupts
RES:    1091032    2105741   Rescheduling interrupts
CAL:         15        252   Function call interrupts
TLB:        729       1736   TLB shootdowns
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0


mfs:/sys/block/md0/md# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  reshape =3D 53.6% (78655=
4368/1465138496) finish=3D1539.3min speed=3D7346K/sec

unused devices: <none>=20

mfs:/sys/block/md0/md# iostat -x
Linux 2.6.29.3mfs_diskless (mfs)        2009-06-11      _i686_

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,15    0,00   15,02    6,20    0,00   78,62

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda            3658,88  1632,25   79,87   42,53  4495,42 13414,83   146,32 =
    1,71   13,93   6,21  75,98
sdb              25,52  1103,10   29,03   63,48 13357,33  9345,37   245,39 =
    0,21    2,22   1,77  16,38
sdc            3678,72  1635,67   69,49   39,37  4573,18 13417,55   165,26 =
    2,28   20,88   7,95  86,55
sdd              22,27  1129,86   27,74   37,01 10844,92  9348,14   311,85 =
    0,84   13,00   8,48  54,92
sde            3588,14  1620,34  164,06   55,60  4601,96 13422,60    82,06 =
    0,75    3,40   1,30  28,57
sdf            3586,83  1619,85  164,88   55,59  4597,31 13418,48    81,72 =
    0,71    3,20   1,26  27,76
sdg            3581,97  1618,89  166,54   56,64  4571,90 13418,94    80,61 =
    0,65    2,90   1,19  26,50
sdh            3572,31  1617,86  166,54   57,87  4494,17 13420,49    79,83 =
    0,62    2,78   1,17  26,26
sdi            1484,87  3755,18   67,92   89,13 12432,27  5341,24   113,17 =
    0,74    4,73   2,17  34,13
md0               0,00     0,00    0,01  696,47     0,09 24223,68    34,78 =
    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,01  696,47     0,07 24223,68    34,78 =
   14,91   21,41   0,25  17,37
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     8,00 =
    0,00    7,95   3,21   0,00



On Thu, 11 Jun 2009, John Robinson wrote:

> On 11/06/2009 20:45, Michael Ole Olsen wrote:
> [...]
>> it seems there is 21ms wait time for each request due to this pci slowne=
ss. (await is in miliseconds)
>>
>> might be the controller that isnt so fast to do simultaneous read and=20
>> writes, perhaps because its NCQ support might be bad?
>>
>> so I don't really have more ideas, except to buy a new controller card f=
rom a better brand (Adaptec) :(
>
> I have no personal experience of SIL SATA cards, but they've been =20
> mentioned before as being behind slowness. It's also possible something =
=20
> else on your PCI bus is choking things, so before you go and blow lots =
=20
> of real money on a better brand, what else is on your PCI bus? Please =20
> tell me the output of `lspci -tv` and the contents of /proc/interrupts =
=20
> twice (before and after a short delay, e.g. `cat /proc/interrupts ; =20
> sleep 5 ; cat /proc/interrupts`).
>
> Cheers,
>
> John.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--kUoBhQsr7LsiFken
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKMXMGAAoJECXlragqp/ZI654P/2TKyc3NGctvfXW8LVdzLHOb
D1lxZADIkYJTMOYEpm9/Ohlc7lLIhSzdTM01Wf3XEuwNeJ1Jr9m7QLyL+F02Xljk
p8ny19+6W2AHtcWQlmY8zkynnjEGA8di1sUHNaen60ArkFz33qThC0SoPmHQe1Zo
Z8dYAGmn/Jre1yYdqhNVbDEMbs/NVJJ/pRspGCQNsENwJzdXBcg6wj+UPPjFFMPz
eVqmpIuNzKmwtUSb5UCdHUmMkEJtiyizsYCks/YoDD8FOSBEdwAVD4S0uZFtkWyB
CtG5KV65aqHlJXhuzdxxOs3ws8kd9FT5kZ5pmJ4QeqB+D597Iz/bdJXYRrSR1Ro0
X7Sb/IbsWM3TBf/58KxNVnlaEtRJNQifiqeX3Sllcd4RMtM18/r8yZcIRxm2KbTZ
9RNMkrsD4Vt7mTdQt7MD0w7uJI3loZ6M2qCz4w4tyZsxli9SfDu2OOGjcfo0ALXY
Kas6wq78osnRYeZP7hRbK/EWWcab8LHR/C67vUxEK6gAaottTz5S2EI+hW1Bmthp
jtsyZ/68nGHS4A/zL4uXidgNuzQkC0FlIR8keJhtikEsj2VcJaGyLtscX2uJuyfW
m/iFYhbKgkTYhsjIvfUCCZFySZdCWBZhbG7cDTu/ihdbqqZupwDyKBBPQfzJPO2D
aQUgVRBGNaxgFiYqRT63
=kbFH
-----END PGP SIGNATURE-----

--kUoBhQsr7LsiFken--
