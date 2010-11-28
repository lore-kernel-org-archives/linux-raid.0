From: Andreas Rudin <linuxraid@revamp-it.ch>
Subject: understanding RAID1 conf printout in syslog
Date: Sun, 28 Nov 2010 23:45:30 +0100
Message-ID: <4CF2DB8A.5000908@revamp-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I don't find a documentation of the following syslog lines:

RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:1, dev:sda1
 disk 1, wo:0, o:1, dev:sdb1

What is the meaning of wd, rd, wo and o ?

Thanks for your help

Andreas
--=20
revamp-it
Zeughausstrasse 60
8004 Z=C3=BCrich

0041 43 960 32 64
sip:arevamp@ekiga.net
skype: arevamp

www.revamp-it.ch
https://wiki.ubuntu.com/AndreasRudin
OpenPGP public key: www.revamp-it.ch/keys/Andreas_Rudin_0xBACC2013_pub.=
asc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
