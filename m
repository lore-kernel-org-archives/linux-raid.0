From: Krzysztof Oledzki <ole+md@ans.pl>
Subject: Problem with UUID on mdadm v1.8.1
Date: Mon, 10 Jan 2005 10:46:33 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501101041410.4124@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1735576636-1105350393=:4124"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1735576636-1105350393=:4124
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I have just upgraded mdadm from v1.8.0 to v1.8.1 and now, each time when I=
=20
create new array, it contains the same UUID:
6b8b4567:327b23c6:643c9869:66334873.

root@fw1:~# mdadm --stop /dev/md6;echo y|mdadm --create /dev/md6 --level=3D=
1 --raid-disks=3D2 /dev/sd[ab]7;mdadm -D /dev/md6|grep UUID
mdadm: /dev/sda7 appears to be part of a raid array:
     level=3D1 devices=3D2 ctime=3DMon Jan 10 09:45:29 2005
mdadm: /dev/sdb7 appears to be part of a raid array:
     level=3D1 devices=3D2 ctime=3DMon Jan 10 09:45:29 2005
Continue creating array? VERS =3D 9001
mdadm: array /dev/md6 started.
            UUID : 6b8b4567:327b23c6:643c9869:66334873

root@fw1:~# mdadm --stop /dev/md6;echo y|mdadm --create /dev/md6 --level=3D=
1 --raid-disks=3D2 /dev/sd[ab]7;mdadm -D /dev/md6|grep UUID
mdadm: /dev/sda7 appears to be part of a raid array:
     level=3D1 devices=3D2 ctime=3DMon Jan 10 09:45:33 2005
mdadm: /dev/sdb7 appears to be part of a raid array:
     level=3D1 devices=3D2 ctime=3DMon Jan 10 09:45:33 2005
Continue creating array? VERS =3D 9001
mdadm: array /dev/md6 started.
            UUID : 6b8b4567:327b23c6:643c9869:66334873


Od version (v1.8.0) works just fine.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1735576636-1105350393=:4124--
