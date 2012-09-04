From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Safe disk replace
Date: Tue, 4 Sep 2012 18:34:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209041834220.13902@uplift.swm.pp.se>
References: <20120904041447.GB14445@onthe.net.au> <5045D7D9.9000108@hesbynett.no> <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se> <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 4 Sep 2012, Robin Hill wrote:

> I'm currently upgrading my RAID-6 arrays via hot-replacement. The
> process I followed (to replace device YYY in array mdXX) is:
>    - add the new disk to the array as a spare
>    - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state

What kernel version are you using?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
