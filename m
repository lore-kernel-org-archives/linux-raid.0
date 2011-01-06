From: "Philippe PIOLAT" <piolat@getalinks.fr>
Subject: RE: fd partitions gone from 2 discs, md happy with it and reconstructs... bye bye datas
Date: Thu, 6 Jan 2011 09:23:30 +0100
Message-ID: <004601cbad7b$00587190$010954b0$@getalinks.fr>
References: <00ce01cbabef$54037fc0$fc0a7f40$@getalinks.fr> <20110104220345.6abbc9d9@notabene.brown> <00e901cbac03$881136e0$9833a4a0$@getalinks.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00e901cbac03$881136e0$9833a4a0$@getalinks.fr>
Content-Language: fr
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have tried to run xfs_repair, but it got stucked on the following lin=
e for
hours :

freeblk count 1 !=3D flcount 1292712394 in ag 15

Any idea why ?
Below is a more comprehensive excerpt:


Tanker:~# xfs_repair -v -L /dev/md0
Phase 1 - find and verify superblock...
        - block cache size set to 166416 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 8 tail block 8
        - scan filesystem freespace and inode maps...
bad magic # 0xd8800000 in inobt block 0/424
expected level 1 got 55424 in inobt block 0/424
bad on-disk superblock 1 - bad magic number
primary/secondary superblock 1 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0x4a6e005b for agf 1
bad version # -802481226 for agf 1
bad sequence # -1117236046 for agf 1
bad length 746456958 for agf 1, should be 15261872
flfirst -217756885 in agf 1 too large (max =3D 1024)
fllast -1858828195 in agf 1 too large (max =3D 1024)
bad magic # 0x2d98eeb7 for agi 1
bad version # 1487820178 for agi 1
bad sequence # -986498475 for agi 1
bad length # -640410626 for agi 1, should be 15261872
reset bad sb for ag 1
reset bad agf for ag 1
reset bad agi for ag 1
bad agbno 1166984667 in agfl, agno 1
freeblk count 1 !=3D flcount 851499664 in ag 1
bad agbno 3740209675 for btbno root, agno 1
bad agbno 3584687323 for btbcnt root, agno 1
bad agbno 2431368798 for inobt root, agno 1
bad magic # 0x43f5a1a0 in btbno block 2/3274820
expected level 0 got 11696 in btbno block 2/3274820
bad magic # 0x67e3e2b in btcnt block 2/7285316
expected level 0 got 38919 in btcnt block 2/7285316
bad magic # 0x7bd8ba0c in inobt block 2/2893023
expected level 0 got 58199 in inobt block 2/2893023
dubious inode btree block header 2/2893023
badly aligned inode rec (starting inode =3D 1893464917)
bad starting inode # (1893464917 (0x2 0x70dbfb55)) in ino rec, skipping=
 rec
// snip
badly aligned inode rec (starting inode =3D 2958692015)
bad starting inode # (2958692015 (0x2 0xb05a0eaf)) in ino rec, skipping=
 rec
bad magic # 0x30317762 in inobt block 3/1386762
expected level 0 got 4096 in inobt block 3/1386762
dubious inode btree block header 3/1386762
bad on-disk superblock 4 - bad magic number
primary/secondary superblock 4 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0xb8273064 for agf 4
bad version # 608255319 for agf 4
bad sequence # -1133901349 for agf 4
bad length -1010053909 for agf 4, should be 15261872
flfirst -1120948486 in agf 4 too large (max =3D 1024)
fllast -249192277 in agf 4 too large (max =3D 1024)
bad magic # 0x3e1aa5d1 for agi 4
bad version # 78211236 for agi 4
bad sequence # -95059905 for agi 4
bad length # -2068843361 for agi 4, should be 15261872
reset bad sb for ag 4
reset bad agf for ag 4
reset bad agi for ag 4
bad agbno 84248051 in agfl, agno 4
freeblk count 1 !=3D flcount -1877584494 in ag 4
bad agbno 3295638635 for btbno root, agno 4
bad agbno 3824887919 for btbcnt root, agno 4
bad agbno 2584592551 for inobt root, agno 4
bad magic # 0xcb8a0838 in btbno block 5/15107725
expected level 1 got 62865 in btbno block 5/15107725
bad magic # 0x720a4ca5 in btcnt block 5/5781135
expected level 1 got 12940 in btcnt block 5/5781135
bad magic # 0x14c90900 in btbno block 6/8534085
expected level 0 got 8351 in btbno block 6/8534085
bad magic # 0 in btcnt block 6/8534087
bad magic # 0xb2fb97d4 in inobt block 6/8537277
expected level 0 got 28305 in inobt block 6/8537277
dubious inode btree block header 6/8537277
badly aligned inode rec (starting inode =3D 3916413448)
bad starting inode # (3916413448 (0x6 0xa96fba08)) in ino rec, skipping=
 rec
// snip
badly aligned inode rec (starting inode =3D 3991836463)
bad starting inode # (3991836463 (0x6 0xcdee972f)) in ino rec, skipping=
 rec
bad magic # 0xc1c0e0db in btbno block 7/14299066
expected level 0 got 56022 in btbno block 7/14299066
bad magic # 0 in btcnt block 7/131534
bad on-disk superblock 8 - bad magic number
primary/secondary superblock 8 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0x0 for agf 8
bad version # 0 for agf 8
bad sequence # 0 for agf 8
bad length 0 for agf 8, should be 15261872
flfirst 1235838528 in agf 8 too large (max =3D 1024)
fllast -1624582223 in agf 8 too large (max =3D 1024)
bad magic # 0xd27ee25b for agi 8
bad version # 682133911 for agi 8
bad sequence # 868833830 for agi 8
bad length # -309198643 for agi 8, should be 15261872
reset bad sb for ag 8
reset bad agf for ag 8
reset bad agi for ag 8
bad agbno 288703486 in agfl, agno 8
freeblk count 1 !=3D flcount -2096152000 in ag 8
bad agbno 0 for btbno root, agno 8
bad agbno 0 for btbcnt root, agno 8
bad agbno 3529020399 for inobt root, agno 8
bad magic # 0 in btbno block 9/13230958
expected level 1 got 0 in btbno block 9/13230958
bad magic # 0x9545b5da in inobt block 10/6063213
expected level 0 got 9464 in inobt block 10/6063213
dubious inode btree block header 10/6063213
badly aligned inode rec (starting inode =3D 2899097214)
bad starting inode # (2899097214 (0xa 0x8cccb67e)) in ino rec, skipping=
 rec
// snip
bad starting inode # (3943235510 (0xa 0xcb08ffb6)) in ino rec, skipping=
 rec
badly aligned inode rec (starting inode =3D 2842887821)
ir_freecount/free mismatch, inode chunk 10/158533261, freecount -564015=
419
nfree 24
badly aligned inode rec (starting inode =3D 2769797306)
bad starting inode # (2769797306 (0xa 0x2517c0ba)) in ino rec, skipping=
 rec
badly aligned inode rec (starting inode =3D 2753872950)
ir_freecount/free mismatch, inode chunk 10/69518390, freecount 30513683=
1
nfree 42
// snip
bad starting inode # (3912402532 (0xa 0x69328664)) in ino rec, skipping=
 rec
bad on-disk superblock 11 - bad magic number
primary/secondary superblock 11 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0xa558fbb3 for agf 11
bad version # -147377049 for agf 11
bad sequence # -762960785 for agf 11
bad length 1134727438 for agf 11, should be 15261872
flfirst 1200930101 in agf 11 too large (max =3D 1024)
fllast 582547970 in agf 11 too large (max =3D 1024)
bad magic # 0xfdb94fd6 for agi 11
bad version # 1570507841 for agi 11
bad sequence # -22538393 for agi 11
bad length # -454538688 for agi 11, should be 15261872
reset bad sb for ag 11
reset bad agf for ag 11
reset bad agi for ag 11
bad agbno 493291493 in agfl, agno 11
freeblk count 1 !=3D flcount 1190954728 in ag 11
bad agbno 1979771594 for btbno root, agno 11
bad agbno 3493454650 for btbcnt root, agno 11
bad agbno 1378244542 for inobt root, agno 11
bad magic # 0x1010101 in btbno block 12/4811500
expected level 0 got 257 in btbno block 12/4811500
bad magic # 0 in btbno block 12/4811502
bno freespace btree block claimed (state 2), agno 12, bno 4811502, susp=
ect 0
bad magic # 0x242591f3 in btcnt block 12/11519022
expected level 0 got 1773 in btcnt block 12/11519022
block (13,2522619) multiply claimed by bno space tree, state - 1
// snip
block (13,13871227) multiply claimed by bno space tree, state - 1
bad magic # 0x1bdd0e58 in btcnt block 13/1753645
expected level 0 got 37606 in btcnt block 13/1753645
bad magic # 0x41425443 in btbno block 14/12342653
block (14,90288) multiply claimed by bno space tree, state - 1
// snip
block (14,106654) multiply claimed by bno space tree, state - 1
bad magic # 0xc68e7699 in btcnt block 14/53183
expected level 0 got 37689 in btcnt block 14/53183
bad magic # 0 in btcnt block 14/1372
bad on-disk superblock 15 - bad magic number
primary/secondary superblock 15 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0x494e81ff for agf 15
bad version # 33685504 for agf 15
bad sequence # 0 for agf 15
bad length 0 for agf 15, should be 15261872
flfirst 1237397194 in agf 15 too large (max =3D 1024)
fllast 211534305 in agf 15 too large (max =3D 1024)
bad magic # 0x494e81ff for agi 15
bad version # 33685504 for agi 15
bad sequence # 0 for agi 15
bad length # 0 for agi 15, should be 15261872
reset bad sb for ag 15
reset bad agf for ag 15
reset bad agi for ag 15
bad agbno 1229865471 in agfl, agno 15
freeblk count 1 !=3D flcount 1292712394 in ag 15

-----Message d'origine-----
De=A0: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] De la part de Philippe PIOLAT
Envoy=E9=A0: mardi 4 janvier 2011 12:36
=C0=A0: 'NeilBrown'
Cc=A0: linux-raid@vger.kernel.org
Objet=A0: RE: fd partitions gone from 2 discs, md happy with it and
reconstructs... bye bye datas

Thanks a lot for your help. I think I sunk deeper meanwhile...

I could recover the /dev/sdg1 and /dev/sdh1 entries using partprobe.

I then zeroed the superblocks from all disks, recreated the array with
--assume-clean and started the resync.
Then I received your answer and as you advised searched from older logs=
 and
discovered... that I made the mistake to add sdg and sdh to the array a=
t
last upgrade, and not sdg1 and sdh1 as I believed I did!...
So I quicly stopped the sync (was just started a few minutes ago), kill=
ed
the sdg1 and sdh1 partitions, zeroed the superblocks and assemblied aga=
in
with --assume-clean. As of now, it's syncing again...

Its probably hopeless now isn't it?.... :-(


Phil.

-----Message d'origine-----
De=A0: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] De la part de NeilBrown Envoy=
=E9=A0:
mardi 4 janvier 2011 12:04 =C0=A0: Philippe PIOLAT Cc=A0:
linux-raid@vger.kernel.org Objet=A0: Re: fd partitions gone from 2 disc=
s, md
happy with it and reconstructs... bye bye datas

On Tue, 4 Jan 2011 10:11:10 +0100 "Philippe PIOLAT" <piolat@getalinks.f=
r>
wrote:

> Hey gurus, need some help badly with this one.
> I run a server with a 6Tb md raid5 volume built over 7*1Tb disks.
> I've had to shut down the server lately and when it went back up, 2=20
> out of the 7 disks used for the raid volume had lost its conf :

I should say up front that I suspect you have lost your data.  However =
there
is enough here that doesn't make sense that I cannot be certain of anyt=
hing.

>=20
> dmesg :
> [   10.184167]  sda: sda1 sda2 sda3 // System disk
> [   10.202072]  sdb: sdb1
> [   10.210073]  sdc: sdc1
> [   10.222073]  sdd: sdd1
> [   10.229330]  sde: sde1
> [   10.239449]  sdf: sdf1
> [   11.099896]  sdg: unknown partition table
> [   11.255641]  sdh: unknown partition table

If sdg and sdh had a partition table before, but don't now, then at lea=
st
the first block of each of those devices has been corrupted.  In that c=
ase
we must assume that an unknown number of blocks at the start of those d=
rives
has been corrupted.  In that case you could have already lost critical =
data
and this point and nothing you could have done would have helped.


>=20
> All 7 disks have same geometry and were configured alike :
>=20
> dmesg :
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0x1e7481a5
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1      121601   976760001   fd  Linux raid
> autodetect

So the partition started 16065 sectors from the start of the device.
This is not a multiple of 64K, which is good.
If a partition starts at a multiple of 64K from the start of the device=
 and
extends to the end of the device, then the md metadata on the partition
could look like it was on the disk as well.
When mdadm sees a situation like this it will complain, but that cannot=
 have
been happening to you.
So when the partition table was destroy, mdadm should not have been abl=
e to
see the metadata that belonged to the partition.


>=20
> All 7 disks (sdb1, sdc1, sdd1, sde1, sdf1, sdg1, sdh1) were used in a=
=20
> md
> raid5 xfs volume.
> When booting, md, which was (obviously) out of sync kicked in and=20
> automatically started rebuilding over the 7 disks, including the two=20
> "faulty" ones; xfs tried to do some shenanigans as well:
>=20
> dmesg :
>  [   19.566941] md: md0 stopped.
> [   19.817038] md: bind<sdc1>
> [   19.817339] md: bind<sdd1>
> [   19.817465] md: bind<sde1>
> [   19.817739] md: bind<sdf1>
> [   19.817917] md: bind<sdh>
> [   19.818079] md: bind<sdg>
> [   19.818198] md: bind<sdb1>
> [   19.818248] md: md0: raid array is not clean -- starting backgroun=
d
> reconstruction
> [   19.825259] raid5: device sdb1 operational as raid disk 0
> [   19.825261] raid5: device sdg operational as raid disk 6
> [   19.825262] raid5: device sdh operational as raid disk 5
> [   19.825264] raid5: device sdf1 operational as raid disk 4
> [   19.825265] raid5: device sde1 operational as raid disk 3
> [   19.825267] raid5: device sdd1 operational as raid disk 2
> [   19.825268] raid5: device sdc1 operational as raid disk 1
> [   19.825665] raid5: allocated 7334kB for md0
> [   19.825667] raid5: raid level 5 set md0 active with 7 out of 7 dev=
ices,
> algorithm 2

=2E.. however it is clear that mdadm (and md) saw metadata at the end o=
f the
device which exactly matched the metadata on the other devices in the a=
rray.

This is very hard to explain.  I can only think of there explanations, =
none
of which seem particularly likely

1/ The partition table on sdg and sdh actually placed the first partiti=
on at
    a multiple of 64K unlike all the other devices in the array.
2/ someone copied the superblock from the end of sdg1 to the end of sdg=
, and
   also for sdh1 to sdh.
   Given that the first block of both devices was changed too, a comman=
d
like:
     dd if=3D/dev/sdg1 of=3D/dev/sdg
   would have done it.   But that seems extremely unlikely.
3/ The array previously consisted of 5 partitions and 2 whole devices.
   I have certainly seen this happen before, usually by accident.
   But if this were the case, your data should all be intact.  Yet it i=
sn't.



> [   19.825669] RAID5 conf printout:
> [   19.825670]  --- rd:7 wd:7
> [   19.825671]  disk 0, o:1, dev:sdb1
> [   19.825672]  disk 1, o:1, dev:sdc1
> [   19.825673]  disk 2, o:1, dev:sdd1
> [   19.825675]  disk 3, o:1, dev:sde1
> [   19.825676]  disk 4, o:1, dev:sdf1
> [   19.825677]  disk 5, o:1, dev:sdh
> [   19.825679]  disk 6, o:1, dev:sdg
> [   19.899787] PM: Starting manual resume from disk
> [   28.663228] Filesystem "md0": Disabling barriers, not supported by=
 the
> underlying device
> [   28.663228] XFS mounting filesystem md0
> [   28.884433] md: resync of RAID array md0
> [   28.884433] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [   28.884433] md: using maximum available idle IO bandwidth (but not=
 more
> than 200000 KB/sec) for resync.
> [   28.884433] md: using 128k window, over a total of 976759936 block=
s.

This resync is why I think your data could well be lost.
If the metadata did somehow get relocated, but the data didn't, then th=
is
will have updated all of the blocks that were thought to be parity bloc=
ks.
All of those on sdh and sdh would almost certainly have been data block=
s,
and that data would now be gone.
But there are still some big 'if's in there.


> [   29.025980] Starting XFS recovery on filesystem: md0 (logdev: inte=
rnal)
> [   32.680486] XFS: xlog_recover_process_data: bad clientid
> [   32.680495] XFS: log mount/recovery failed: error 5
> [   32.682773] XFS: log mount failed
>=20
> I ran fdisk and flagged sdg1 and sdh1 as fd.

If, however, the md metadata had not been moved, and the array was
previously made of 5 partitions and two devices, then this action would=
 have
corrupted some data early in the array possible making it impossible to
recover the xfs filesystem (not that it looked like it was particularly
recoverable anyway).


> I tried to reassemble the array but it didnt work: no matter what was=
=20
> in mdadm.conf, it still uses sdg and sdh instead of sdg1 and sdh1.

This seems to confirm that the metadata that we thought was on sdg1 and=
 sdh1
wasn't.  Using "mdadm --examine /dev/sdg1" for example would confirm.


> I checked in /dev and I see no sdg1 and and sdh1, shich explains why=20
> it wont use it.

mdadm -S /dev/md0
block --rereadpt /dev/sdg /dev/sdh

should fix that.

> I just don't know why those partitions are gone from /dev and how to=20
> readd those...
>=20
> blkid :
> /dev/sda1: LABEL=3D"boot" UUID=3D"519790ae-32fe-4c15-a7f6-f1bea813940=
9"
> TYPE=3D"ext2"=20
> /dev/sda2: TYPE=3D"swap"=20
> /dev/sda3: LABEL=3D"root" UUID=3D"91390d23-ed31-4af0-917e-e599457f615=
5"
> TYPE=3D"ext3"=20
> /dev/sdb1: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdra=
id"=20
> /dev/sdc1: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdra=
id"=20
> /dev/sdd1: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdra=
id"=20
> /dev/sde1: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdra=
id"=20
> /dev/sdf1: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdra=
id"=20
> /dev/sdg: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdrai=
d"=20
> /dev/sdh: UUID=3D"2802e68a-dd11-c519-e8af-0d8f4ed72889" TYPE=3D"mdrai=
d"=20
>=20
> fdisk -l :
> Disk /dev/sda: 40.0 GB, 40020664320 bytes
> 255 heads, 63 sectors/track, 4865 cylinders Units =3D cylinders of 16=
065
> * 512 =3D 8225280 bytes Disk identifier: 0x8c878c87
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1          12       96358+  83  Linux
> /dev/sda2              13         134      979965   82  Linux swap /
Solaris
> /dev/sda3             135        4865    38001757+  83  Linux
>=20
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0x1e7481a5
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0xc9bdc1e9
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0xcc356c30
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0xe87f7a3d
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sde1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0xb17a2d22
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0x8f3bce61
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdg1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders Units =3D cylinders of
> 16065 * 512 =3D 8225280 bytes Disk identifier: 0xa98062ce
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdh1               1      121601   976760001   fd  Linux raid
> autodetect
>=20
> I really dont know what happened nor how to recover from this mess.
> Needless to say the 5TB or so worth of data sitting on those disks ar=
e=20
> very valuable to me...
>=20
> Any idea any one?
> Did anybody ever experienced a similar situation or know how to=20
> recover from it ?
>=20
> Can someone help me? I'm really desperate... :x

I would see if your /var/logs file go back to the last reboot of this s=
ystem
and see if they show how the array was assembled then.  If they do, the=
n
collect any message about md or raid from that time until now.

That might give some hints as to what happened, but I don't hold a lot =
of
hope that it will allow your data to be recovered.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
