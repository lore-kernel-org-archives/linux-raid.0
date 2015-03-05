From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Raid 10 Issue
Date: Thu, 5 Mar 2015 18:56:00 +0100 (CET)
Message-ID: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello List.

I was setting up a new machine using ubuntu 14.04.02 lts using its inst=
aller,
configuring a raid 10 with 2 disks and lvm on top of it. I was using 2 =
disks and
now I like to add 2 more disks to the array so i want to end up with 4 =
disks, no
spare.

Searching the internet I found that I am not able to --grow the array w=
ith the
mdadm version this ubuntu is using (v3.2.5).
Is that right?

So I decided to build a new array that way and try to move my data afte=
rwards,
which failed:
(Is it OK to do it that way or do you recommend another?)

root@kvm15:~# mdadm --verbose --create --level=3D10 --raid-devices=3D4 =
/dev/md10
missing missing /dev/sdc1 /dev/sdd1
mdadm: layout defaults to n2
mdadm: layout defaults to n2
mdadm: chunk size defaults to 512K
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
mdadm: size set to 1904165376K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error
              <<<<<<<<<<<<<<<<<<<<<<<<<<<
root@kvm15:~#=20
root@kvm15:~#=20
root@kvm15:~# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid10] [raid6] [=
raid5]
[raid4]=20
md0 : active raid10 sdb1[1] sda1[0]
      1904165376 blocks super 1.2 2 near-copies [2/2] [UU]
     =20
unused devices: <none>


md0 btw. is the current (running) array.

I did a few tries to get this running. This is must be the reason why m=
dadm
detects already existing raid config.

The partitions for sdc and sdd are created using fdisk, they do have th=
e same
layout like disk sdb, which looks like this:

(parted) print                                                         =
  =20
Modell: ATA WDC WD20PURX-64P (scsi)
=46estplatte  /dev/sdc:  2000GB
Sektorgr=C3=B6=C3=9Fe (logisch/physisch): 512B/4096B
Partitionstabelle: msdos

Nummer  Anfang  Ende    Gr=C3=B6=C3=9Fe   Typ      Dateisystem  Flags
 1      50.4GB  2000GB  1950GB  primary               RAID


Any help is very welcome.

Thanks.
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
