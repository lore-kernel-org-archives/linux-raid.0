From: Randy Terbush <randy@terbush.org>
Subject: Different output from mdadm --scan
Date: Sat, 20 Mar 2010 23:07:14 -0600
Message-ID: <7db987b31003202207w76068ed1ub3e139317d9e13aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can someone explain why the following different outputs from the two
mdadm --scan commands and which one is the appropriate entry in
mdadm.conf?

mdadm --version
mdadm - v3.1.1 - 19th November 2009

#=A0mdadm --examine --scan /dev/sd*
ARRAY /dev/md/0 metadata=3D1.1 UUID=3Db411b304:6385f171:26f07cb1:3c2b03=
de
name=3Dhifi:0

#=A0mdadm --detail --scan
ARRAY /dev/md0 metadata=3D1.01 name=3Dhifi:0
UUID=3Db411b304:6385f171:26f07cb1:3c2b03de

metadata attribute being the primary difference.

Thanks

--
Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
