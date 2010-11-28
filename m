From: hansbkk@gmail.com
Subject: RAID10 striping vs LVM striping over RAID1 (noob)
Date: Sun, 28 Nov 2010 17:30:58 +0700
Message-ID: <AANLkTinW4sxsii=g-4hG_qSMjvyLk92XQPb5HHtGFT94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
List-Id: linux-raid.ids

I'm building a filer on a limited budget with two sets of SATAII
disks, one made of 6x500GB, the other 4x2TB and a recent kernel.

I understand that LVM over software RAID is the way to go, but I'm not
clear on which of the following two scenarios would be "better" - data
availability, flexibility in handling future space expansion and ease
of recovery are more important than performance issues for me, but of
course I'd like to optimize for both if possible.

(ASCII art best viewed with a monospaced font)

Scenario A is traditional RAID1 mirroring, letting LVM handling the striping.
 ________________________________________________
|                      LVM VG                    |
|  _____________   _____________   ____________  |
| |   LVM PV1   | |   LVM PV2   | |   LVM PV3  | |
| | ___________ | | ___________ | | ___________| |
| ||   RAID1   || ||   RAID1   || ||   RAID1   | |
| ||  __   __  || ||  __   __  || ||  __   __  | |
| || |__| |__| || || |__| |__| || || |__| |__| | |
| ||___________|| ||___________|| ||___________| |
| |_____________| |_____________| |____________| |
|________________________________________________|



Scenario B is making use of RAID10 (the mdm-specific one, not generic
RAID1+0, probably the ",f2" flavor) to handle the striping, presenting
one physical disk to LVM to use as a PV.
   _______________
  |  LVM PV = VG  |
  |  ___________  |
  | | RAID10,f2 | |
  | |  __   __  | |
  | | |__| |__| | |
  | |  __   __  | |
  | | |__| |__| | |
  | |  __   __  | |
  | | |__| |__| | |
  | |___________| |
  |_______________|


If I should go with A, then my next question is - does LVM
automatically optimize the striping for performance, or should I
"help" it by created multiple PVs by slicing the disks up into
partitions? If the latter, then that seems to sacrifice a lot of A's
simplicity and perhaps greater ease of data recovery.

Any and all feedback welcome, TIA.
