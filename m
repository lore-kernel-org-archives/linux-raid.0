From: comsatcat <comsatcat@earthlink.net>
Subject: Busted disks caused healthy ones to fail
Date: Mon, 13 Dec 2004 23:42:07 -0700
Message-ID: <1103006528.8141.15.camel@solaris.skunkware.org>
Reply-To: comsatcat@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

An odd thing happened this weekend.  We were doing some heavy I/O when
one of our servers had two drives in two seperate raid1 mirrors pop.
This was not odd as these drives are old and the batch they are from
have been failing on other boxen as well.  What is odd is that our brand
new disks which the OS resides on (2 drives in raid 1) half busted.

There are 4 md devices

md/0  
md/1
md/2
md/3

md3, md2, and md1 all lost the 2nd drive in the array (sdh3, sdh6, and
sdh5).  md0 however was fine with sdh1 being fine.  Why would losing
disks cause a seemingly healthy disk to go astray?

P.S. I have pull out tons of syslogs showing the two bad disks failing
if that would help.


Thanks,
Ben

