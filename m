From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: How to prevent auto assembly?
Date: Wed, 22 Sep 2010 21:37:22 -0600
Message-ID: <20100923033822.E7819E30965@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I put "AUTO -1.X" in my /etc/mdadm.conf file, to try to prevent my version 1.2 arrays from being automatically assembled. Nevertheless, the arrays were auto-assembled at boot time.

How do I prevent this from happening?

OS:  Linux l1.fu-lab.com 2.6.34.6-47.fc13.i686.PAE #1 SMP Fri Aug 27 09:29:49 UTC 2010 i686 i686 i386 GNU/Linux

MDADM: mdadm - v3.1.2 - 10th March 2010

Arrays are version 1.2.

Thanks!

Jim


