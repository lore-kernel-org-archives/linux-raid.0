From: Lars Schimmer <schimmer@cg.cs.tu-bs.de>
Subject: Software RAID5, promise IDE and system freeze...
Date: Mon, 30 Aug 2004 10:38:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4132E76F.7090209@cg.cs.tu-bs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

My system freeze everytime I try to setup a software RAID5 over more
than 1 PCI Promise IDE controller.
Setup:
Asus A7v8x motherboard
with 2 HDs: one system, one RAID
with 2 SATA:RAID
with old PCI graphicscard
with 3com LAN card
with 2 U133TX2 Promise IDE RAID with each 2 HDs , so 4 HDs for RAID
with 1 U100TX2 Promise with 2 HDs for RAID

Gives 9 HDs for RAID5. Each HD is Master on IDE bus.

When building a raid with the 3 HDs on MoBo & SATA and 2 HDs of ONE of
these 3 promise, the RAID works flawless.
But if I try to build a RAID over HDs of 2 of these Promise PCI Cards,
the system freeze EVERYTIME.
System used: Debian sarge, fresh install from friday, raidtools2 and
kerne 2.4.27

Does ANYONE have any hints?
Or does anyone uses a RAID over 2 or more Promise PCI Cards?

Thx
Lars
- --
- -----------------------------------------------------------------
Technische Universit=E4t Braunschweig, Institut f=FCr Computergraphik
Tel.: +49 531 391-2109            E-Mail: schimmer@cg.cs.tu-bs.de
PGP-Key-ID: 0xB87A0E03


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQFBMudvVguzrLh6DgMRAkkPAJ976uLyoGuuZ+zF3xrBUoQDuyJ/twCdEr0Y
PG8dyWY/4YzEOQenzjMXUOk=3D
=3Dx9wi
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
