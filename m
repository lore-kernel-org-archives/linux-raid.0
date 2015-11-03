From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Tue, 3 Nov 2015 11:08:11 -0500
Message-ID: <5638DBEB.1000904@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
 <56380690.5030600@turmel.org>
 <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
 <56381406.7070608@turmel.org>
 <CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
 <5638336E.4030400@turmel.org>
 <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
 <56383C64.2070807@turmel.org>
 <CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
 <5638B208.1050502@turmel.org>
 <CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/03/2015 08:36 AM, o1bigtenor wrote:
> On Tue, Nov 3, 2015 at 7:09 AM, Phil Turmel <philip@turmel.org> wrote=
:

>> Just add the other drives back into the array in one step, then let =
them
>> recover.
>>
>> mdadm /dev/md0 --add /dev/sdc1 --add /dev/sde1
>>
>> {Use the current names if those aren't correct at this time.}

One caveat -- don't do this part until you've corrected your timeout mi=
smatch
problem, or any latent UREs will break your array again.

>> Although I wouldn't set up a new system quite like this, there's not=
hing
>> wrong with this layout.  It'll be fine like this until the day you w=
ant
>> more space.  A new bigger array would be an appropriate time to rede=
sign.
>=20
> Would you have any suggestions as to how to setup a different array?

I've pasted my most recent media server build's 'lsdrv' report at the e=
nd
of this mail.[1]  Some notes:

1) Paired SSDs for boot and OS.  Boots from EFI SYS partitions containi=
ng
monolithic kernels (EFI stub + kernel + initramfs in one file).  My
maintenance scripts place identical kernels in both boot partitions wit=
hout
running as mirrors.

2) Balance of SSDs is mirrored and operated as an LVM physical volume a=
nd
Volume Group.  This group contains root, home, and swap.  Some space is
left unallocated for emergencies, as LVM can be modified on the fly.

3) Bulk storage is on multiple unpartitioned drives in raid6, which the=
n
forms an LVM physical volume and Volume Group.  Again, some space left
unallocated for emergencies.

> (My NAS box is old server hardware where I am using hardware raid.)
>=20
> Thanking you very much for your generous assistance.
> (copied all of the commands so that anyone accessing the information =
for
> their own use might have some ideas of what to do - - - hopefully als=
o
> achieving a successful result!

You're welcome.

Phil

[1] http://github.com/pturmel/lsdrv

--=20

brutus ~ # lsdrv
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Ser=
ies Chipset Family SATA AHCI Controller (rev 05)
=E2=94=9Cscsi 0:0:0:0 ATA      Crucial_CT250MX2 {15250FDF00E8}
=E2=94=82=E2=94=94sda 232.89g [8:0] Partitioned (gpt)
=E2=94=82 =E2=94=9Csda1 512.00m [8:1] vfat 'BootA' {FDF9-37CE}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /bootA
=E2=94=82 =E2=94=94sda2 232.38g [8:2] MD raid10,near2 (1/2) (w/ sdb2) i=
n_sync 'sysresccd:1' {20b4a43b-447d-dc22-0b96-3f49392b07ec}
=E2=94=82  =E2=94=94md1 232.35g [9:1] MD v1.2 raid10,near2 (2) clean, 5=
12k Chunk {20b4a43b:447ddc22:0b963f49:392b07ec}
=E2=94=82   =E2=94=82                 PV LVM2_member 56.00g used, 176.3=
5g free {WnG1i4-9LYh-6EHe-mMUh-P4hZ-2oNm-R5Vze7}
=E2=94=82   =E2=94=94VG Fast 232.35g 176.35g free {Yp0bW3-xAS5-QQkW-dFS=
f-sGok-6ym0-XR3DLw}
=E2=94=82    =E2=94=9Cdm-4 20.00g [252:4] LV Home ext4 'Home' {08f885a7=
-216c-47cc-8fa1-a25e28ca28b0}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/Fast-Home @ /home
=E2=94=82    =E2=94=9Cdm-2 20.00g [252:2] LV Root ext4 'Root' {d77eb871=
-6366-4501-b3b0-5118daa034c6}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/Fast-Root @ /
=E2=94=82    =E2=94=94dm-3 16.00g [252:3] LV Swap swap 'Swap' {0e6731d8=
-2816-4c54-a6c3-2f6f48ee5544}
=E2=94=9Cscsi 1:0:0:0 ATA      Crucial_CT250MX2 {15250FDEF73C}
=E2=94=82=E2=94=94sdb 232.89g [8:16] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdb1 512.00m [8:17] vfat 'BootB' {FDF9-37CE}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdb1 @ /bootB
=E2=94=82 =E2=94=94sdb2 232.38g [8:18] MD raid10,near2 (0/2) (w/ sda2) =
in_sync 'sysresccd:1' {20b4a43b-447d-dc22-0b96-3f49392b07ec}
=E2=94=82  =E2=94=94md1 232.35g [9:1] MD v1.2 raid10,near2 (2) clean, 5=
12k Chunk {20b4a43b:447ddc22:0b963f49:392b07ec}
=E2=94=82                     PV LVM2_member 56.00g used, 176.35g free =
{WnG1i4-9LYh-6EHe-mMUh-P4hZ-2oNm-R5Vze7}
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=94scsi 5:x:x:x [Empty]
PCI [mpt2sas] 02:00.0 Serial Attached SCSI controller: LSI Logic / Symb=
ios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
=E2=94=9Cscsi 6:0:0:0 ATA      WDC WD40EFRX-68W {WD-WCC4E1648652}
=E2=94=82=E2=94=94sdc 3.64t [8:32] MD raid6 (0/6) (w/ sdd,sde,sdf,sdg,s=
dh) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82  =E2=94=82                PV LVM2_member 12.00t used, 2.55t f=
ree {ezb7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=82  =E2=94=94VG Bulk 14.55t 2.55t free {kOlzy0-xBY6-cIVX-bBgE-0e=
f8-cAEv-c9Ts9l}
=E2=94=82   =E2=94=9Cdm-1 8.00t [252:1] LV Media xfs 'Media' {bb83668f-=
c4a1-44eb-a511-0e55ed10181b}
=E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/Bulk-Media @ /medi=
a/BulkMedia
=E2=94=82   =E2=94=94dm-0 4.00t [252:0] LV MythTV xfs 'MythTV' {644bcdf=
4-8c1d-4eaf-baac-f71ca8d75a6f}
=E2=94=82    =E2=94=94Mounted as /dev/mapper/Bulk-MythTV @ /media/MythT=
V
=E2=94=9Cscsi 6:0:1:0 ATA      WDC WD40EFRX-68W {WD-WCC4E1611663}
=E2=94=82=E2=94=94sdd 3.64t [8:48] MD raid6 (1/6) (w/ sdc,sde,sdf,sdg,s=
dh) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82                   PV LVM2_member 12.00t used, 2.55t free {ezb=
7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=9Cscsi 6:0:2:0 ATA      WDC WD40EFRX-68W {WD-WCC4EJJTZ35U}
=E2=94=82=E2=94=94sde 3.64t [8:64] MD raid6 (2/6) (w/ sdc,sdd,sdf,sdg,s=
dh) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82                   PV LVM2_member 12.00t used, 2.55t free {ezb=
7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=9Cscsi 6:0:3:0 ATA      WDC WD40EFRX-68W {WD-WCC4E1640373}
=E2=94=82=E2=94=94sdf 3.64t [8:80] MD raid6 (4/6) (w/ sdc,sdd,sde,sdg,s=
dh) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82                   PV LVM2_member 12.00t used, 2.55t free {ezb=
7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=9Cscsi 6:0:4:0 ATA      WDC WD40EFRX-68W {WD-WCC4E1631668}
=E2=94=82=E2=94=94sdg 3.64t [8:96] MD raid6 (5/6) (w/ sdc,sdd,sde,sdf,s=
dh) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82                   PV LVM2_member 12.00t used, 2.55t free {ezb=
7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=9Cscsi 6:0:5:0 ATA      WDC WD40EFRX-68W {WD-WCC4E7HT90DE}
=E2=94=82=E2=94=94sdh 3.64t [8:112] MD raid6 (3/6) (w/ sdc,sdd,sde,sdf,=
sdg) in_sync 'sysresccd:2' {2d3f6b75-3a9b-12bc-1582-64533545931b}
=E2=94=82 =E2=94=94md2 14.55t [9:2] MD v1.2 raid6 (6) clean, 16k Chunk =
{2d3f6b75:3a9b12bc:15826453:3545931b}
=E2=94=82                   PV LVM2_member 12.00t used, 2.55t free {ezb=
7fd-6iTr-PhjG-d1EW-xMNC-ThYm-KvTxgg}
=E2=94=94scsi 6:x:x:x [Empty]
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=94loop1 0.00k [7:1] Empty/Unknown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
