From: Dieter =?iso-8859-15?q?N=FCtzel?= <Dieter.Nuetzel@hamburg.de>
Subject: How to get all disk geometry (logical/physical) equal for RAID5
Date: Sat, 7 Sep 2002 15:15:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200209071515.18103.Dieter.Nuetzel@hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Chris Mason <mason@suse.com>, Linux RAID List <linux-raid@vger.kernel.org>, ReiserFS List <reiserfs-list@namesys.com>
List-Id: linux-raid.ids

Hello Neil, Chris,

Sorry that I bother you but I'm under some hurry 'cause a school server=
=20
crashed and I have to set it up over the weekend, again.
It had double disk fault in RAID5. The second disk show the damage duri=
ng=20
RAID5 reconstruction ;-(
So I changed all 4 disks with another brand and put a fifth one as spar=
e in.

hda (the spare) is on the on board VIA 686b controller and show some "b=
ad"=20
logical numbers so that I get a different partition layout.

hde and hdg are on the on board HPT 370
hdi and hdk are on an additional HPT 370A IDE card

hdb is for installation only

Any chance to change the logical disk layout of hda?

Second to you and Chris:
Is it possible to boot from the mirrored RAID1 partitions (hdX10) with =
the=20
current lilo-22.x (SuSE 8.0)? With ReiserFS?

Thank you much!

-Dieter

=46estplatte /dev/hdk: 16 K=F6pfe, 63 Sektoren, 77545 Zylinder
Einheiten: Zylinder mit 1008 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hdk1             1     14564   7340224+  fd  Linux raid autodetect
/dev/hdk2         14565     20806   3145968   fd  Linux raid autodetect
/dev/hdk3         20807     20949     72072   fd  Linux raid autodetect
/dev/hdk4         20950     77545  28524384    5  Erweiterte
/dev/hdk5         20950     27191   3145936+  fd  Linux raid autodetect
/dev/hdk6         27192     41755   7340224+  fd  Linux raid autodetect
/dev/hdk7         41756     56319   7340224+  fd  Linux raid autodetect
/dev/hdk8         56320     64642   4194760+  fd  Linux raid autodetect
/dev/hdk9         64643     72965   4194760+  fd  Linux raid autodetect
/dev/hdk10        72966     73006     20632+  83  Linux
/dev/hdk11        73007     77545   2287624+  83  Linux

=46estplatte /dev/hdi: 16 K=F6pfe, 63 Sektoren, 77545 Zylinder
Einheiten: Zylinder mit 1008 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hdi1             1     14564   7340224+  fd  Linux raid autodetect
/dev/hdi2         14565     20806   3145968   fd  Linux raid autodetect
/dev/hdi3         20807     20949     72072   fd  Linux raid autodetect
/dev/hdi4         20950     77545  28524384    5  Erweiterte
/dev/hdi5         20950     27191   3145936+  fd  Linux raid autodetect
/dev/hdi6         27192     41755   7340224+  fd  Linux raid autodetect
/dev/hdi7         41756     56319   7340224+  fd  Linux raid autodetect
/dev/hdi8         56320     64642   4194760+  fd  Linux raid autodetect
/dev/hdi9         64643     72965   4194760+  fd  Linux raid autodetect
/dev/hdi10        72966     73006     20632+  83  Linux
/dev/hdi11        73007     77545   2287624+  83  Linux

=46estplatte /dev/hdg: 16 K=F6pfe, 63 Sektoren, 77545 Zylinder
Einheiten: Zylinder mit 1008 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hdg1             1     14564   7340224+  fd  Linux raid autodetect
/dev/hdg2         14565     20806   3145968   fd  Linux raid autodetect
/dev/hdg3         20807     20949     72072   fd  Linux raid autodetect
/dev/hdg4         20950     77545  28524384    5  Erweiterte
/dev/hdg5         20950     27191   3145936+  fd  Linux raid autodetect
/dev/hdg6         27192     41755   7340224+  fd  Linux raid autodetect
/dev/hdg7         41756     56319   7340224+  fd  Linux raid autodetect
/dev/hdg8         56320     64642   4194760+  fd  Linux raid autodetect
/dev/hdg9         64643     72965   4194760+  fd  Linux raid autodetect
/dev/hdg10        72966     73006     20632+  83  Linux
/dev/hdg11        73007     77545   2287624+  83  Linux

=46estplatte /dev/hde: 16 K=F6pfe, 63 Sektoren, 77545 Zylinder
Einheiten: Zylinder mit 1008 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hde1             1     14564   7340224+  fd  Linux raid autodetect
/dev/hde2         14565     20806   3145968   fd  Linux raid autodetect
/dev/hde3         20807     20949     72072   fd  Linux raid autodetect
/dev/hde4         20950     77545  28524384    5  Erweiterte
/dev/hde5         20950     27191   3145936+  fd  Linux raid autodetect
/dev/hde6         27192     41755   7340224+  fd  Linux raid autodetect
/dev/hde7         41756     56319   7340224+  fd  Linux raid autodetect
/dev/hde8         56320     64642   4194760+  fd  Linux raid autodetect
/dev/hde9         64643     72965   4194760+  fd  Linux raid autodetect
/dev/hde10        72966     73006     20632+  83  Linux
/dev/hde11        73007     77545   2287624+  83  Linux

=46estplatte /dev/hda: 255 K=F6pfe, 63 Sektoren, 4865 Zylinder
Einheiten: Zylinder mit 16065 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hda2   *         1      4865  39078081   83  Linux

=46estplatte /dev/hdb: 128 K=F6pfe, 63 Sektoren, 620 Zylinder
Einheiten: Zylinder mit 8064 * 512 Bytes

    Ger=E4t boot.  Anfang      Ende    Bl=F6cke   Id  Dateisystemtyp
/dev/hdb1             1       620   2499808+  83  Linux

--=20
Dieter N=FCtzel
Graduate Student, Computer Science

University of Hamburg
Department of Computer Science
@home: Dieter.Nuetzel at hamburg.de (replace at with @)

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
