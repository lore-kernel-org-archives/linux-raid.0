From: Gordon Henderson <gordon@drogon.net>
Subject: raid5: switching cache buffer size
Date: Fri, 13 Dec 2002 15:38:35 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0212131530510.6085-100000@unicorn.drogon.net>
References: <Pine.LNX.4.43.0212091504450.30636-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0212091504450.30636-100000@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Anyone know what this means?

My big server is currently fscking a lvm partition which sits on-top of a
raid5 device and the console is scrolling these messages as fast as it can.
It says it's switching from 0 to 512, from 512 to 0 and 0 to 1024 ( or
maybe 512 to 1024, its hard to tell).

What's happening and how do I stop it?

Cheers,

Gordon

Ps. earlier FSCK problems seemed to be due to dodgy AMD motherboard
hardware and (U)DMA. It's a documented AMD bug and they have no
workaround, but plugging a ps/2 mouse in seems to fix it...

