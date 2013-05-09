From: Ricky Burgin <ricky@burg.in>
Subject: mdraid autodetect partially failing after disk replacement
Date: Thu, 09 May 2013 02:20:43 +0100
Message-ID: <518AF9EB.7040402@burg.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again,

Little bit of progress since I last dropped a message in (sorry for the
duplicate, didn't think the initial one got through).

The kernel has mdraid built into it and all disks are using 0.90
superblocks, all 'fd' partitions, but only 2 or 4 disks are being
recognised and applied to the freshly created raid array which works
fine when mounted on any other OS.

Any suggestions for what could cause disks to be overlooked by mdraid
before the root device is even attempted to be mounted would be very
helpful, I'm now totally at a loss as to what to do from here.

Kind regards,
Ricky Burgin
