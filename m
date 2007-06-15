From: "Thorsten Wolf" <T_Wolf@gmx.net>
Subject: need help in recovering a RAID
Date: Fri, 15 Jun 2007 10:16:02 +0200
Message-ID: <20070615081602.287850@gmx.net>
References: <20070612072408.19140@gmx.net>
 <18030.19615.898281.457910@notabene.brown> <466ED030.1000004@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <466ED030.1000004@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again, everyone.

I've been really busy playing and working with mdadm tools lately. And =
I've come across a problem which I haven't been able to solve myself so=
 far.

My system looks like this:
IDE:
/dev/hda1   -->   /      100 GB
/dev/hda2   -->   SWAP     1 GB
/dev/hda3   -->   /home  395 GB

S-ATA onboard:
/dev/hde1   -->   Disk 0 on /dev/md0
/dev/hdg1   -->   Disk 1 on /dev/md0
/dev/hdi1   -->   Disk 2 on /dev/md0
/dev/hdk1   -->   Disk 3 on /dev/md0

/dev/md0    --> via LVG mounted as /raid

A loose cable caused hdi and hdk to go offline. The server itself was s=
hut down 1 minute later.

But I can't access the raid anymore because it marked the disks as fail=
ed. There was no write access to the system when the power went down on=
 the two disks.

How can I mark them as online (I'm pretty sure the data is still ok) ??=
?

I really want to get the raid working again as I think this is a good s=
cenario that I'd like to be able to handle in the future.

Regards,

Thorsten
--=20
Contact me on ICQ: 7656468
skype://sysfried

Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!=20
Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
