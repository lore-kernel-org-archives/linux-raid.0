From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 19:35:18 -0700
Message-ID: <20050911023518.GD10501@sam.triumf.ca>
References: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca> <4323911D.8010307@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4323911D.8010307@emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 10, 2005 at 10:06:21PM -0400, Ric Wheeler wrote:
> If you look at public numbers for power for modern Intel architecture 
> CPU's, say Tom's hardware at: ...
> you will see that the 20W budget you allocate...

I am now confused. Is somebody trying to save power by adding an i/o
coprocessor? (with it's own power overhead for memory, i/o, etc)

To me it is simple:

1) If you have an infinite power budget (big box), you might as well
   let the main cpus do the raid stuff. If you are short on power (embedded),
   you cannot afford to power an extra processor (+memory and stuff).

2) If you have rich customers (big box), let them pay for a bigger
   main cpu to do the raid, if you want to be cheap (embedded, appliance),
   you cannot afford to plop an extra cpu (+support chips) on your custom pcb.

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
