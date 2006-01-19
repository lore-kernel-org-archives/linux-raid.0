From: PFC <lists@peufeu.com>
Subject: raid reconstruction speed
Date: Thu, 19 Jan 2006 22:29:37 +0100
Message-ID: <op.s3m9znsqcigqcu@apollo13>
References: <op.s3mjqms2i22er4@xray.bmc.uu.se> <op.s3m7n1pucigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s3m7n1pucigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	Sorry for flooding ;)

	I have the following configuration :
	- two disks (hda and sda)
	- each disk has 2 partitions (hda1/sda1) and (hda2/sda2)
	- two raid1 md devices are made :
	md0 = sda1 + hda1, contains the OS
	md1 = sda2 + hda2, contains a database

	I made 2 devices because I wanted to use different FS's.

	When rebuilding md1, it does not realize accesses to md0 wait for the  
same disks. Thus reconstruction of md1 runs happily at full speed, and the  
machine is dog slow, because the OS and everything is on md0.
	(I cat /dev/zero to a file on md1 to slow the rebuild so it would let me  
start a web browser so I don't get bored to death)

	When rebuilding md0, the rebuild process detects accesses to md0 and  
behaves nicely (the machine is responsive). However, it does not realize  
that md1 is on the same disks, thus the databases are dog slow.

	Fortunately, as the rebuild runs ar full speed, the pain does not last  
long. It took 5 minutes to start this email client though.
	Thought you might wanna know ;)

	Regards,

	Pierre Caillaud
