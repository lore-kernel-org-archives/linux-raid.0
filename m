From: Justin Maggard <jmaggard10@gmail.com>
Subject: Component size difference with mdadm
Date: Tue, 20 Apr 2010 14:06:08 -0700
Message-ID: <g2w150c16851004201406ie5b4b84dpbdd820142fcc4be8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was working on recovering a damaged array today, and I used mdadm
3.1.2 with --assume-clean to get it up and running.  I was surprised
when I wasn't able to mount the filesystem on the array after starting
it, so I did a closer comparison of a dump of the original array
configuration vs. the new one.  I found that the main difference was
that the component size was 1KB smaller now than it used to be.  The
array was originally created with mdadm 2.6.8.  So I compiled the old
2.6.8 version of mdadm and used the same mdadm --assume-clean command,
and bingo, the component size matched the original array config and it
mounted just fine.

So, I suspect there is some new code in mdadm 3.1 that wasn't in 2.6.x
to try to make I/O 4KB-aligned on non-aligned partitions.  Is that
accurate?  If so, is there a way to tell mdadm to behave like older
mdadm versions in these cases?

-Justin
