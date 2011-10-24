From: Michael Busby <michael.a.busby@gmail.com>
Subject: Converting from Raid 5 to 6
Date: Mon, 24 Oct 2011 14:11:34 +0100
Message-ID: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At the moment i have a raid5 setup with 5 disks, i am looking=A0to add =
a
6th disk and change from raid 5 to raid 6

having looked at Neil's site i have found the following command, and
just want to double check this is still the recommend way of
converting

mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-file=3D/hom=
e/md.backup

also would i need to add the extra disk before or after the command?

cheers
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
