From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Raid5 & Debian Yaird Woes
Date: Fri, 3 Feb 2006 12:29:36 +1100
Message-ID: <200602031229.37972.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dr@jones.dk
List-Id: linux-raid.ids

Hi All,

I'm trying to get my head around the way that the new debian initrd system
"yaird" and mdadm.conf interact.
While running raid5 with yaird, I've discovered that if I replace or remove a
healthy drive, without manually using mdadm --set-faulty, the system will not
reboot. I get startup messages stating waiting  X seconds for /dev/sdc,
eventually dropping me into a useless (for raid purposes) maintenance shell.
If I continue to boot via use of  'ctrl D', the system kernel panics, telling
me in has 2/3 members but needs all 3.  This seriously impacts the benefit of
using raid5.
Problems also occurs if the disk is replaced, and the raid reconstructed
(using an alternate kernel initrd), somehow the new replacement drive is set
as faulty again, during startup ...resulting in the failure described above,
unless I first create a fresh yaird initrd.img via re-installation of the
kernel.deb prior to the system restart.
My mdadm.conf (I never needed to use at all previous to the yaird system) is
as follows...
ARRAY /dev/md0 level=raid1 num-devices=3 devices=/dev/sda2,/dev/sdb2,/dev/sdc2
auto=yes
ARRAY /dev/md1 level=raid5 num-devices=3 auto=yes
UUID=a3452240:a1578a31:737679af:58f53690
DEVICE partitions

The yaird documentation recommended at the use of at least auto=md, but the
use of results in errors (auto=md unknown something or other) that cause
kernel installation to fail.

Hoping someone can ease my pain here?

Cheers,

Lewis
