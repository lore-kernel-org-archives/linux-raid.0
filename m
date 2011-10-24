From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Bad block management - which mdadm?
Date: Mon, 24 Oct 2011 22:12:14 +0200
Message-ID: <201110242212.14934.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


kernelnewbies.org reports such feature for 3.1 kernel

1.9. Software RAID: Bad block management
The MD layer (aka "Multiple Devices", aka software raid) has gained bad=
 block=20
management support: bad blocks will be added to a list, and the system =
will=20
try not to use them. This feature requires an updated mdadm version.

Which mdadm supports that?

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
