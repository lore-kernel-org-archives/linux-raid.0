From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: mdadm 3.0: segfault. known issue?
Date: Mon, 21 Sep 2009 14:13:24 -0500
Message-ID: <cccedfc60909211213q2b0d595cmd721264b1e843da4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On one machine I have, mdadm (3.0) segfaults every time the machine is booted.
After boot, the same commandline appears to work just fine.

From the boot messages:

<6>mdadm[1815]: segfault at 5c ip 000000000041f2b3 sp 00007fffb3b62c80
error 4 in mdadm[400000+40000]

and more:

Starting MD Raid mdadm: /dev/md/turnip:12 has been started with 1
drive (out of 2).
/etc/init.d/boot.d/S07boot.md: line 97:  1815 Segmentation fault
$mdadm_BIN -A -s -c $mdadm_CONFIG
failed




-- 
Jon
