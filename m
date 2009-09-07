From: jahammonds prost <gmitch64@yahoo.com>
Subject: Array Power Management
Date: Sun, 6 Sep 2009 20:48:03 -0700 (PDT)
Message-ID: <292245.77763.qm@web55804.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been becoming interested in the power consumption of the arrays I =
have on a couple of servers here that are basically used as media serve=
rs. Since they're not being used when I'm at work, I was looking at the=
 possibility of spinning the disks down during certain times, and havin=
g them either spin up at a set time, or (ideally), when there is disk a=
ctivity.

I can do this on single drives using hdparm -S to set the spindown time=
out, and the disks will spin up on activity as needed. Is there somethi=
ng similar I can do with an md array? I can see there's a /sys/block/md=
0/power/wakeup file, but I can't seem to find any documentation on it. =
I have thought about doing an hdparm -S on the array disks, but I suspe=
ct that would be A Bad Thing (tm).

Does anyone have any advice/pointers? The servers are currently running=
 fc9 - I'd like them to be Centos, but had to go with fc9, as I=A0neede=
d Port Multiplier support.


Graham


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
