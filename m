From: Seblu <seblu@seblu.net>
Subject: Mdadm, udev and fakeraid?
Date: Sun, 3 Apr 2011 18:03:50 +0200
Message-ID: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

In the following commit, udev rules load isw_raid (fakeraid). From my
test, this doesnt work. I have to call dmraid to have something
working.
http://neil.brown.name/git?p=3Dmdadm;a=3Dcommit;h=3D475a01b8bce8575dd1b=
2ab6495e65e854702ac0e

isw_raid is only fakeraid devices? mdadm is able to mount fakeraid part=
ition?

Regards,

--=20
S=E9bastien Luttringer
www.seblu.net
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
