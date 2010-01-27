From: Thomas Backlund <tmb@mandriva.org>
Subject: kernel BUG at fs/scache.c:670
Date: Thu, 28 Jan 2010 01:01:25 +0200
Message-ID: <4B60C5C5.3040604@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753543Ab0A0XBa@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ataraid-list@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, (please cc me on response)


I'm hitting a kernel BUG at fs/scache.c:670 bug using dmraid on 2.6.32 
and 2.6.33-rc5-git2 kernels:

Distro: Mandriva Linux Cooker
Arch: x86_64

Hardware: Intel ICH10R with 4 x 500GB disks in biosraid10,
System has 8GB ram

OOPS: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/dsc00918.jpg
config: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/x86_64.config

This happends on 2.6.33-rc5-git2, 2.6.32, and seems to be as old as 
2.6.32-rc1.

2.6.31 is the latest kernel that actually boots on this system.

I tried to bisect between 2.6.31 and 2.6.32-rc1, but it failed...

Now before I start a second bisect, I decided to post here in case some 
one has some suggestions / pointers...

--
Thomas
