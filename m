From: "nixbugz" <nixbugz@outlook.com>
Subject: Re: Can't grow IMSM RAID5
Date: Wed, 2 Apr 2014 02:35:25 +0100
Message-ID: <DUB113-DS8A84CB0AD235F1E36B421A96D0@phx.gbl>
References: <DUB113-DS14AD0971A94EC90C73E3A6A9620@phx.gbl> <1396368503.172158.6.camel@djiang5-desk1.amr.corp.intel.com> <DUB113-DS32C3A824A4ED3C133290E0A9620@phx.gbl> <1396375529.172158.15.camel@djiang5-desk1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1396375529.172158.15.camel@djiang5-desk1.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-raid@vger.kernel.org, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

-----Original Message-----=20
=46rom: Jiang, Dave
Sent: Tuesday, April 1, 2014 7:05 PM
To: nixbugz@outlook.com
Cc: linux-raid@vger.kernel.org ; Paszkiewicz, Artur
Subject: Re: Can't grow IMSM RAID5

On Tue, 2014-04-01 at 18:34 +0100, nixbugz wrote:
> -----Original Message-----=20
> From: Jiang, Dave
> Sent: Tuesday, April 1, 2014 5:08 PM
> To: nixbugz@outlook.com
> Cc: linux-raid@vger.kernel.org ; Paszkiewicz, Artur
> Subject: Re: Can't grow IMSM RAID5
>
> On Tue, 2014-04-01 at 16:42 +0100, nixbugz wrote:
> > Hello
> >
> > I=E2=80=99m stuck trying to add a 4th disc to an IMSM RAID5 contain=
er:
> >
> > # mdadm -a /dev/md127 /dev/sdb
> > mdadm: added /dev/sdb
> >
> > # mdadm --grow --raid-devices=3D4
> > /dev/md127 --backup-file=3D/mnt/spare/raid-backup-file
> > mdadm: Cannot read superblock for /dev/md127
>
> I think you need to grow the RAID volume and not the container? So it
> would be /dev/md0 or /dev/md1 instead of /dev/md127? Here's URL to th=
e
> Linux IMSM user's manual that hopefully may be of use:
> http://www.intel.com/support/chipsets/rste/sb/CS-033622.htm
>
> >
> > # cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 sdd[2] sda[1] sdc[0]
> >       1887436800 blocks super external:/md127/0 level 5, 128k chunk=
,
> > algorithm 0 [3/3] [UUU]
> >
> > md1 : active (auto-read-only) raid5 sdc[2] sdd[1] sda[0]
> >       66077696 blocks super external:/md127/1 level 5, 128k chunk,
> > algorithm
> > 0 [3/3] [UUU]
> >
> > md127 : inactive sdb[3](S) sda[2](S) sdc[1](S) sdd[0](S)
> >       12612 blocks super external:imsm
> >
> > unused devices: <none>
> >
> > # mdadm =E2=80=93V
> > mdadm - v3.3 - 3rd September 2013
> >
> >
> > I don=E2=80=99t know if this is related but mdmon has trouble findi=
ng the ports:
> >
> > # mdadm --detail-platform -v
> > mdadm: checking metadata 0.90
> > mdadm: 0.90 metadata is platform independent
> > mdadm: checking metadata 1.x
> > mdadm: 1.x metadata is platform independent
> > mdadm: checking metadata ddf
> > mdadm: ddf metadata is platform independent
> > mdadm: checking metadata imsm
> > mdmon: found Intel(R) SATA RAID controller at 0000:00:1f.2.
> >        Platform : Intel(R) Matrix Storage Manager
> >         Version : 11.6.0.1702
> >     RAID Levels : raid0 raid1 raid10 raid5
> >     Chunk Sizes : 4k 8k 16k 32k 64k 128k
> >     2TB volumes : supported
> >       2TB disks : supported
> >       Max Disks : 6
> >     Max Volumes : 2 per array, 4 per controller
> > I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
> > mdmon: failed to determine port number for
> > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0
> > mdmon: failed to enumerate ports on SATA controller at 0000:00:1f.2=
=2E
> > mdadm: checking metadata mbr
> > mdadm: mbr metadata is platform independent
> > mdadm: checking metadata gpt
> > mdadm: gpt metadata is platform independent
> > #
>
> Artur, any ideas why mdmon isn't happy in this instance?
>
> Thanks for your quick response.  I wasn't sure whether to grow contai=
ner=20
> or
> volume but this from man mdadm decided it:
>
>       Using  GROW  on containers is currently supported only for Inte=
l's
> IMSM
>       container format.   The  number  of  devices  in  a  container =
 can
> be
>       increased  - which affects all arrays in the container ...
>
> It gives the same message anyway when applied to the volume md0.
>
> This extract from the Intel doc you linked to says the same (note tha=
t md0
> is the container here :-)
>
>     The example below adds a single disk to the RAID container and th=
en
> grows the
>     volume(s). Because IMSM volumes inside a container must span the =
same
>     number of disks, all volumes are expanded.
> ...
>         mdadm =E2=80=93a /dev/md0 /dev/sde
>         mdadm =E2=80=93G /dev/md0 =E2=80=93n 4 --backup-file=3D/tmp/b=
ackup
>
> Might it be something to do with what's already on the new drive?
> This is an Intel DQ77MK motherboard.

Ooops my bad. It's been a while since I played with the grow feature.
Even if there's something on the drive, it doesn't make sense to me why
it complains not able to read the superblock on /dev/md127. And adding
the drive to the container should've updated the super block on that
drive I would think.... Although I wonder if the mdmon issue is a
clue.... I assume all the drives are attached to the Intel AHCI
controller right? Maybe Artur will have a better idea as he is much mor=
e
familiar with the actual code.
N=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BDy=EF=BF=BD=EF=BF=BD=D8=B2X=EF=BF=BD=
=EF=BF=BDv=D8=96)=EF=BF=BD{n=C7=89=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=BF=BD=
=EF=BF=BD{y=EF=BF=BD=CA=87=EF=BF=BD=EF=BF=BDj=07=EF=BF=BDf=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BDj:v=EF=BF=BD=EF=BF=BDwj=D8=B6=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=
=BDzZ=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj=EF=BF=BD=EF=BF=BD





The 4 drives are on the first 4 SATA ports - the Intel RST ports.
As for mdmon, my C is very rusty but it looks like this routine in=20
super-intel.c is expecting dirs called "host[0-9]*":

static int ahci_get_port_count(const char *hba_path, int *port_count)
{
        struct dirent *ent;
        DIR *dir;
        int host_base =3D -1;

        *port_count =3D 0;
        if ((dir =3D opendir(hba_path)) =3D=3D NULL)
                return -1;

        for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
                int host;

                if (sscanf(ent->d_name, "host%d", &host) !=3D 1)
                        continue;


which don't exist in the file-system at that point

$ ls /sys/bus/pci/drivers/ahci/0000:00:1f.2
ata1                      d3cold_allowed  modalias   resource1
ata2                      device          msi_bus    resource2
ata3                      dma_mask_bits   msi_irqs   resource3
ata4                      driver          numa_node  resource4
ata5                      enable          power      resource5
ata6                      firmware_node   remove     subsystem
broken_parity_status      iommu_group     rescan     subsystem_device
class                     irq             reset      subsystem_vendor
config                    local_cpulist   resource   uevent
consistent_dma_mask_bits  local_cpus      resource0  vendor
$

but do in the ata* dirs

$ ls /sys/bus/pci/drivers/ahci/0000:00:1f.2/ata1
ata_port  host0  link1  power  uevent
$

One more thing, is it normal to see this message repeated on shutdown?
mdadm: Cannot get exclusive access to /dev/md0:Perhaps a running proces=
s,=20
mounted filesystem or active volume group?


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
