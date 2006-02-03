From: "JaniD++" <djani22@dynamicweb.hu>
Subject: raid 4, and bitmap.
Date: Fri, 3 Feb 2006 01:04:07 +0100
Message-ID: <04c201c62855$5efda450$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list, Neil,

I try to add bitmaps to raid4, and mdadm is done this fine.
In the /proc/mdstat shows this, and it is really works well.

But on reboot, the kernel drops the bitmap(, and resync the entire array if
it is unclean). :(

It is still uncomplete now? (2.6.16-rc1)

Thanks,
Janos

