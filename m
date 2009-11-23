From: Joshua Hattersley <joshhattersley@gmail.com>
Subject: RAID-5 to RAID-6 Reshape Process
Date: Sun, 22 Nov 2009 16:54:00 -0800
Message-ID: <E0A5D033-60CF-4CC6-A124-37C597C6235B@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a home server running Ubuntu 9.04 Server (kernel 2.6.28-16-server), which has three drives in RAID-5 using mdadm (version 2.6.7.1 according to mdadm --version).  I would like to reshape this array into a RAID-6 using one additional drive, thereby turning it into a four disk RAID-6 array (with the intention to grow the usable size of the array later on).  I've been scouring the relevant info I can find on the web and haven't come across a well-outlined process by which to accomplish this.

So, basically, I'm wondering if I can accomplish this reshape with my current software, or if I'll need to use mdadm 3.1.1 and/or a LiveCD with a newer kernel?

It's my understanding that, given a capable setup, adding the new drive as a spare and then growing the array using a command like "mdadm --grow /dev/md0 --level=6 --raid-disk=4" should work, but I want to make sure I've got the tools necessary before attempting it.  Thanks in advance for any help!