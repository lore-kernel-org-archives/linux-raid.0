From: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Subject: AW: Test program for raid
Date: Fri, 20 Dec 2002 13:40:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <984305F1827DD5118FEA0000D1105F0A01BDC0CC@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My RAID-Problems I described earlier in thread "SW-RAID 1 and kernel
2.4.18", started at 26.Nov 02.

We tested the computers with a shell script "stress.sh", which copies a
directory and compares the checksum. This happens in 50 threads at the =
same
time. My group tested the computers about 24h, another group in our com=
pany
tested 3 or more days. The computers of that group stopped working afte=
r 3
or 4 days. 2 Computers are probably killed by the tests, they don't sta=
rt
anymore (no bios start after pressing start button).

Tests were run with 3 different disks (Maxtor, Seagate, IBM), 2 differe=
nt
Mainboards (MSI with VIA chipset, Asus with Intel Chipset), with and wi=
thout
removable frames, Red Hat 7, SuSE 7.3 and 8.0, always Filesystem Ext3

No errors in /var/log/messages were in the tests with DMA off (SuSE 7.3=
 with
Kernel 2.4.18, MSI board, IBM disks).

Errors:
 - in /var/log/messages:
     - BadCRC:=20
         linux kernel: hdc: dma_intr: status=3D0x51 { DriveReady SeekCo=
mplete
Error }=20
         linux kernel: hdc: dma_intr: error=3D0x84 { DriveStatusError B=
adCRC }

     - DMA Timeout (on a test system without removable disk frames and =
on
the system with Red Hat7):
         linux kernel: hda: timeout waiting for DMA
         linux kernel: ide_dmaproc: chipset supported ide_dma_timeout f=
unc
only: 14
         linux kernel: blk: queue c03564e4, I/O limit 4095Mb (mask
0xffffffff)
         linux kernel: hda: status timeout: status=3D0xd0 { Busy }
         linux kernel: hda: drive not ready for command
         linux kernel: ide0: reset: success

 - Drives are removed from RAID (especially uncool if it was the last D=
rive
in the Array)
 - some Computers are always rebuilding the Array, after finishing the
rebuild it starts again.
 - resync array after normal shutdown

 - computer stops working (no error logs even on a mounted external dri=
ve)



Possible causes:
 - maybe bad removable frames for HDDs (the DMA Error BadCRC was=20
 - bad power supply, but ours should be a good one (300W, in Tests pass=
ed as
good)
 - DMA errors in the kernel?

 - SuSE found a bug in the kernel (SuSE specific), which causes problem=
s
with more than one disk.

Regards
Arnt

by the way, I'm out of office because of this big party in some days. B=
ack
for discussion in january.



-----Urspr=FCngliche Nachricht-----
Von: Gordon Henderson [mailto:gordon@drogon.net]
Gesendet am: Donnerstag, 19. Dezember 2002 13:13
An: SCHEP. - Schepke, Arnt
Cc: 'linux-raid@vger.kernel.org'
Betreff: Re: Test program for raid

On Thu, 19 Dec 2002, SCHEP. - Schepke, Arnt wrote:

> Hi,
> just a little question: I want to test my Software-RAID1 System.
> I have some errors and want something like a one year usage in a one =
day
> test.

What sort of errors?

> Do you have an idea what program to use?

It depends on what you want to test ...

To test the disk system, data paths and so on, I use 'bonnie' which is =
a
disk benchmark program. I run about 6 or 8 of them in a loop for severa=
l
days (if possible) before making a server go live. Running more than on=
e
is obviously no use as a benchmark, but it does seem give it it good
thrashing. The trick is to not start them at the same time, but to stag=
ger
them - that way you get a good mix of the different operations that Bon=
nie
performs.

I use this:

  #!/bin/sh
  # /usr/local/bin/dob
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120
  dobon & sleep 120 ;  dobon & sleep 120

And:

  #!/bin/csh
  #	/usr/local/bin/dobon
  @ n =3D 1
  while (1)
    echo Pass number $n
    bonnie -s1047 -n0 -u0
    @ n++
  end

You many have to alter the flags to bonnie depending on what version yo=
u
use (this is for bonnie++ as supplied with Debian 3)

Make sure the filesystem has enough disk space - this will require 8GB =
of
disk space...

I've managed to break an IBM server raid controller with this - so much
for RAID in hardware. IBM acknowledge the fault too and are supposed to=
 be
working on it... Don't buy IBM, stick to software raid :)

However, I recently had a Linux (s/w raid + ext2) system which would ru=
n
this all night, but FAIL on FSCK... So after running this for some time=
,
stop it, then umount the filesystem and run several FSCKs on it. (The
failure reason was an AMD hardware fault - cured by plugging in a PS2
mouse and compiling the mouse driver back into the kernel)

Good luck!

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
