From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: How can I see if a (disk) block device is in use?
Date: Tue, 9 Oct 2007 17:07:20 +0200
Message-ID: <c384c5ea0710090807g222bddedhbd3aaf11874de0fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

from userspace, how can I reliably see if a (hard disk) block device
(say /dev/sda) is in use (either by the kernel, say through md or by
any userspace application such as dd)?

I would like to perform this check in a generic way, i.e. not per-se md related.


Although the question is non-md specific, it is slightly related to
this behaviour:

$sfdisk -R /dev/sdb
<race condition>
$mdadm --assemble /dev/md0 --run /dev/sda /dev/sdb /dev/sdc

mdadm: cannot open device /dev/sdc1: No such file or directory
mdadm: /dev/sdc1 has no superblock - assembly aborted

$sfdisk -R /dev/sdb
<race condition>
$sleep 1
$mdadm --assemble /dev/md0 --run /dev/sda /dev/sdb /dev/sdc

this works


Regards,
-- 
Leon
