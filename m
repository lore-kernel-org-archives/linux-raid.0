From: "Scott T. Smith" <scott@gelatinous.com>
Subject: 3ware "hotswapping" JBODs
Date: Wed, 23 Jun 2004 12:48:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088020133.8993.27.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(yes this is different from my problem I had a couple of days ago).

Does 3ware (or any other controller for that matter) let you remove a
disk without telling the controller/driver/OS first?  3ware provides a
utilty to notify the driver that you are about to remove the disk, but I
want to be able to just remove the disk on a whim.

I ran a test using two disks on two separate 3ware controllers.  I ran
two programs -- one would read sequentially from one disk, while the
other would read sequentially from the other disk (which is on the other
controller).

When I forcibly remove the disk, the program reading from that disk
hangs (understandably).  However, about 10-20 seconds later, the kernel
issues a reset (calling the eh_host_reset_handler), and effectively
locks up ALL disk access, even the reads to the separate controller!

Obviously this is a problem for a system that is supposed to be
resilient to failures.  I have a feeling that if a drive failed on me, I
would see the same problem -- SCSI drive errors, followed by a reset. 
It seems that there must be some better way to handle that.

	Scott


