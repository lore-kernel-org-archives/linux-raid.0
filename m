From: goldfita@signalsguru.net
Subject: raid 5 corruption
Date: Wed, 8 Mar 2006 00:58:47 -0500 (EST)
Message-ID: <37363.127.0.0.1.1141797527.squirrel@a2s5.a2hosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I posted this on the gentoo forum, but I don't think anyone there will be
able to help.  I can't mount my raid drive.  There was no crash, but it
seems to be corrupt.  I just want to know if I can repair it.  What I don't
understand is why it's looking for  a superblock on the individual drives.
The file system is on the raid device.  Isn't that where the superblock is
(instead of the individual disks)?  Can I run reiserfsck on the array
without being able to assemble it?

http://forums.gentoo.org/viewtopic-p-3164469.html#3164469

-Todd
