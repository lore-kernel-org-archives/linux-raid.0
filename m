From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: RE: Checkarray doesn't seem to do anything
Date: Mon, 5 Sep 2016 10:15:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1609051010420.1477@uplift.swm.pp.se>
References: <20160302125329.0a91db92e0d9ae1e5e3fde0508678719.6af0e5bebc.wbe@email03.secureserver.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160302125329.0a91db92e0d9ae1e5e3fde0508678719.6af0e5bebc.wbe@email03.secureserver.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I just wanted to say I ran into this on Ubuntu 16.04 just now, and it's 
still not fixed.

Seems there are multiple bug id:s

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=787950#10
https://bugs.launchpad.net/debian/+source/mdadm/+bug/1550823

But this is still not fixed in Ubuntu 16.04, potentially in Debian as 
well.

So it might be good for everybody to know that their arrays most likely 
aren't being periodically checked if you upgrade to Ubuntu 16.04 
currently.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
