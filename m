From: David Cure <lnk@cure.nom.fr>
Subject: max number of devices in raid6 array
Date: Wed, 12 Aug 2009 11:06:00 +0200
Message-ID: <20090812090600.GF21118@nfs-rbx.ovh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


		Hello,

	I want to create an raid6 array and I see an limit of number of
devices : with 27 devices the array is created, and with 28 I've got
this error :
mdadm: invalid number of raid devices: 28

	I use kernel 2.6.30 (from backport) and mdadm - v2.6.7.2 - 14th
November 2008 on Debian Lenny.

	Is there a way to pass out this limit ?

	Thanks,

	David.

PS: I'm not subscribed of linux-raid (only linux-kernel) so please copy
your answer to my mail.
