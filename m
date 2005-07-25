From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: strange SATA phenomenon
Date: Mon, 25 Jul 2005 12:21:45 +0200
Message-ID: <633351412.20050725122145@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I don't know if this problem is raid related, but chances are high:

I try to install linux (centros 4.0, fedora core 4, 3) on an HP
proliant DL140 G2 (2.8 GHz xeon, 2 SATA ports, 1 PATA port). 2 160 GB
SATA disks in raid-1, 5.25" CD rom drive temporarily connected to PATA
port.

- if the 2 SATA disks AND the cdrom drive are connected, the system
boots smoothly, runs fine & fast

- if I disconnect the cdrom drive (leaving only the 2 SATA raid-1
disks connected), the server claims something like "losing to many
ticks" during boot, the server reacts extremely slow (like typing over
a 300 baud line), has a high system load, needs 13 hours to sync a
100GB raid-1 partition).

- if I also disconnect the 2nd sata drive (leaving only the 1st sata
drive connected), the system boots in degraded mode, but is quick and
fast as expected.

I also bought and attached two 200GB SATA disks since I assumed the 160GB drives may
cause the problem, but it's the same, either with the 200GB oder the
160GB drives.

another strange thing: Centos installer / diskdruid shows the drives
as sda/sdb, but the kernel messages during bootup show them as
hda/hdc.

any ideas ? tnx in advance.

-- 
Best regards,
 Rainer                          mailto:rfu@kaneda.iguw.tuwien.ac.at

