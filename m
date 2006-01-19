From: PFC <lists@peufeu.com>
Subject: attempt to access beyond end of device
Date: Thu, 19 Jan 2006 21:39:27 +0100
Message-ID: <op.s3m7n1pucigqcu@apollo13>
References: <op.s3mjqms2i22er4@xray.bmc.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s3mjqms2i22er4@xray.bmc.uu.se>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	OK, I was a bit stupid...

	I changed a drive today, so I rebuilt a software RAID1.
	I have a RAID1 in degraded mode (1 out of 2 drives), and I added a new  
partition to it. When I say I was stupid, I mean the partition I added was  
a tiny little bit smaller than what it should have been.

	md happily added it, synced, then at the very end :

Jan 19 21:33:27 apollo13 attempt to access beyond end of device
Jan 19 21:33:27 apollo13 sda7: rw=1, want=12498560, limit=12498507
Jan 19 21:33:27 apollo13 raid1: Disk failure on sda7, disabling device.
Jan 19 21:33:27 apollo13        Operation continuing on 1 devices

	Of course, "attempt to access beyond end of device", I made the device  
too small. Duh.

	No problem, I'll just fix my partition, but a warning message on the  
mdadm --add would have avoided losing time doing the sync, and at the end,  
a few seconds of "WTF ? it failed ? ah, ok..."

	Have a nice day !


mdadm --version
mdadm - v2.1 - 12 September 2005
