From: Dave Cundiff <syshackmin@gmail.com>
Subject: Backporting Linux 3.7 RAID TRIM Patches to CentOS 6.3
Date: Wed, 12 Dec 2012 23:44:17 -0500
Message-ID: <CAKHEz2atAeCP7UHiDvjk8itSazmdnqwLUH20e0ATARJe_cBthw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been WAITING for TRIM to be added to the MD driver. Now that its
in 3.7 I just can't wait for it filter down to the distros.

The patches submitted to 3.7 mostly apply to the RHEL/CentOS 6.3
kernel source. Because RHEL pulls in random stuff from newer kernels
its hard to tell what other patching is needed. Before I go digging
attempting to finish applying and working out issues I was wondering
if anyone more familiar would know if there were other kernel patches
that the TRIM patches depend upon.

Thanks!

--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
