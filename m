From: "Scott T. Smith" <scott@gelatinous.com>
Subject: 3ware drive hotswapping
Date: Mon, 21 Jun 2004 18:05:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1087866357.8757.98.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm testing the ability of a 3ware 8506 card to hotswap SATA drives in
JBOD mode, and I'm having problems.

When I remove the drive, the device becomes inaccessible -- that's
obvious.  However, when I reinsert the drive, I can't access it.  I've
tried echoing 'scsi remove-single-device W X Y Z' followed by 'scsi
add-single-device W X Y Z'; the remove causes the /dev/sd* devices to
disappear, but the add does not create any /dev/sd* entries (I'm using
devfs -- though trying to access the devices through a mknod'd block
device doesn't help either).

What is the correct procedure to get a 2.6 kernel to integrate drives?

	Scott


