From: "Adam Radford" <aradford@amcc.com>
Subject: RE: 3ware drive hotswapping
Date: Mon, 21 Jun 2004 18:17:41 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <HZORLD00.NTI@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Scott T. Smith" <scott@gelatinous.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please make sure that:

1. You have support for /proc/scsi turned on in your kernel.
2. You have powered the drive back on after re-insertion.
3. You have a 3ware driver >= v1.02.00.032.

If it still doesn't work, email support@3ware.com

-Adam

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Scott T. Smith
Sent: Monday, June 21, 2004 6:06 PM
To: linux-raid@vger.kernel.org
Subject: 3ware drive hotswapping


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


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

