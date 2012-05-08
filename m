From: "Johnson Yan" <johnson_yan@usish.com>
Subject: mdadm v3.1.3 spare group does not work
Date: Tue, 8 May 2012 09:57:57 +0800
Message-ID: <002b01cd2cbd$fd6ea3a0$f84beae0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
When I use mdadm v3.1.3, seems the spare group function can=92t work. A=
s I
remember, this function in mdadm 2.6.5 works well.


Here is some info from /etc/mdadm.conf
=85
ARRAY /dev/md0 level=3Draid1 spare-group=3Dtest11
ARRAY /dev/md1 level=3Draid1 spare-group=3Dtest11
=85


And mdmonitor service is in running status:
[root@localhost tmp]# ps aux |grep mdadm
root=A0=A0=A0=A0=A0 1794=A0 0.0=A0 0.0=A0=A0 6852=A0=A0 760 ?=A0=A0=A0=A0=
=A0=A0=A0 Ss=A0=A0 16:52=A0=A0 0:00 mdadm -F -y
-f -s -i /var/run/mdadm/mdadm.pid --delay=3D10

There is one spare disk in md0, and no spare in md1, if I fail the memb=
er
disk in md1, the spare in md0 won=92t migrate into md1.

Thank you very much.

Regards,
Johnson Yan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
