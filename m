From: Felix Miata <mrmazda@ij.net>
Subject: make hpt37xx fails
Date: Fri, 09 Apr 2004 14:58:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4076F259.196B@ij.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Windoze is already installed on the motherboard ataraid (hde/hdg) on a
Soyo KT400 Dragon black. I've installed Mandrake 10 on /dev/hde, which
Mandrake thinks is /dev/hda. I compiled a kernel without native hpt37xx
driver. I downloaded the hpt driver source
http://www.highpoint-tech.com/BIOS%20%2B%20Driver/hpt372/Linux/hpt3xx-opensource-v1.35.tgz.
In it, the readme file says to:

# make KERNELDIR=/usr/src/linux-2.6.3-7mdk

When I do this, a bunch of messages scroll, ending with:

hpt.c:4824: warning: data definition has no type or storage class
hpt.c:4753: warning: `hpt_scsi_unregister_module' defined but not used
make: *** [hpt.o] Error 1

What does this mean? How do I fix it? Where is this info scrolled off
the screen too fast to read logged for later inspection?
-- 
"Each one should use whatever gift he has received to serve others..."
                                                1 Peter 4:10 NIV

 Team OS/2 ** Reg. Linux User #211409

Felix Miata  ***  http://members.ij.net/mrmazda/

