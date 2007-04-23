From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: mkinitrd and RAID6 on FC5
Date: Mon, 23 Apr 2007 01:11:27 -0400
Message-ID: <200704230511.l3N5BW701448@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For many months now my FC5 can't do mkinitrd automatically when I upgrade
the kernel.  Well it does make the initrd, but will not boot.

It seems the modules raid4, raid5 and raid6 have been combined into 1 module
raid456.

My "/" filesystem is RAID6.  I am guessing this is the problem.  If so, I
guess anyone using RAID4, 5 or 6 would have this problem.

I found out how to manually create the initrd:
mkinitrd -v -f --with=raid456 /boot/initrd-2.6.20-1.2307.fc5smp.img
2.6.20-1.2307.fc5smp

There is a bugzilla number/url:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=211030

That bugzilla was opened over six months ago.

Is this ever going to be fixed?

Is this a REDHAT only problem/bug?  If so, since bugzilla.redhat.com gets
ignored, where do I complain?

Sorry to sound rude.  md has been good to me for years now, but this issue
has caused me some headaches that I don't need!

Thanks,
Guy

