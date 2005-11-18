From: Jure =?UTF-8?Q?Pe=C4=8Dar?= <pegasus@nerv.eu.org>
Subject: raid5 write performance
Date: Fri, 18 Nov 2005 15:05:43 +0100
Message-ID: <20051118150543.59fbdfd9.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

Currently zfs is a major news in the storage area. It is very interesti=
ng to read various details about it on varios blogs of Sun employees. A=
mong the more interesting I found was this:

http://blogs.sun.com/roller/page/bonwick?entry=3Draid_z

The point the guy makes is that it is impossible to atomically both wri=
te data and update parity, which leaves a window of crash that would si=
lently leave on-disk data+paritiy in an inconsistent state. Then he men=
tions that there are software only workarounds for that but that they a=
re very very slow.

It's interesting that my expirience with veritas raid5 for example is j=
ust that: slow to the point of being unuseable. Now, I'm wondering what=
 kind of magic does linux md raid5 does, since its write performance is=
 quite good? Or, does it actually do something regarding this? :)

Niel?

--=20

Jure Pe=C4=8Dar
http://jure.pecar.org

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
