From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: How do I get rid of md126, md127?
Date: Fri, 14 Jan 2011 20:05:28 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101142004120.31124@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I found this post extremely useful:
https://partner-bugzilla.redhat.com/show_bug.cgi?id=542022

Quoting the above URL:

How to fix the '125/126/127' mdadm issue.

The array has '125' stored as the 'preferred minor' in the metadata.
You can change this by assembling with --update=super-minor.
e.g.

  mdadm -S /dev/md125
  mdadm -A /dev/md1 --update=super-minor

it should get details of which devices to included from /etc/mdadm.conf.

However it is possible that mdadm.conf in your initrd also the name
as /dev/md125.
So once you have performed the above, run mkinitrd again, reboot, and report
what happens.


--

Justin.


