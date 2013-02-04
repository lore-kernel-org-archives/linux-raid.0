From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: What layout with 6x2TB, Intel Atom?
Date: Mon, 4 Feb 2013 20:27:42 +0000
Message-ID: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

I've an Intel Atom 330 running 32-bit Ubuntu, ~3.5GB RAM. The intent
is to store large media files (>4GB) for streaming by maximum 3
clients at any time. Very read heavy.
6x 2TB HDDs are available, the crux is that 3 HDDs are on the on-board
SATA controller, the other 3 are on a Marvel PCI-E adapter

cat /proc/mdstat

Personalities : [raid10]
md125 : active raid10 sdg[1] sdf[0]
      1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
      [>....................]  resync =  1.1% (22074880/1953382400)
finish=642.2min speed=50114K/sec

md126 : active raid10 sde[1] sdd[0]
      1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
      [>....................]  resync =  1.6% (31473408/1953382400)
finish=398.6min speed=80354K/sec

md127 : active raid10 sdc[1] sdb[0]
      1953382400 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
      [>....................]  resync =  1.1% (22630912/1953382400)
finish=617.9min speed=52073K/sec

unused devices: <none>

create commands:
  105  sudo mdadm --verbose --create md0 --level=10 --layout=f2
--raid-devices=2 /dev/sdb /dev/sdc
  106  sudo mdadm --verbose --create md1 --level=10 --layout=f2
--raid-devices=2 /dev/sdd /dev/sde
  107  sudo mdadm --verbose --create md2 --level=10 --layout=f2
--raid-devices=2 /dev/sdf /dev/sdg
  111  sudo mdadm --verbose --create md3 --level=10 --layout=f2
--raid-devices=3 /dev/md/md0 /dev/md/md1 /dev/md/md2
  118  sudo mdadm --stop /dev/md124 # to stop seek of death until the
above finishes resyncing

I read that the far layout gives faster read performance compared to
standard RAID1 in a 2 HDD array, so that's why I used it. I then
created yet another RAID10 f2 layout of the 3x 2 disk RAID10 volumes,
giving me /dev/md124. Filesystem doesn't matter, I need something
that's stable with good performance over the RAID set.
I just realized that out of 12 TB raw space I now only have 3TB
available, heh. So I suppose I'm going for a different layout.

Any opinions?

Cheers,
Mathias
