From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 11:28:00 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0603311122330.2115@montezuma.acc.umu.se>
References: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Mar 2006, Mark Hahn wrote:

>> 3ware.  Period.  If you're going to use md, get the 8506-4 series rather
>> than either of the 9xxx series cards.
>
> before the 9550, I never found attractive in price/performance:
> expensive as hell and a lot slower than MD.  but the 9550 is really
> quite impressive...

I'd still recommend 3ware for the md case, because of reliability. For my 
6-disk raid a 8506-4 was actually slightly faster than two sil3114s 
running md raid5. The 3ware card has the additional advantage of not 
pushing the machine into a hard hang once per day or so when doing io over 
the raid layer.

You're right though in that the hw raid performance was rather bad until 
the 9550.

/Mattias Wadenstein
