From: Lars Schimmer <schimmer@cgv.tugraz.at>
Subject: Fun with raid...
Date: Tue, 02 Aug 2005 14:00:05 +0200
Message-ID: <42EF6045.9020204@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Software RAID and the hell with IDE drives...
I built a software raid 5 with 9 disks, over that md0 I buitl a dmcrypt
partition and it went well for a year.
Now, after moving the PC some miles away, the fun started. First
everything was OK, RAID started and worked well. After a night one HD
backed off, mdadm won't let that HD be part of the raid, although
nothing changed on the HD and it seems to still works fine.
OK, chnaged that HD with a new one and try to reconstruct the RAID.
And bingo, after 80% of reconstruct I get another drive ready, seek
complete error of another HD, so that I can't reconstruct the raid.
But the raid starts in first place.
What to do best now? Start raid and copy all data to some other HDs?
try to recover the raid?

Cya
Lars
- --
- ----------------------------------------------------------
TU Graz, Institut f=FCr Wissensmanagement und Visualisierung
Tel.: +43 316 873-5405      E-Mail: schimmer@cgv.tugraz.at
PGP-Key-ID: 0xB87A0E03
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFC72BFVguzrLh6DgMRAjwnAJ9lvghgXZKWFQPTWc3WIKIfk/ilWACfZoeC
A+/H/mJyX4vXiBqE6r2zH38=3D
=3D5bHA
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
