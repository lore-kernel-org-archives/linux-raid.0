From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Subject: mdadm problems with partitioned md devices
Date: Tue, 23 Nov 2004 21:06:30 +0100
Message-ID: <41A39846.9070002@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

[please CC: me]
while trying to use md to overcome limitations of dm, I
stumbled upon the following problem: It is impossible to
have more than 4 partitioned md devices since mdadm will
create the 5th device with major:minor 255:0, which is
bogus.

Way to reproduce the problem:

linux:~ # mdadm --stop --scan
linux:~ # rm /dev/md_d*
linux:~ # sync
linux:~ # mdadm -B /dev/md_d0 -f -l linear -n 1 -ap63 /dev/hdb5
mdadm: array /dev/md_d0 built and started.
linux:~ # mdadm -B /dev/md_d1 -f -l linear -n 1 -ap63 /dev/hdb6
mdadm: array /dev/md_d1 built and started.
linux:~ # mdadm -B /dev/md_d2 -f -l linear -n 1 -ap63 /dev/hdb7
mdadm: array /dev/md_d2 built and started.
linux:~ # mdadm -B /dev/md_d3 -f -l linear -n 1 -ap63 /dev/hdb8
mdadm: array /dev/md_d3 built and started.
linux:~ # mdadm -B /dev/md_d4 -f -l linear -n 1 -ap63 /dev/hdb9
mdadm: error opening /dev/md_d4: No such device or address
linux:~ # mdadm --version
mdadm - v1.8.1 - 05 November 2004
linux:~ # uname -a
Linux linux 2.6.10-rc2suseconfig #5 Tue Nov 23 14:12:13 CET 2004 i686 i686 i386 GNU/Linux
linux:~ #

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
