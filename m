From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: question about raid10 near copy info in man mdadm.
Date: Mon, 16 Apr 2012 13:28:14 +0800
Message-ID: <201204161328097657740@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi:
	I readed the information about raid10 near copy in man mdadm.
	It is:
	'n' signals 'near' copies.  Multiple copies of one data block are at similar offsets in different
              devices.
	But I think this wrong.
	If raid10 had five disks and near copy is equal three.
	The layout like:
			5 disks
--------------------
A1 A1 A1 A2 A2
A2 A3 A3 A3 A4

But the copies of datablock A2 are not at similar offset in different device.

 				
--------------
kedacomkernel
2012-04-16

