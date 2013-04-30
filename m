From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 16:40:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304301639200.2118@uplift.swm.pp.se>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch> <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se> <517FD12B.20608@supsi.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517FD12B.20608@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 30 Apr 2013, Roberto Nunnari wrote:

> You believe that this is not enough? What's the unit? milliseconds?
> # for x in /sys/block/sd[a-z] ; do cat $x/device/timeout ; done
> 30
> 30
> 30
> 30

The unit is in seconds, and yes, you want the drive to report an error 
before the kernel drops it, so 180 seconds is sufficient for most drives 
to give up and return a read error.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
