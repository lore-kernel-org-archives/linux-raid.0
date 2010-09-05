From: Ondrej Jombik <jombik@platon.org>
Subject: RAID-10: changing one (non-failed) drive for another
Date: Sun, 5 Sep 2010 22:08:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1009052203030.6942@athena.platon.sk>
Reply-To: Ondrej Jombik <jombik@platon.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[ Please Cc me in the answer as I'm not in the list ]

We have working mdadm RAID-10 (2 near, 32k chunks) with these drives:

     sda: 250G
     sdb: 250G
     sdc: 160G
     sdd: 160G

Since we would like get more free space, so we need to change our 160G
drives (sdc, sdd) to bigger one.

Is there a way how to switch/change drive in RAID-10 without having RAID
degraded for a while? I simply do not want manually fail any of these
drives.

Option --grow for mdadm is not working for RAID-10 (this is probably
desirable feature). I wonder if there is anything different which we
might give a try.

Thank you

Ondrej

[ Please Cc me in the answer as I'm not in the list ]

--
Ondrej JOMBIK
Platon Technologies Ltd., Hlavna 3, Sala SK-92701
+421 903 PLATON - info@platon.org - http://platon.org

