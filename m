From: stephan sperber <quinte17@gmx.de>
Subject: raid5e and raid5ee
Date: Thu, 01 Jun 2006 11:59:14 +0200
Message-ID: <20060601095914.72770@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This topic is quite interresting.
I found some information about raid5e and raid5ee only on the german wi=
kipedia, but the pictures could do just fine.

http://de.wikipedia.org/wiki/RAID#RAID_5E
http://de.wikipedia.org/wiki/Bild:RAID_5E.png
http://de.wikipedia.org/wiki/Bild:RAID_5EE.png

as i understand it, there is no real raid5 in place.
raid5ee is basically a simple raid5 with 4 discs, but leaving the 4. di=
sk virtually empty. so if 1 disk fails, the empty stripes are filled.

i dont know much about this topic, and i dont know if the information i=
n wikipedia is correct, but i hope i could help a bit

yours

stephan
--=20


Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
      Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
   =20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
