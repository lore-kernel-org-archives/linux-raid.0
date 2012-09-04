From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Safe disk replace
Date: Tue, 4 Sep 2012 14:26:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
References: <20120904041447.GB14445@onthe.net.au> <5045D7D9.9000108@hesbynett.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5045D7D9.9000108@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Chris Dunlop <chris@onthe.net.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 4 Sep 2012, David Brown wrote:

> The "raid1" copy you mention will one day be possible with "hot replace"
> <http://neil.brown.name/blog/20110216044002#2>
>
> I don't know how far along this idea is at the moment.

https://lwn.net/Articles/465048/

"hot-replace support for RAID4/5/6:

In order to activate hot-replace you need to mark the device as 
'replaceable'. This happens automatically when a write error is recorded 
in a bad-block log (if you happen to have one).

It can be achieved manually by
    echo replaceable > /sys/block/mdXX/md/dev-YYY/state

This makes YYY, in XX, replaceable."

I don't know if it actually made it into 3.2, I believe I saw somewhere 
that it was available for 3.3, but Neil Brown should know more.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
