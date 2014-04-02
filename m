From: "nixbugz" <nixbugz@outlook.com>
Subject: Re: Can't grow IMSM RAID5
Date: Wed, 2 Apr 2014 14:15:30 +0100
Message-ID: <DUB113-DS2104BA74D88BD15101F285A96D0@phx.gbl>
References: <DUB113-DS14AD0971A94EC90C73E3A6A9620@phx.gbl> <1396368503.172158.6.camel@djiang5-desk1.amr.corp.intel.com> <DUB113-DS32C3A824A4ED3C133290E0A9620@phx.gbl> <1396375529.172158.15.camel@djiang5-desk1.amr.corp.intel.com> <DUB113-DS8A84CB0AD235F1E36B421A96D0@phx.gbl> <3B9FD4FFCF3F8A43B0125797A2BB89691A618B48@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3B9FD4FFCF3F8A43B0125797A2BB89691A618B48@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


-----Original Message-----=20
=46rom: Paszkiewicz, Artur
Sent: Wednesday, April 2, 2014 1:11 PM
To: nixbugz ; Jiang, Dave
Cc: linux-raid@vger.kernel.org
Subject: RE: Can't grow IMSM RAID5

> -----Original Message-----
> From: nixbugz [mailto:nixbugz@outlook.com]
> Sent: Wednesday, April 2, 2014 3:35 AM
> To: Jiang, Dave
> Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> Subject: Re: Can't grow IMSM RAID5
>
> -----Original Message-----
> From: Jiang, Dave
> Sent: Tuesday, April 1, 2014 7:05 PM
> To: nixbugz@outlook.com
> Cc: linux-raid@vger.kernel.org ; Paszkiewicz, Artur
> Subject: Re: Can't grow IMSM RAID5
>
> On Tue, 2014-04-01 at 18:34 +0100, nixbugz wrote:
> > -----Original Message-----
> > From: Jiang, Dave
> > Sent: Tuesday, April 1, 2014 5:08 PM
> > To: nixbugz@outlook.com
> > Cc: linux-raid@vger.kernel.org ; Paszkiewicz, Artur
> > Subject: Re: Can't grow IMSM RAID5
> >
> > On Tue, 2014-04-01 at 16:42 +0100, nixbugz wrote:
> > > Hello
> > >
> > > I=E2=80=99m stuck trying to add a 4th disc to an IMSM RAID5 conta=
iner:
> > >
> > > # mdadm -a /dev/md127 /dev/sdb
> > > mdadm: added /dev/sdb
> > >
> > > # mdadm --grow --raid-devices=3D4
> > > /dev/md127 --backup-file=3D/mnt/spare/raid-backup-file
> > > mdadm: Cannot read superblock for /dev/md127
> >

Is your OS installed on this array?
    Yes, on md0

What distribution is this?
    Archlinux Feb 2014 release

Is it systemd based?
    Yes

It appears that there is an issue with mdmon in such case. It can't acc=
ess a=20
new disk to write metadata. You can check this by doing mdadm -E /dev/s=
db.=20
If it doesn't show any metadata on this disk but the disk is in the=20
container, then it is this problem. As a workaround, please try this:

1. Remove the new disk from the container
# mdadm -r /dev/md127 /dev/sdb

2. Takeover mdmon for this array
# mdmon --takeover /dev/md127

3. Add the disk again and grow the array:
# mdadm -a /dev/md127 /dev/sdb
# export MDADM_EXPERIMENTAL=3D1
# mdadm --grow --raid-devices=3D4=20
/dev/md127 --backup-file=3D/mnt/spare/raid-backup-file

---------------------------------------------------------

Thank you, that was the problem and your suggestions worked, which is r=
eally=20
great because I feared having to start again to get 4 drives.

# mdadm -E /dev/sdb
/dev/sdb:
   MBR Magic : aa55

# mdadm -r /dev/md127 /dev/sdb
mdadm: hot removed /dev/sdb from /dev/md127

# mdmon --takeover /dev/md127

# mdadm -a /dev/md127 /dev/sdb
mdadm: added /dev/sdb

# export MDADM_EXPERIMENTAL=3D1
# mdadm --grow --raid-devices=3D4=20
/dev/md127 --backup-file=3D/mnt/spare/raid-backup-file
mdadm: multi-array reshape continues in background
mdadm: Need to backup 768K of critical section.
#

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb[3] sdd[2] sda[1] sdc[0]
      1887436800 blocks super external:-md127/0 level 5, 128k chunk,=20
algorithm 0 [4/4] [UUUU]
      [>....................]  reshape =3D  0.5% (4758016/943718400)=20
finish=3D813.6min speed=3D19233K/sec

md1 : active raid5 sdc[2] sdd[1] sda[0]
      66077696 blocks super external:-md127/1 level 5, 128k chunk, algo=
rithm=20
0 [3/3] [UUU]

md127 : inactive sdb[3](S) sda[2](S) sdc[1](S) sdd[0](S)
      12612 blocks super external:imsm

unused devices: <none>
#

# mdadm -E /dev/sdb
/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : d12e9b21
         Family : d12e9b21
     Generation : 00060baf
     Attributes : All supported
           UUID : e8286680:de9642f4:04200a4a:acbdb566
       Checksum : fbc8b3f4 correct
    MPB Sectors : 2
          Disks : 4
   RAID Devices : 2

  Disk03 Serial : S13PJDWS608384
          State : active
             Id : 01000000
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

[md0]:
           UUID : d5bf7ab7:2cda417d:f0c6542f:c77d9289
     RAID Level : 5 <-- 5
        Members : 4 <-- 3
          Slots : [UUUU] <-- [UUU]
    Failed disk : none
      This Slot : 3
     Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
   Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
  Sector Offset : 0
    Num Stripes : 7372800
     Chunk Size : 128 KiB <-- 128 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 6602 (N/A)
    Dirty State : clean

[md1]:
           UUID : 26671da2:0d23f085:3d12dbbe:f63aad5a
     RAID Level : 5
        Members : 3
          Slots : [UUU]
    Failed disk : none
      This Slot : ?
     Array Size : 132155392 (63.02 GiB 67.66 GB)
   Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
  Sector Offset : 1887440896
    Num Stripes : 258117
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

  Disk00 Serial : S13PJDWS608386
          State : active
             Id : 00000003
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

  Disk01 Serial : WD-WCC1S5684189
          State : active
             Id : 00000000
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

  Disk02 Serial : S246J9GZC04267
          State : active
             Id : 00000002
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

Migration Record Information: Empty
                              Examine one of first two disks in array
#

---------------------------------------------------------



> > I think you need to grow the RAID volume and not the container? So =
it
> > would be /dev/md0 or /dev/md1 instead of /dev/md127? Here's URL to =
the
> > Linux IMSM user's manual that hopefully may be of use:
> > http://www.intel.com/support/chipsets/rste/sb/CS-033622.htm
> >
> > >
> > > # cat /proc/mdstat
> > > Personalities : [raid6] [raid5] [raid4]
> > > md0 : active raid5 sdd[2] sda[1] sdc[0]
> > >       1887436800 blocks super external:/md127/0 level 5, 128k chu=
nk,
> > > algorithm 0 [3/3] [UUU]
> > >
> > > md1 : active (auto-read-only) raid5 sdc[2] sdd[1] sda[0]
> > >       66077696 blocks super external:/md127/1 level 5, 128k chunk=
,
> > > algorithm
> > > 0 [3/3] [UUU]
> > >
> > > md127 : inactive sdb[3](S) sda[2](S) sdc[1](S) sdd[0](S)
> > >       12612 blocks super external:imsm
> > >
> > > unused devices: <none>
> > >
> > > # mdadm =E2=80=93V
> > > mdadm - v3.3 - 3rd September 2013
> > >
> > >
> > > I don=E2=80=99t know if this is related but mdmon has trouble fin=
ding the=20
> > > ports:
> > >
> > > # mdadm --detail-platform -v
> > > mdadm: checking metadata 0.90
> > > mdadm: 0.90 metadata is platform independent
> > > mdadm: checking metadata 1.x
> > > mdadm: 1.x metadata is platform independent
> > > mdadm: checking metadata ddf
> > > mdadm: ddf metadata is platform independent
> > > mdadm: checking metadata imsm
> > > mdmon: found Intel(R) SATA RAID controller at 0000:00:1f.2.
> > >        Platform : Intel(R) Matrix Storage Manager
> > >         Version : 11.6.0.1702
> > >     RAID Levels : raid0 raid1 raid10 raid5
> > >     Chunk Sizes : 4k 8k 16k 32k 64k 128k
> > >     2TB volumes : supported
> > >       2TB disks : supported
> > >       Max Disks : 6
> > >     Max Volumes : 2 per array, 4 per controller
> > > I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
> > > mdmon: failed to determine port number for
> > > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0=
:0
> > > mdmon: failed to enumerate ports on SATA controller at 0000:00:1f=
=2E2.
> > > mdadm: checking metadata mbr
> > > mdadm: mbr metadata is platform independent
> > > mdadm: checking metadata gpt
> > > mdadm: gpt metadata is platform independent
> > > #
> >
> > Artur, any ideas why mdmon isn't happy in this instance?
> >

This is not related to the issue with grow. I think this is caused be a=
=20
change is sysfs which mdadm is not aware of (the ata1 dir before host0)=
=2E It=20
won't cause any problems, but it should be fixed. I will look into this=
=2E

> > Thanks for your quick response.  I wasn't sure whether to grow cont=
ainer
> > or
> > volume but this from man mdadm decided it:
> >
> >       Using  GROW  on containers is currently supported only for In=
tel's
> > IMSM
> >       container format.   The  number  of  devices  in  a  containe=
r=20
> > can
> > be
> >       increased  - which affects all arrays in the container ...
> >
> > It gives the same message anyway when applied to the volume md0.
> >
> > This extract from the Intel doc you linked to says the same (note t=
hat=20
> > md0
> > is the container here :-)
> >
> >     The example below adds a single disk to the RAID container and =
then
> > grows the
> >     volume(s). Because IMSM volumes inside a container must span th=
e=20
> > same
> >     number of disks, all volumes are expanded.
> > ...
> >         mdadm =E2=80=93a /dev/md0 /dev/sde
> >         mdadm =E2=80=93G /dev/md0 =E2=80=93n 4 --backup-file=3D/tmp=
/backup
> >
> > Might it be something to do with what's already on the new drive?
> > This is an Intel DQ77MK motherboard.
>
> Ooops my bad. It's been a while since I played with the grow feature.
> Even if there's something on the drive, it doesn't make sense to me w=
hy
> it complains not able to read the superblock on /dev/md127. And addin=
g
> the drive to the container should've updated the super block on that
> drive I would think.... Although I wonder if the mdmon issue is a
> clue.... I assume all the drives are attached to the Intel AHCI
> controller right? Maybe Artur will have a better idea as he is much m=
ore
> familiar with the actual code.
> N=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BDy=EF=BF=BD=EF=BF=BD=D8=B2X=EF=BF=
=BD=EF=BF=BDv=D8=96)=EF=BF=BD{n=C7=89=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=BF=
=BD=EF=BF=BD{y=EF=BF=BD=CA=87=EF=BF=BD=EF=BF=BDj
=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=EF=BF=BDw=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj:v=EF=BF=BD=EF=BF=BDwj=D8=B6=EF=BF=BD=EF=
=BF=BD
=EF=BF=BD=EF=BF=BDzZ=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj=EF=BF=
=BD=EF=BF=BD
>
>
>
>
>
> The 4 drives are on the first 4 SATA ports - the Intel RST ports.
> As for mdmon, my C is very rusty but it looks like this routine in
> super-intel.c is expecting dirs called "host[0-9]*":
>
> static int ahci_get_port_count(const char *hba_path, int *port_count)
> {
>         struct dirent *ent;
>         DIR *dir;
>         int host_base =3D -1;
>
>         *port_count =3D 0;
>         if ((dir =3D opendir(hba_path)) =3D=3D NULL)
>                 return -1;
>
>         for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
>                 int host;
>
>                 if (sscanf(ent->d_name, "host%d", &host) !=3D 1)
>                         continue;
>
>
> which don't exist in the file-system at that point
>
> $ ls /sys/bus/pci/drivers/ahci/0000:00:1f.2
> ata1                      d3cold_allowed  modalias   resource1
> ata2                      device          msi_bus    resource2
> ata3                      dma_mask_bits   msi_irqs   resource3
> ata4                      driver          numa_node  resource4
> ata5                      enable          power      resource5
> ata6                      firmware_node   remove     subsystem
> broken_parity_status      iommu_group     rescan     subsystem_device
> class                     irq             reset      subsystem_vendor
> config                    local_cpulist   resource   uevent
> consistent_dma_mask_bits  local_cpus      resource0  vendor
> $
>
> but do in the ata* dirs
>
> $ ls /sys/bus/pci/drivers/ahci/0000:00:1f.2/ata1
> ata_port  host0  link1  power  uevent
> $
>
> One more thing, is it normal to see this message repeated on shutdown=
?
> mdadm: Cannot get exclusive access to /dev/md0:Perhaps a running proc=
ess,
> mounted filesystem or active volume group?
>

N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=
=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=
=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=
=07=EF=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=20
=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=
=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=
=BD=EF=BF=BD!=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
