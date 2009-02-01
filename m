From: "GeneralNMX" <generalmx@gmail.com>
Subject: Raid starts dirty every boot on Ubuntu
Date: Sun, 1 Feb 2009 12:23:16 -0500
Message-ID: <004101c98491$c575dd10$50619730$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On my Ubuntu server, ALL my raids start dirty every single time and kic=
ks
one drive (any one of the four), re-adds it, then reconstructs the raid
array. For the example below, this is a raid1 with two spares. =A0When =
it
finishes booting, the device that was kicked is still in the array, as =
a
spare. This makes the boot literally take hours, and I don=92t know exa=
ctly
what it=92s doing since it just sits there without a progress indicator=
=2E I
don=92t think it=92s fsck because it doesn=92t even get to fsck yet in =
the
runlevel. It goes like this:

md: md7 stopped.
md: unbind<sda9>
md: export_rdev(sda9)
md: ubind<sdb9>
md: export_rdev(sdb9)
md: bind<sdc9>
md: bind<sdb9>
md: bind<sdd9>
md: bind<sda9>
md: Kicking non-fresh sdd9 from array!
md: unbind<sdd9>
md: export_rdev(sdd9)
raid1: raid set md7 active with 2 out of 2 mirrors


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
