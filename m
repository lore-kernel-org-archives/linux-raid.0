From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: AW: Test program for raid
Date: Fri, 20 Dec 2002 15:37:23 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1021220153434.5456A-100000@Maggie.Linux-Consulting.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC0CC@HW_MAIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <984305F1827DD5118FEA0000D1105F0A01BDC0CC@HW_MAIL>
To: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


hi ya

my first guess.. agreeing w/ Arnt
	- if you have those disks on a ide tray ... take the tray away...

	plug the 80-pin ata100 ide cable directly from the mb to the
	drives...=20

	than re-run your tests

	also try the lastest 2.4.19 or 2.4.20 kernels

	check that those kernels has support for the ide chipset used on
	those motherboards .. sometimes specifically enabling those
	ide options for that mb helps ...

c ya
alvin


On Fri, 20 Dec 2002, SCHEP. - Schepke, Arnt wrote:

> My RAID-Problems I described earlier in thread "SW-RAID 1 and kernel
> 2.4.18", started at 26.Nov 02.
>=20
> We tested the computers with a shell script "stress.sh", which copies=
 a
> directory and compares the checksum. This happens in 50 threads at th=
e same
> time. My group tested the computers about 24h, another group in our c=
ompany
> tested 3 or more days. The computers of that group stopped working af=
ter 3
> or 4 days. 2 Computers are probably killed by the tests, they don't s=
tart
> anymore (no bios start after pressing start button).
>=20
> Tests were run with 3 different disks (Maxtor, Seagate, IBM), 2 diffe=
rent
> Mainboards (MSI with VIA chipset, Asus with Intel Chipset), with and =
without
> removable frames, Red Hat 7, SuSE 7.3 and 8.0, always Filesystem Ext3
>=20
> No errors in /var/log/messages were in the tests with DMA off (SuSE 7=
=2E3 with
> Kernel 2.4.18, MSI board, IBM disks).
>=20
> Errors:
>  - in /var/log/messages:
>      - BadCRC:=20
>          linux kernel: hdc: dma_intr: status=3D0x51 { DriveReady Seek=
Complete
> Error }=20
>          linux kernel: hdc: dma_intr: error=3D0x84 { DriveStatusError=
 BadCRC }
>=20
>      - DMA Timeout (on a test system without removable disk frames an=
d on
> the system with Red Hat7):
>          linux kernel: hda: timeout waiting for DMA
>          linux kernel: ide_dmaproc: chipset supported ide_dma_timeout=
 func
> only: 14
>          linux kernel: blk: queue c03564e4, I/O limit 4095Mb (mask
> 0xffffffff)
>          linux kernel: hda: status timeout: status=3D0xd0 { Busy }
>          linux kernel: hda: drive not ready for command
>          linux kernel: ide0: reset: success
>=20
>  - Drives are removed from RAID (especially uncool if it was the last=
 Drive
> in the Array)
>  - some Computers are always rebuilding the Array, after finishing th=
e
> rebuild it starts again.
>  - resync array after normal shutdown
>=20
>  - computer stops working (no error logs even on a mounted external d=
rive)
>=20
>=20
>=20
> Possible causes:
>  - maybe bad removable frames for HDDs (the DMA Error BadCRC was=20
>  - bad power supply, but ours should be a good one (300W, in Tests pa=
ssed as
> good)
>  - DMA errors in the kernel?
>=20
>  - SuSE found a bug in the kernel (SuSE specific), which causes probl=
ems
> with more than one disk.
>=20
> Regards
> Arnt
>=20
> by the way, I'm out of office because of this big party in some days.=
 Back
> for discussion in january.
>=20
>=20
>=20
> -----Urspr=FCngliche Nachricht-----
> Von: Gordon Henderson [mailto:gordon@drogon.net]
> Gesendet am: Donnerstag, 19. Dezember 2002 13:13
> An: SCHEP. - Schepke, Arnt
> Cc: 'linux-raid@vger.kernel.org'
> Betreff: Re: Test program for raid
>=20
> On Thu, 19 Dec 2002, SCHEP. - Schepke, Arnt wrote:
>=20
> > Hi,
> > just a little question: I want to test my Software-RAID1 System.
> > I have some errors and want something like a one year usage in a on=
e day
> > test.
>=20
> What sort of errors?
>=20
> > Do you have an idea what program to use?
>=20
> It depends on what you want to test ...
>=20
> To test the disk system, data paths and so on, I use 'bonnie' which i=
s a
> disk benchmark program. I run about 6 or 8 of them in a loop for seve=
ral
> days (if possible) before making a server go live. Running more than =
one
> is obviously no use as a benchmark, but it does seem give it it good
> thrashing. The trick is to not start them at the same time, but to st=
agger
> them - that way you get a good mix of the different operations that B=
onnie
> performs.
>=20
> I use this:
>=20
>   #!/bin/sh
>   # /usr/local/bin/dob
>   dobon & sleep 120 ;  dobon & sleep 120
>   dobon & sleep 120 ;  dobon & sleep 120
>   dobon & sleep 120 ;  dobon & sleep 120
>   dobon & sleep 120 ;  dobon & sleep 120
>=20
> And:
>=20
>   #!/bin/csh
>   #	/usr/local/bin/dobon
>   @ n =3D 1
>   while (1)
>     echo Pass number $n
>     bonnie -s1047 -n0 -u0
>     @ n++
>   end
>=20
> You many have to alter the flags to bonnie depending on what version =
you
> use (this is for bonnie++ as supplied with Debian 3)
>=20
> Make sure the filesystem has enough disk space - this will require 8G=
B of
> disk space...
>=20
> I've managed to break an IBM server raid controller with this - so mu=
ch
> for RAID in hardware. IBM acknowledge the fault too and are supposed =
to be
> working on it... Don't buy IBM, stick to software raid :)
>=20
> However, I recently had a Linux (s/w raid + ext2) system which would =
run
> this all night, but FAIL on FSCK... So after running this for some ti=
me,
> stop it, then umount the filesystem and run several FSCKs on it. (The
> failure reason was an AMD hardware fault - cured by plugging in a PS2
> mouse and compiling the mouse driver back into the kernel)
>=20
> Good luck!
>=20
> Gordon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
