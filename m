From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: External bitmap disappears
Date: Fri, 20 Jun 2008 08:17:09 -0500
Message-ID: <cccedfc60806200617k37498d4y1f01072145271d00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've configured a raid10,f2 with an external bitmap:

mdadm --grow --bitmap=/md0.bitmap /dev/md0

The root ('/') filesystem is NOT on the raid. It's a normal partition
(/dev/sdb1, the boot device actually).
After reboot, cat /proc/mdstat does not show a bitmap. What's up with
that? That sure doesn't seem right.

-- 
Jon
