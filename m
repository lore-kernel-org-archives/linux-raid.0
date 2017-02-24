From: <ian_bruce@mail.ru>
Subject: [BUG] non-metadata arrays cannot use more than 27 component devices
Date: Fri, 24 Feb 2017 04:08:16 -0800
Message-ID: <20170224040816.41f2f372.ian_bruce@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When assembling non-metadata arrays ("mdadm --build"), the in-kernel
superblock apparently defaults to the MD-RAID v0.90 type. This imposes a
maximum of 27 component block devices, presumably as well as limits on
device size.

mdadm does not allow you to override this default, by specifying the
v1.2 superblock. It is not clear whether mdadm tells the kernel to use
the v0.90 superblock, or the kernel assumes this by itself. One or other
of them should be fixed; there does not appear to be any reason why the
v1.2 superblock should not be the default in this case.

details are here:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=855871

This problem is easy to reproduce, even with simple hardware. You can
use /dev/loop devices as the array components, as explained in the link.


-- Ian Bruce
