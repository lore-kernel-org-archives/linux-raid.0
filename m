From: Adam Nevins <univac@comcast.net>
Subject: is it possible to change the UUID of an array?
Date: Fri, 02 Dec 2005 14:41:28 -0500
Message-ID: <1133552488.24610.18.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a RAID-1 with two mirrors as my root partition.  I decided to
fail/remove one of the mirrors prior to upgrading parts of the OS so
that I'd have a backup just in case things went horribly wrong.  After
doing the upgrade, I wanted to compare the two mirrors, so I assembled a
new md with the failed mirror.  So far, so good.

The problem is that I now have two arrays with the same UUID.  I'm
assuming that automatic assembly is now broken.  For now, I've changed
mdadm.conf to specify the physical devices, but what I'd like to do is
generate a new UUID for one of the mirrors.  I haven't found a way to do
this without recreating the array.

kernel version: 2.6.11
mdadm version:  1.12.0

Thanks in advance,

Adam
-- 
Adam Nevins <univac@comcast.net>

