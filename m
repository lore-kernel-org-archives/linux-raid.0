From: Rick Bragg <lists@gmnet.net>
Subject: Tools for Hardware Raid?
Date: Mon, 28 Dec 2009 10:33:53 -0500
Message-ID: <1262014433.25079.212.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Since my latest disaster was caused be me not monitoring raid disks, I
was wondering about tools for monitoring hardware based raid systems?

I have a Dell 1900 with a perc5 raid controller

# lspci
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5

It is set up as RAID 10

I tried running smartctl on it, but that does not even work because the
system sees the array as just one disk.

I'm wondering how I can monitor the disks, etc...

Any advice?

Thanks
Rick






