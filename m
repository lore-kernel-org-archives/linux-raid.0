From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: mapping ataXX.YY to a /dev/sdX
Date: Wed, 7 Jul 2010 08:14:56 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.

I have some spurious timeouts (but without md kicking the drive) on an 
WD20EADS. I believe this drive is actually defective and would like to 
swap it.

Looking at dmesg etc, I don't see an exact mapping between /dev/sdX and 
the ataXX.YY semantics. I can guess with high probability which drive this 
is, but I don't know for sure and I don't want to fail the wrong drive.

Anybody know a sure way to find this mapping out? Been looking in /sys 
etc, but no go so far...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
