From: =?ISO-8859-1?Q?Aur=E9lien_Gouny?= <aurelien@gouny.org>
Subject: New RAID-5 800GB array, wich fs ? wich stripe block size ?
Date: Mon, 19 Jul 2004 11:19:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40FB923D.1080903@gouny.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a Promise SX6000 card and i juste have bought 6x160 GB HDs that=20
make a 800 GB RAID-5 array.
I was wondering wich filesytem I should use (ext3/reiserfs/xfs/jfs/...)=
,=20
if I should make one or more partitions and wich stripe block size to=20
use knowing that:

- it will be mainly a file-server with mp3s, divx, pictures (1 to 4MB=20
each) and some files (openoffice, ...) all shared with Samba.
- it will have a small postgresql database

If someone need more information in order to determine the stripe block=
=20
size or else, just ask ;)

Thanks a lot, (sorry for bad english)
Aur=E9lien
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
