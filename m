From: "bo" <bo@sosnetwork.net>
Subject: RE:What are those changes  for fixing the RAID0 performance?
Date: Mon, 19 Aug 2002 08:01:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <010401c24791$5aeb3830$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil And RAIDers,

I have been looking for "what changes are made to fix/improve the parallel
access(?) to disks simultanously?".
I noticed as follow;

Up to Linux2.4.9  it got the same performance for RAID0(2-way stripe) and a
single disk(JBOD),
about 15 MB/sec with DMA on(hdparm -tT /dev/mdx).

On Linux 2.4.10 it improves to about 25 MB/sec for RAID0, 15 MB/sec for
single disk.
On Linux 2.4.18 it got the right performance; about 31 MB/sec for RAID0.

I tried to port the difference on /driver/ide and /drivers/md, but it did
not help.
I think there were changes on other functions to fix the parallel access(?)
to disks simultanously OR
to improve the RAID0 performance .

Why am I doing this kind of homework?

I can not migrate our linux to 2.4.18 so I want to port ONLY the fixes for
this performance
issue. I use Linux2.4.5.

Please help me if you know how I can work around.

Thanks in advance,

Bo


