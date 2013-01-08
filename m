From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 13:54:15 -0800
Message-ID: <1357682055.3484.34.camel@markov.biostat.ucsf.edu>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
	 <1357628351.16366.86.camel@corn.betterworld.us>
	 <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
	 <1357631996.16366.139.camel@corn.betterworld.us>
	 <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: ross@biostat.ucsf.edu, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 02:10 -0700, Chris Murphy wrote:
> On Jan 8, 2013, at 12:59 AM, Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:
> >=20
> > Using /dev/sdb
> > Model: ATA WDC WD2003FYYS-0 (scsi)
> > Disk /dev/sdb: 3907029168s
> > Sector size (logical/physical): 512B/512B
> > Partition Table: gpt
> >=20
> > Number  Start     End          Size         File system  Name      =
             Flags
> > 1      34s       999999s      999966s                   extended bo=
ot loaders
> > 2      1000000s  2929687s     1929688s     ext3         /boot      =
            boot
> > 3      2929688s  6835937s     3906250s                  swap
> > 4      6835938s  3907029134s  3900193197s               main
> >=20
> > Using /dev/sdc
> > Model: ATA WDC WD2003FYYS-0 (scsi)
> > Disk /dev/sdc: 3907029168s
> > Sector size (logical/physical): 512B/512B
> > Partition Table: gpt
> >=20
> > Number  Start     End          Size         File system  Name      =
             Flags
> > 1      34s       999999s      999966s                   extended bo=
ot loaders
> > 2      1000000s  2929687s     1929688s     ext3         boot       =
            boot
> > 3      2929688s  6835937s     3906250s                  swap
> > 4      6835938s  3907029134s  3900193197s               main
> >=20
> > BTW the spec sheet for the WDC "red" drives says they use advanced
> > formatting (I may not have the buzzword quite right) with physical
> > sectors of 4k.  So the reported sector size is a fib.
>=20
> Yeah you're using an old version of parted for it to not recognize th=
at the physical sectors are 4096 bytes. The thing is, that it's a 512e =
disk, so the LBA's are still 512 bytes. And by the looks of it, your pa=
rtitions are not aligned on those 4K physical sectors because the start=
 value is 34s. In any recent fdisk or parted or gdisk, the start sector=
 is 2048 (1MiB), and each partition is aligned on 8-sector boundaries. =
So your disks aren't properly partitioned, and you're getting a perform=
ance hit because of it.
>=20
> What I'm not getting is why your md0, comprised of sda1 at 192717s, a=
nd sd[bc]2 are 1929688s. What am I missing here? Because those values a=
ren't at all the same. It's a 10x difference.
I'm migrating the array from an old, smaller disk (it was a pair of
disks, but I've already pulled one) to newer larger disks.  Eventually
the current sda will go away (I was going to keep using it, but given
recent problems, as you suggest, best to ditch it) and the RAID arrays
willl grow to fill the new space.

I manually specified the current layout of the bigger disks (sdb and c)=
;
at least some of the time I specified the exact sector. I picked 34
because that seems to be the traditional offset for the first partition
(and the one my tool generated when I gave it sizes in grosser units
than sectors or told it to start at 0).

Apparently some disks do a logical to physical remap that includes an
offset as well as a change in the sector size.  Should I check for that=
,
or should I just assume that I should start my partitions on sectors
that are multiples of 8?

You also asked what I meant by chatter in the logs about sdb.  Here are
some entries from shortly before the system locked up:
Jan  6 03:45:24 markov smartd[5368]: Device: /dev/sda, SMART Usage Attr=
ibute: 190 Airflow_Temperature_Cel changed from 64 to 65
Jan  6 03:45:24 markov smartd[5368]: Device: /dev/sda, SMART Usage Attr=
ibute: 194 Temperature_Celsius changed from 36 to 35
Jan  6 03:45:25 markov smartd[5368]: Device: /dev/sdb, SMART Usage Attr=
ibute: 194 Temperature_Celsius changed from 108 to 109

I am less excited about that since discovering the message about sdb
does not mean it's running at over 100 degrees celsius (the raw value i=
s
around 45).

The logs from the restart show
Jan  7 17:19:09 markov kernel: [    2.928055] ata2.00: SATA link down (=
SStatus 0 SControl 0)
Jan  7 17:19:09 markov kernel: [    2.928102] ata2.01: SATA link up 3.0=
 Gbps (SStatus 123 SControl 300)
Jan  7 17:19:09 markov kernel: [    2.944459] ata2.01: ATA-8: WDC WD200=
3FYYS-02W0B1, 01.01D02, max UDMA/133
Jan  7 17:19:09 markov kernel: [    2.944498] ata2.01: 3907029168 secto=
rs, multi 16: LBA48 NCQ (depth 0/32)
Jan  7 17:19:09 markov kernel: [    2.952486] ata2.01: configured for U=
DMA/133
Jan  7 17:19:09 markov kernel: [    2.952642] scsi 1:0:1:0: Direct-Acce=
ss     ATA      WDC WD2003FYYS-0 01.0 PQ: 0 ANSI: 5
Jan  7 17:19:09 markov kernel: [    2.952918] scsi 2:0:0:0: Direct-Acce=
ss     ATA      WDC WD2003FYYS-0 01.0 PQ: 0 ANSI: 5
Jan  7 17:19:09 markov kernel: [    2.953695] scsi 3:0:0:0: CD-ROM     =
       TSSTcorp CDDVDW SH-S223B  SB00 PQ: 0 ANSI: 5

Jan  7 17:19:09 markov kernel: [    3.289403] md: md0 stopped.
Jan  7 17:19:09 markov kernel: [    3.328423] md: md1 stopped.
Jan  7 17:19:09 markov kernel: [    3.382868] md: bind<sdb4>
Jan  7 17:19:09 markov kernel: [    3.383054] md: bind<sdc4>
Jan  7 17:19:09 markov kernel: [    3.383347] md: bind<sda3>
Jan  7 17:19:09 markov kernel: [    3.390925] raid1: md1 is not clean -=
- starting background reconstruction
Jan  7 17:19:09 markov kernel: [    3.390963] raid1: raid set md1 activ=
e with 3 out of 3 mirrors
Jan  7 17:19:09 markov kernel: [    3.391016] md1: detected capacity ch=
ange from 0 to 748056215552
Jan  7 17:19:09 markov kernel: [    3.391169]  md1: unknown partition t=
able

Jan  7 17:19:09 markov kernel: [    2.220056] ata1.00: SATA link up 3.0=
 Gbps (SStatus 123 SControl 300)
Jan  7 17:19:09 markov kernel: [    2.220103] ata1.01: SATA link down (=
SStatus 0 SControl 310)
Jan  7 17:19:09 markov kernel: [    2.228670] ata1.00: ATA-8: ST3750330=
NS, SN05, max UDMA/133
Jan  7 17:19:09 markov kernel: [    2.228709] ata1.00: 1465149168 secto=
rs, multi 16: LBA48 NCQ (depth 0/32)
Jan  7 17:19:09 markov kernel: [    2.244690] ata1.00: configured for U=
DMA/133
Jan  7 17:19:09 markov kernel: [    2.244845] scsi 0:0:0:0: Direct-Acce=
ss     ATA      ST3750330NS      SN05 PQ: 0 ANSI: 5

Aside from the message that md1 isn't clean, the SATA link down message=
s
sound a little odd.  I'm not sure how to map from atax to disk, but ata=
2
seems to be one of the new disks (sdb or sdc) and ata1 is the old one
(sda).

/dev/disk/by-path shows
  lrwxrwxrwx 1 root root   9 2013-01-07 17:15 pci-0000:00:1f.2-scsi-0:0=
:0:0 -> ../../sda
  lrwxrwxrwx 1 root root   9 2013-01-07 17:15 pci-0000:00:1f.2-scsi-1:0=
:1:0 -> ../../sdb
  lrwxrwxrwx 1 root root   9 2013-01-07 17:15 pci-0000:00:1f.5-scsi-0:0=
:0:0 -> ../../sdc

Ross

>=20
> And then with md1, comprised of sda3 at 1461047490s, and sd[bc]4 are =
3900193197s. A 2.66x difference. What is this? sda1 is 696GiB, while sd=
[bc]4 are 1.8TiB each? Ummm=E2=80=A6
>=20
>=20
>=20
>=20
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
