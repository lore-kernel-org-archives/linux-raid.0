From: Anthony Youngman <antlists@youngman.org.uk>
Subject: xosview
Date: Fri, 29 Jul 2016 17:52:14 +0100
Message-ID: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
Cc: mike.romberg@comcast.net
List-Id: linux-raid.ids

I don't know how many of you use this ancient nifty utility, but I've 
been using it for as long as I can remember. Unfortunately, the raid 
monitor code no longer works ... :-(

I emailed the maintainer privately and he was pleased that I'd got in 
touch even though it was with the bad news, and he'd like to fix it, but 
he has no system with raid to test it on.

It works by parsing /proc/mdstat. From what I can see of the code, it 
would be very easy to test it by pointing it at a fake mdstat. I've got 
three arrays on a two disk mirror, so that's easy for me to test, but 
I'd like to test it on other setups.

So if people wouldn't mind, could you email your mdstat files? 
Preferably on the list so people can see what has and has not been sent 
- obviously I'd like standard setups like raid10, raid5, raid6, both 
named and numbered. And if people have them, mdstats showing broken 
arrays, rebuilds, complicated setups with lvm, etc.

Dunno about other people, but I have xosview running on my desktop all 
the time (I feel naked without it :-) so if that can give me a 
continuous monitor of my raid state that's great. And hopefully, if 
other people use it, we might reduce the number of "I didn't realise my 
raid was degraded, and then it suffered another failure" type emails.

Cheers,
Wol
