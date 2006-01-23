From: Mario =?UTF-8?B?RMO2cmluZw==?= <mario@dedenet.de>
Subject: mdadm-2.2 - kexec problem/bug
Date: Mon, 23 Jan 2006 12:54:06 +0100
Message-ID: <20060123125406.2055fd44@snibbles.dedenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello :)

when rebooting my gentoo system with mdadm-2.2, I get the following
error message on shutdown:

mdadm: fail to stop array /dev/md0: Device or resource busy
md0 is my root partition


/dev/md0 is my root parition.

That is no problem with a real reboot or shutdown.


But with a "kexec reboot" the rebooted kernel hangs with
several dma and irq errors.

The problem does not exist in version mdadm-2.1


I am not sure if this is the right place for reporting this issue..


Regards,
Mario.
