From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: endianness of Linux kernel RAID
Date: Wed, 3 Aug 2005 08:07:04 -0400
Message-ID: <20050803120656.GA16696@anthropohedron.net>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It turns out that if one uses the kernel (2.4.x-2.6.x) RAID support (RAID5,
anyway, since that's all I've tested), the RAID'd disks cannot be moved to
another system with a different endianness. I don't know how hard that
would be to fix, but it did mean that when my ancient Mac clone I was using
as a server died I couldn't bring the RAID over to my spare x86 Linux box;
I had to dedicate other hardware (my dual G4 that I had been happily using
with OS X) to the task instead.

Unfortunately, I haven't gotten into kernel development and, therefore, do
not have the necessary expertise to fix it. Is anyone here interested in
this issue?

--Greg

