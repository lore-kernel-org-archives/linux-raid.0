From: eim <eim@eimbox.org>
Subject: LILO related problem
Date: 25 Apr 2002 20:10:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1019758252.469.31.camel@eimbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

LILO related problem
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Hallo linux-raid folks, after searching answers to my LILO - RAID
related problem on different internet forums and mailing list
archives I've decided to post my question here, hope to get=20
some suggestions, thanks.

The problem is this, I've got several 'new-style' RAID capable
boxes with kernel 2.2.19 (raid patched) and two IBM 2G HDD (SCSI)
drives on each machine.

All those boxes are powered by Debian GNU/Linux (stable) and
successfully boot from their RAID root partitions.

Here's the partition scheme, nothing special...

	* /dev/md0	root
	* /dev/md1	swap

Two days ago I needed to recompile the kernel on some of the
RAID boxes, as I use LILO after successfull compilation I've
done as usual: 'lilo -v -v'.

/etc/lilo.conf was setup without any disk geometry information
and with root and boot pointing to /dev/md0.

And here's the problem...

* On some boxes LILO didn't remember anything about the Hard disk
  geometry witch I've never specified becaus LILO has always worked,
  and left me this message "Error: GET_DISK:INFO: invalid argument"

* On some other boxes LILO installed the bootloader only in
  /dev/sda or only in /dev/sdb, not on both.

* And on another box LILO installed the bootloader two times in
  /dev/sdb and one time in /dev/sda, why to times in /dev/sdb ?

Well, this is quite strange, the raid devices were all running
fine on all linux boxes when I've installed LILO, so why all
this problems ?

Maybe it's related to some RAID resyncing with was done in
the past, is this possible ?

Thanks for any help, folks and...
=2E..have a nice time !

 - Ivo

--=20

 =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =
=BB=AB =BB=AB =BB=AB =BB=AB =BB=AB
 Ivo Marino                    eim@eimbox.org
 UN*X Developer, running Debian GNU/Linux
 irc.OpenProjects.net #debian
 http://eimbox.org/~eim     http://eimbox.org
 =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =BB=AB =
=BB=AB =BB=AB =BB=AB =BB=AB =BB=AB

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
