From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: smarter md minor search  than "find_free_devnum" needed
Date: Mon, 23 Jul 2012 15:09:48 +0200
Message-ID: <500D4D1C.6070103@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

I'm thinking about creation of many MD RAID 1 devices by automatic
scripts. The MD minor numbers should be auto-determined. But if I do
this with mdadm 3.2.5 and kernel 3.4.2 without udev, then it gets slowe=
r
the more devices I create. I also had to patch mdadm to make
"--symlinks=3Dno" really work (preventing "/dev/md/*" symlinks to be cr=
eated).

Looks like this:
# MDADM_NO_UDEV=3D1 mdadm -C auto --symlinks=3Dno --assume-clean --forc=
e -l
1 -n 2 /dev/loop$i /dev/loop$j

Btw.: With udev it hangs for some seconds.

With this it is fast but can't use it for production (I only have the
UUIDs):
# MDADM_NO_UDEV=3D1 mdadm -C /dev/md$k --assume-clean --force -l 1 -n 2
/dev/loop$i /dev/loop$j

What about caching the next free minor number in kernel space, taking
it, finding the next free and updating it?
Or is there another possibility (putting this into a custom daemon
should be avoided)?

If I identify the MD devices by UUID, I don't want to care which minor
number they actually have upon creation/assembly.

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer@profitbricks.com

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
