From: Nathan Eisenberg <nathan@atlasnetworks.us>
Subject: Questions about MD 2-drive RAID-10
Date: Thu, 12 Jan 2012 23:27:06 +0000
Message-ID: <8C26A4FDAE599041A13EB499117D3C286B66DA76@ex-mb-1.corp.atlasnetworks.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi there,

It's my first post here!  For some background, I'm a sysadmin at a datacenter provider.  I have a large number of MD devices under my control, and a fair amount of experience using MD and the majority of its RAID drivers.  Just so I've said it, I did quite a lot of searching before deciding to post, in the hopes that I could find my answer documented somewhere.  If I've missed a good article where my question was clearly answered, then I do apologize (and feel free to mock me for it)!

Until a few hours ago, I was under the impression that a RAID-10 required at least four disks, in pairs that form the underpinning mirrors for the stripe.  A few days ago, a customer of mine requested a two drive RAID-10, and was surprised by my insistence that it was impossible.  Imagine my shock when I stumbled across http://neil.brown.name/blog/20040827225440.

http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
This article talks about MD's RAID-10 driver's support for a 2-disk RAID-10, in both 'near' and 'far' modes.  It also mentions the potential performance advantages (over a RAID-1) of using the RAID10 driver in the 'far' configuration on a 2-disk array, but it doesn't say much about the 'near' mode.

My question is this: what differences, if any, are there between building a RAID-1 with two disks, and building a RAID-10 with two disks in the 'near' configuration?  Does this result in the OS 'striping' its reads across the mirrored disks, improving read (but presumably not write) access?  Do I correctly interpret the article's suggestion that the 'far' configuration will result in increased performance for both reads and writes (again, over a RAID-1), or am I crazy?

Thank you for your time!

Nathan
