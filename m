From: Marc Pinhede <marc.pinhede@inria.fr>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Tue, 17 Nov 2015 13:30:45 +0100 (CET)
Message-ID: <402863738.19875205.1447763445794.JavaMail.zimbra@inria.fr>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr> <5633B79D.4000009@turmel.org> <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr> <563B5AEB.5020006@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563B5AEB.5020006@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Clement Parisot <clement.parisot@inria.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Thanks for your answer. Update since our last mail:
We saved many data thanks to long and boring rsyncs, with countless reb=
oots: during rsync, sometime a drive was suddenly considered in 'failed=
' state by the array. The array was still active (with 13 or 12 / 16 di=
sks) but 100% of files failed with I/O after that. We were then forced =
to reboot, reassemble the array and restart rsync.
During those long operation, we have been advised to re-tighten our sto=
rage bay's screws (carri bay). And this is were the magic happened. Aft=
er screwing them back on, no more problem with drive considered failed.=
 We only had 4 file copy failures with I/O, but it didn't correspond to=
 a drive failing in the array (still working with 14/16 drives).
We can't guarantee than the problem is fixed, but we moved from about 1=
0 reboot a day to 5 days of work without problems.

We now plan to reset and re-introduce one by one the two drive that wer=
e not recognize by the array, and let the array synchronize, rewriting =
data on those drive. Does it sounds like a good idea to you, or do you =
think it may fails due to some errors?


> Yes, with latent Unrecoverable Read Errors, you will need properly
> working redundancy and no timeout mismatches.  I recommend you
> repeatedly use --assemble --force to restore your array, skip the las=
t
> file that failed, and continue copying critical files as possible.
>=20
> You should at least run this command every reboot until you replace y=
our
> drives or otherwise script the work-arounds:
>=20
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

Thanks for the tip. Made at every reboot, but we still had failures.

> > We still have two drives that were not physicaly removed, so that
> > theorically contains datas, but that appears as spare in mdadm
> > --examine, probably because of the 're-add' attempt we made.
>=20
> The only way to activate these, I think, is to re-create your array.
> That is a last resort after you've copied everything possible with th=
e
> forced assembly state.

We will keep this as a last resort, but with updates above, we should n=
ot have to use this.


> >> Did you run "mdadm --stop /dev/md2" first?  That would explain the
> >> "busy" reports.
>=20
> [trim /]
>=20
> There's *something* holding access to sda and sdb -- please obtain an=
d
> run "lsdrv" [1] and post its output.
>=20

PCI [aacraid] 01:00.0 RAID bus controller: Adaptec AAC-RAID (rev 09)
=E2=94=9Cscsi 0:0:0:0 Adaptec  LogicalDrv 0     {6F7C0529}
=E2=94=82=E2=94=94sda 930.99g [8:0] MD raid6 (16) inactive 'ftalc2.nanc=
y.grid5000.fr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=9Cscsi 0:0:2:0 Adaptec  LogicalDrv 2     {81A40529}
=E2=94=82=E2=94=94sdb 930.99g [8:16] MD raid6 (2/16) (w/ sdc,sdd,sde,sd=
g,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.f=
r:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82  =E2=94=82                PV LVM2_member 12.70t used, 33.84g =
free {G8XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=82  =E2=94=94VG baie 12.73t 33.84g free {7krzHX-Lz48-7ibY-RKTb-I=
ZaX-zZlz-8ju8MM}
=E2=94=82   =E2=94=9Cdm-3 4.50t [253:3] LV data1 ext4 {83ddded0-d457-4f=
dc-8eab-9fbb2c195bdc}
=E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/baie-data1 @ /expo=
rt/data1
=E2=94=82   =E2=94=9Cdm-4 200.00g [253:4] LV grid5000 ext4 {c442ffe7-b3=
4d-42c8-800d-ba21bf2ed8ec}
=E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/baie-grid5000 @ /e=
xport/grid5000
=E2=94=82   =E2=94=94dm-2 8.00t [253:2] LV home ext4 {c4ebcfd0-e5c2-442=
0-8a03-d0d5799cf747}
=E2=94=82    =E2=94=94Mounted as /dev/mapper/baie-home @ /export/home
=E2=94=9Cscsi 0:0:3:0 Adaptec  LogicalDrv 3     {156214AB}
=E2=94=82=E2=94=94sdc 930.99g [8:32] MD raid6 (3/16) (w/ sdb,sdd,sde,sd=
g,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.f=
r:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:4:0 Adaptec  LogicalDrv 4     {82C40529}
=E2=94=82=E2=94=94sdd 930.99g [8:48] MD raid6 (4/16) (w/ sdb,sdc,sde,sd=
g,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.f=
r:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:5:0 Adaptec  LogicalDrv 5     {8F341529}
=E2=94=82=E2=94=94sde 930.99g [8:64] MD raid6 (5/16) (w/ sdb,sdc,sdd,sd=
g,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.f=
r:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:6:0 Adaptec  LogicalDrv 6     {5E4C1529}
=E2=94=82=E2=94=94sdf 930.99g [8:80] MD raid6 (16) inactive 'ftalc2.nan=
cy.grid5000.fr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=9Cscsi 0:0:7:0 Adaptec  LogicalDrv 7     {FF88E4AC}
=E2=94=82=E2=94=94sdg 930.99g [8:96] MD raid6 (7/16) (w/ sdb,sdc,sdd,sd=
e,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.f=
r:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:8:0 Adaptec  LogicalDrv 8     {84B41529}
=E2=94=82=E2=94=94sdh 930.99g [8:112] MD raid6 (8/16) (w/ sdb,sdc,sdd,s=
de,sdg,sdi,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.=
fr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:9:0 Adaptec  LogicalDrv 9     {70C41529}
=E2=94=82=E2=94=94sdi 930.99g [8:128] MD raid6 (9/16) (w/ sdb,sdc,sdd,s=
de,sdg,sdh,sdj,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000.=
fr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:10:0 Adaptec  LogicalDrv 10    {897976AC}
=E2=94=82=E2=94=94sdj 930.99g [8:144] MD raid6 (10/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdk,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:11:0 Adaptec  LogicalDrv 11    {6DEC1529}
=E2=94=82=E2=94=94sdk 930.99g [8:160] MD raid6 (11/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdj,sdl,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:12:0 Adaptec  LogicalDrv 12    {71142529}
=E2=94=82=E2=94=94sdl 930.99g [8:176] MD raid6 (12/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdj,sdk,sdm,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:13:0 Adaptec  LogicalDrv 13    {14242529}
=E2=94=82=E2=94=94sdm 930.99g [8:192] MD raid6 (13/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdj,sdk,sdl,sdn,sdo,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:14:0 Adaptec  LogicalDrv 14    {2D382529}
=E2=94=82=E2=94=94sdn 930.99g [8:208] MD raid6 (14/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdj,sdk,sdl,sdm,sdo,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=9Cscsi 0:0:15:0 Adaptec  LogicalDrv 15    {B4542529}
=E2=94=82=E2=94=94sdo 930.99g [8:224] MD raid6 (15/16) (w/ sdb,sdc,sdd,=
sde,sdg,sdh,sdi,sdj,sdk,sdl,sdm,sdn,sdp) in_sync 'ftalc2.nancy.grid5000=
=2Efr:2' {2d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
=E2=94=82 =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2=
, 128k Chunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
=E2=94=82                   PV LVM2_member 12.70t used, 33.84g free {G8=
XPQ1-E3y0-82Wz-UUpg-hGWC-UvHm-pAbi30}
=E2=94=94scsi 0:0:16:0 Adaptec  LogicalDrv 1     {8E940529}
 =E2=94=94sdp 930.99g [8:240] MD raid6 (1/16) (w/ sdb,sdc,sdd,sde,sdg,s=
dh,sdi,sdj,sdk,sdl,sdm,sdn,sdo) in_sync 'ftalc2.nancy.grid5000.fr:2' {2=
d0b91e8-a0b1-0f4c-3fa2-85f93198a918}
  =E2=94=94md2 12.73t [9:2] MD v1.2 raid6 (16) clean DEGRADEDx2, 128k C=
hunk {2d0b91e8:a0b10f4c:3fa285f9:3198a918}
                    PV LVM2_member 12.70t used, 33.84g free {G8XPQ1-E3y=
0-82Wz-UUpg-hGWC-UvHm-pAbi30}
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB S=
ATA AHCI Controller (rev 09)
=E2=94=9Cscsi 1:0:0:0 ATA      Hitachi HDP72503 {GEAC34RF2T8SLA}  =20
=E2=94=82=E2=94=94sdq 298.09g [65:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csdq1 285.00m [65:1] MD raid1 (0/2) (w/ sdr1) in_sync=
 'ftalc2:0' {791b53cf-4800-7f45-1dc0-ae5f8cedc958}
=E2=94=82 =E2=94=82=E2=94=94md0 284.99m [9:0] MD v1.2 raid1 (2) clean {=
791b53cf:48007f45:1dc0ae5f:8cedc958}
=E2=94=82 =E2=94=82 =E2=94=82                 ext3 {135f2572-81a4-462f-=
8ce6-11ee0c9a8074}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md0 @ /boot
=E2=94=82 =E2=94=94sdq2 297.81g [65:2] MD raid1 (0/2) (w/ sdr2) in_sync=
 'ftalc2:1' {819ab09a-8402-6762-9e1f-6278f5bbda51}
=E2=94=82  =E2=94=94md1 297.81g [9:1] MD v1.2 raid1 (2) clean {819ab09a=
:84026762:9e1f6278:f5bbda51}
=E2=94=82   =E2=94=82                 PV LVM2_member 22.24g used, 275.5=
7g free {XGX5zq-EcVb-nbK7-BKc6-cxMy-7oe0-B5DKJW}
=E2=94=82   =E2=94=94VG rootvg 297.81g 275.57g free {oWuOGP-c6Bt-lreb-Y=
Wwf-Kkwt-eqUG-fmgRuf}
=E2=94=82    =E2=94=9Cdm-0 4.66g [253:0] LV dom0-root ext3 {dbf8f715-dc=
51-40a2-9d7d-db2d24cc3aba}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/rootvg-dom0--root=
 @ /
=E2=94=82    =E2=94=9Cdm-1 1.86g [253:1] LV dom0-swap swap {82f0fe85-34=
ae-4da7-afb3-e161396a3494}
=E2=94=82    =E2=94=9Cdm-6 952.00m [253:6] LV dom0-tmp ext3 {31585de5-6=
1d1-4e7b-977d-ba6df01b3a4a}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/rootvg-dom0--tmp =
@ /tmp
=E2=94=82    =E2=94=9Cdm-5 4.79g [253:5] LV dom0-var ext3 {c0826eb6-e53=
5-4d57-a501-9dfb503732e0}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/rootvg-dom0--var =
@ /var
=E2=94=82    =E2=94=94dm-7 10.00g [253:7] LV false_root ext4 {519238c6-=
22d4-4d1b-88ed-9af71aed8a88}
=E2=94=9Cscsi 2:0:0:0 ATA      Hitachi HDP72503 {GEAC34RF2T8G0A}  =20
=E2=94=82=E2=94=94sdr 298.09g [65:16] Partitioned (dos)
=E2=94=82 =E2=94=9Csdr1 285.00m [65:17] MD raid1 (1/2) (w/ sdq1) in_syn=
c 'ftalc2:0' {791b53cf-4800-7f45-1dc0-ae5f8cedc958}
=E2=94=82 =E2=94=82=E2=94=94md0 284.99m [9:0] MD v1.2 raid1 (2) clean {=
791b53cf:48007f45:1dc0ae5f:8cedc958}
=E2=94=82 =E2=94=82                   ext3 {135f2572-81a4-462f-8ce6-11e=
e0c9a8074}
=E2=94=82 =E2=94=94sdr2 297.81g [65:18] MD raid1 (1/2) (w/ sdq2) in_syn=
c 'ftalc2:1' {819ab09a-8402-6762-9e1f-6278f5bbda51}
=E2=94=82  =E2=94=94md1 297.81g [9:1] MD v1.2 raid1 (2) clean {819ab09a=
:84026762:9e1f6278:f5bbda51}
=E2=94=82                     PV LVM2_member 22.24g used, 275.57g free =
{XGX5zq-EcVb-nbK7-BKc6-cxMy-7oe0-B5DKJW}
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=9Cscsi 5:x:x:x [Empty]
=E2=94=94scsi 6:x:x:x [Empty]
PCI [ata_piix] 00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB=
 IDE Controller (rev 09)
=E2=94=9Cscsi 7:x:x:x [Empty]
=E2=94=94scsi 8:x:x:x [Empty]
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=94loop7 0.00k [7:7] Empty/Unknown


> >> Before proceeding, please supply more information:
> >>=20
> >> for x in /dev/sd[a-p] ; mdadm -E $x ; smartctl -i -A -l scterc $x =
;
> >> done
> >>=20
> >> Paste the output inline in your response.
> >=20
> >=20
> > I couldn't get smartctl to work successfully. The version supported
> > on debian squeeze doesn't support aacraid.
>=20
> > I tried from a chroot in a debootstrap with a more recent debian
> > version, but only got:
> >=20
> > # smartctl --all -d aacraid,0,0,0 /dev/sda
>=20
> > smartctl 6.4 2014-10-07 r4002 [x86_64-linux-2.6.32-5-amd64] (local
> > build)
>=20
> > Copyright (C) 2002-14, Bruce Allen, Christian Franke,
> > www.smartmontools.org
> >=20
> > Smartctl open device: /dev/sda [aacraid_disk_00_00_0] [SCSI/SAT]
> > failed: INQUIRY [SAT]: aacraid result: 0.0 =3D 22/0
>=20
> It's possible the 0,0,0 isn't correct.  The output of lsdrv would hel=
p
> with this.
>=20
> Also, please use the smartctl options I requested.  '--all' omits the
> scterc information I want to see, and shows a bunch of data I don't n=
eed
> to see.  If you want all possible data for your own use, '-x' is the
> correct option.

Yes, I will use this option to filter if I get smartctl to work.

>=20
> [trim /]
>=20
> It's very important that we get a map of drive serial numbers to curr=
ent
> device names and the "Device Role" from "mdadm --examine".  As an
> alternative, post the output of "ls -l /dev/disk/by-id/".  This is
> critical information for any future re-create attempts.

lrwxrwxrwx 1 root root  9 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8G0A -> ../../sdr
lrwxrwxrwx 1 root root 10 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8G0A-part1 -> ../../sdr1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8G0A-part2 -> ../../sdr2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8SLA -> ../../sdq
lrwxrwxrwx 1 root root 10 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8SLA-part1 -> ../../sdq1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 ata-Hitachi_HDP725032GLA360_GEAC=
34RF2T8SLA-part2 -> ../../sdq2
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-baie-data1 -> ../../dm-3
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-baie-grid5000 -> ../../d=
m-4
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-baie-home -> ../../dm-2
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-rootvg-dom0--root -> ../=
=2E./dm-0
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-rootvg-dom0--swap -> ../=
=2E./dm-1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-rootvg-dom0--tmp -> ../.=
=2E/dm-6
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-rootvg-dom0--var -> ../.=
=2E/dm-5
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-name-rootvg-false_root -> ../=
=2E./dm-7
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-7krzHXLz487ibYRKTbIZ=
aXzZlz8ju8MM4QRfpRFoJ9EJDP7Nar3SLNj53t7urGbk -> ../../dm-4
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-7krzHXLz487ibYRKTbIZ=
aXzZlz8ju8MMICvtF5UTbncSUMC9f0PyK5zHGmmEa8GD -> ../../dm-2
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-7krzHXLz487ibYRKTbIZ=
aXzZlz8ju8MMkzJJGdeMc0QDg4B1r2hsq5bCnS7Ktk4u -> ../../dm-3
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-oWuOGPc6BtlrebYWwfKk=
wteqUGfmgRufCqs0FclHYC6O5RNOSEpeRZ3xJ3kXCOG0 -> ../../dm-7
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-oWuOGPc6BtlrebYWwfKk=
wteqUGfmgRufGm4mzDQtuUTShTEyWgXEo8BXt1d2S4Qu -> ../../dm-1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-oWuOGPc6BtlrebYWwfKk=
wteqUGfmgRufMGhnq5OTr3pyXgyc2CqDE5ibq9xaOSUf -> ../../dm-5
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-oWuOGPc6BtlrebYWwfKk=
wteqUGfmgRufOD5FJuWOVLYk7wnRPOvlQOLEb0zffl2X -> ../../dm-0
lrwxrwxrwx 1 root root 10 Nov 12 10:19 dm-uuid-LVM-oWuOGPc6BtlrebYWwfKk=
wteqUGfmgRufuMkGACbZV71GDBcRVxXnAMf7NkWFWezw -> ../../dm-6
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-name-ftalc2:0 -> ../../md0
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-name-ftalc2:1 -> ../../md1
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-name-ftalc2.nancy.grid5000.fr=
:2 -> ../../md2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-uuid-2d0b91e8:a0b10f4c:3fa285=
f9:3198a918 -> ../../md2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-uuid-791b53cf:48007f45:1dc0ae=
5f:8cedc958 -> ../../md0
lrwxrwxrwx 1 root root  9 Nov 12 10:19 md-uuid-819ab09a:84026762:9e1f62=
78:f5bbda51 -> ../../md1
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_0_6F7C0=
529 -> ../../sda
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_10_8979=
76AC -> ../../sdj
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_11_6DEC=
1529 -> ../../sdk
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_12_7114=
2529 -> ../../sdl
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_13_1424=
2529 -> ../../sdm
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_14_2D38=
2529 -> ../../sdn
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_15_B454=
2529 -> ../../sdo
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_1_8E940=
529 -> ../../sdp
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_2_81A40=
529 -> ../../sdb
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_3_15621=
4AB -> ../../sdc
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_4_82C40=
529 -> ../../sdd
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_5_8F341=
529 -> ../../sde
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_6_5E4C1=
529 -> ../../sdf
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_7_FF88E=
4AC -> ../../sdg
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_8_84B41=
529 -> ../../sdh
lrwxrwxrwx 1 root root  9 Nov 17 10:18 scsi-SAdaptec_LogicalDrv_9_70C41=
529 -> ../../sdi
lrwxrwxrwx 1 root root  9 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8G0A -> ../../sdr
lrwxrwxrwx 1 root root 10 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8G0A-part1 -> ../../sdr1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8G0A-part2 -> ../../sdr2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8SLA -> ../../sdq
lrwxrwxrwx 1 root root 10 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8SLA-part1 -> ../../sdq1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 scsi-SATA_Hitachi_HDP7250_GEAC34=
RF2T8SLA-part2 -> ../../sdq2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 wwn-0x5000cca34de737a4 -> ../../=
sdr
lrwxrwxrwx 1 root root 10 Nov 12 10:19 wwn-0x5000cca34de737a4-part1 -> =
=2E./../sdr1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 wwn-0x5000cca34de737a4-part2 -> =
=2E./../sdr2
lrwxrwxrwx 1 root root  9 Nov 12 10:19 wwn-0x5000cca34de738cd -> ../../=
sdq
lrwxrwxrwx 1 root root 10 Nov 12 10:19 wwn-0x5000cca34de738cd-part1 -> =
=2E./../sdq1
lrwxrwxrwx 1 root root 10 Nov 12 10:19 wwn-0x5000cca34de738cd-part2 -> =
=2E./../sdq2

It seems that the mapping changes at each reboot (two drives that host =
the operating system had different name across reboots).
Since we re-tighten screws, we didn't reboot though.


> The rest of the information from smartctl is important, and you shoul=
d
> upgrade your system to a level that supports it, but it can wait for =
later.
>=20
> It might be best to boot into a newer environment strictly for this
> recovery task.  Newer kernels and utilities have more bugfixes and ar=
e
> much more robust in emergencies.  I normally use SystemRescueCD [2] f=
or
> emergencies like this.

Ok, if I get stuck on some operations, I'll try with SystemRescueCD.


Regards,

Cl=C3=A9ment and Marc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
