From: Zeno Davatz <zdavatz@generika.cc>
Subject: root=/dev/hda2
Date: 08 May 2003 17:35:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052408158.846.58.camel@zrr>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List

I am trying to get my RAID 1 up and running.

My lilo.conf has
boot=/dev/hda
root=/dev/hda2

When the kernel boots and I logged in 'df' gives me:
/dev/md0

When I put root=/dev/md0 in my lilo.conf I get a Kernel panic when I try
to reboot.

md is loaded over /etc/mkinitrd/modules into the RAM disk.

Thanks in advance for any help and hints.

Zeno


