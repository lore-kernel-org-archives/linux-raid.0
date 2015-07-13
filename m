From: Jared Mauch <jared@puck.Nether.net>
Subject: Re: CPU requirements......
Date: Mon, 13 Jul 2015 12:26:01 -0400
Message-ID: <20150713162600.GA16878@puck.nether.net>
References: <CAOS+5GGAL-8R7ZNd563Z-5oXbRw1QAswOKv7DstT5cLFdyR+Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOS+5GGAL-8R7ZNd563Z-5oXbRw1QAswOKv7DstT5cLFdyR+Sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 13, 2015 at 05:14:51PM +0100, Another Sillyname wrote:
> I've been testing a test RAID6 setup with a 5970 CPU that has worked fine.
> 
> As this box is almost exclusively going to be a file server I'm
> thinking of swapping to a G3258 processor, dual core, not overclocked
> and no hyperthreading or turbo features.
> 
> The box may also be used to do transcodes of media files from HD mpeg
> to x264 which is pretty CPU intensive......
> 
> Are there any likely issues with the RAID running on a substantially
> slower CPU?   I can't seem to find an recent/decent docs suggesting
> minimum CPU requirements for MDADM raid configs.

	you are likely to be I/O bound either on the drives
or on the controller card to the bus/cpu.

	While imperfect, take a look at doing
hdparm -t -T /dev/device-name

	This will give you an idea of what a userland process
will see as the performance for cached and non-cached reads.

	simply: the more you can keep in memory or on fast media
the better off you are.

	- Jared
-- 
Jared Mauch  | pgp key available via finger from jared@puck.nether.net
clue++;      | http://puck.nether.net/~jared/  My statements are only mine.
