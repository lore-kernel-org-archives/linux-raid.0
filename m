From: Dieter =?iso-8859-15?q?N=FCtzel?= <Dieter.Nuetzel@hamburg.de>
Subject: Re: [reiserfs-list] How to get all disk geometry (logical/physical) equal for RAID5
Date: Sat, 7 Sep 2002 15:47:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200209071547.59386.Dieter.Nuetzel@hamburg.de>
References: <200209071515.18103.Dieter.Nuetzel@hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200209071515.18103.Dieter.Nuetzel@hamburg.de>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Chris Mason <mason@suse.com>, Linux RAID List <linux-raid@vger.kernel.org>, ReiserFS List <reiserfs-list@namesys.com>
List-Id: linux-raid.ids

On Saturday 07 September 2002 15:15, Dieter N=FCtzel wrote:
> Hello Neil, Chris,
>
> Sorry that I bother you but I'm under some hurry 'cause a school serv=
er
> crashed and I have to set it up over the weekend, again.
> It had double disk fault in RAID5. The second disk show the damage du=
ring
> RAID5 reconstruction ;-(
> So I changed all 4 disks with another brand and put a fifth one as sp=
are
> in.
>
> hda (the spare) is on the on board VIA 686b controller and show some =
"bad"
> logical numbers so that I get a different partition layout.
>
> hde and hdg are on the on board HPT 370
> hdi and hdk are on an additional HPT 370A IDE card
>
> hdb is for installation only
>
> Any chance to change the logical disk layout of hda?
>
> Second to you and Chris:
> Is it possible to boot from the mirrored RAID1 partitions (hdX10) wit=
h the
> current lilo-22.x (SuSE 8.0)? With ReiserFS?

Addition:

Should I better skip all the partitions on the volumes and stay only wi=
th the=20
"raw" devices (maybe only hdX1) and create the partitions on the RAID5 =
array=20
(something like md0pXXX and maybe md1 for a RAID1 boot device (the lilo=
=20
thing))?

Is ReiserFS usable on such a system, too?
On my former "layout" it works so far and had for nearly a year.

My cylinder layout and boot question stays.

Which scheme should I use when LVM steps in?
LVM -> RAID5 -> partitions
or
RAID5 -> LVM -> partitions

Sorry for the "little" OT.

Regards,
	Dieter


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
