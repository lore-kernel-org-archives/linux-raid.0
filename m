From: "John Andre Taule" <post@johnandre.net>
Subject: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 08:38:19 +0100
Message-ID: <020601d04c17$08c10290$1a4307b0$@johnandre.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: no
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Case: mdadm Raid 5 4 2TB disks. ext4 formatted spanning the raid.
Attack: dd if=/dev/zero of=/dev/sdb bs=1M

Expected result would be a raid that could be recovered without data loss.

Result was that the file system failed and not possible to recover. 

As I understand it if this was a "hardware type fake" raid controller, the
outcome would be uncertain. However I'm a bit confused as to why the raid
(or more specifically the file system) would fail so horrible when losing
one disk. Is there perhaps critical information written "outside" the raid
on the physical disk, and this where overwritten in the attack?

It would be nice to have an exact idea as to why it failed so hard, and how
obvious it should be that this attack would have more consequence then a
degraded raid.

//Regards


