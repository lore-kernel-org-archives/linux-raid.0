From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1: module or compiled in?
Date: Wed, 07 May 2003 12:53:04 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB939F0.9BB1BF0B@SteelEye.com>
References: <20030507160730.D592A3B84A@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Derek Vadala wrote:

> It depends when you start the arrays. If you are booting from SW RAID or
> autostarting, [...] you
> need to use an initial RAM disk that preloads the md driver and necessary
> RAID level modules.

You would think that would work, but it doesn't, unfortunately... :/

md has to be compiled in if you want to use autostart. I suppose you
could put a raidtab file and raidtools (or maybe mdadm would be easier?)
on your initrd, and get the thing to boot, but that's rather
complex...and most distros don't have the setup to make an initrd like
that...(they just compile md in and call the autorun ioctl from the
initrd after loading your storage and raid modules)

I've got a patch for md (2.4 and 2.5), so you can do autostart with md
compiled as a module...

I just posted a message about it...

--
Paul
