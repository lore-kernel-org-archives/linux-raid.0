From: Neil Brown <neilb@suse.de>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 16:11:07 +1100
Message-ID: <19196.60011.858158.550391@notabene.brown>
References: <200911122253.01626.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from lrhorer@satx.rr.com on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 12, lrhorer@satx.rr.com wrote:
> Damn!!!
> 
>         I was doing some testing at the behest of Doug, when I made a
> critical error which locked up the system and now the main array won't
> assemble, at all.  I issued the command
> 
> `mdadm -G /dev/md0 -b internal --bitmap-chunk=65535`
> 
>         And the system complained it was an invalid chunk-size, so I
> tried:
> 
> `mdadm -G /dev/md0 -b internal --bitmap-chunk=65536`
> 
>         This time there was no error, but the command line just hung
> solid.  I tired everything I could to recover, but the system just went
> downhill more and more.  Finally I tried a shutdown, but even that would
> not work.  I had to hit the big red switch, and now when I rebooted the
> system, mdadm will not assemble the array no matter what I try.  I tried
> 
> 
> `mdadm --assemble /dev/md0 -f`
> 
> `mdadm --assemble /dev/md0 -u xxxxxxxx:xxxxxxxxx:xxxxxx:xxxxxx`
> 
>         etc.  It just keeps saying, "No devices found for md0".  When I
> issue the --examine switch, the information all looks good for all the
> drives, just no RAID.  What do I do, now?


1/ show us what the result of --examine was.
2/ add -vvv to the --assemble and report the result of that.

NeilBrown
