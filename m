From: "Thomas Gebhardt" <gebhardt@HRZ.Uni-Marburg.DE>
Subject: md.c Kernel BUG(?) and reboot segfault
Date: Thu, 24 Oct 2002 15:15:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210241315.g9ODFKGV028540@pcrz175.hrz.uni-marburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

just tried to configure rootfs Software-RAID1 on a Debian Woody
(SMP-Kernel 2.4.19 with some of the jp Patches applied). When I reboot
the machine, the final reboot command in /etc/init.d/reboot
segfaults after the following error messages:

md: stopping all md devices
invalidate; busy buffer
...
md: marking sb clean
kernel BUG at md.c:1251!
invalid operand: 0000
CPU:  1
EIP:  0010: [<c02080a2>]   Not tainted
EFLAGS:  00010202
...
Segmentation fault

A second reboot command succeeds. So, as a workaround, I duplicated
the reboot command in /etc/init.d/reboot in order to shut the
system down without manual interaction.

Any hints what to do?

Thank you for your advice!
Cheers, Thomas



