From: Bill Davidsen <davidsen@tmr.com>
Subject: Disk characteristics for virtual machines
Date: Fri, 13 Mar 2009 12:51:58 -0400
Message-ID: <49BA8F2E.9030704@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin (jpiszcz@lucidpixels.com) was discussing the ioscheduler for SSD, 
and I was thinking about that in terms of virtual machines, since I run 
a lot of small servers using KVM. So I added a short script to my 
rc.local, to use the "noop" scheduler for any drive with model QEMU* so 
that the underlying host scheduling can work without anything competing.

I was wondering if that should also apply to the "rotational" feature 
added in 2.6.29, since these "devices" are backed by files.

Ref:

<alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


