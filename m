From: Martin Cracauer <cracauer@cons.org>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Sun, 23 Apr 2006 12:43:50 -0400
Message-ID: <20060423124350.B38675@cons.org>
References: <200604191631.04305.Dexter.Filmore@gmx.de> <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com> <200604212023.30855.Dexter.Filmore@gmx.de> <17481.23502.962814.840550@fisica.ufpr.br> <20060422110816.A22573@cons.org> <17482.27751.358345.185741@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17482.27751.358345.185741@fisica.ufpr.br>; from carlos@fisica.ufpr.br on Sat, Apr 22, 2006 at 02:48:23PM -0300
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote on Sat, Apr 22, 2006 at 02:48:23PM -0300: 
> Martin Cracauer (cracauer@cons.org) wrote on 22 April 2006 11:08:
>  >> stop the array
>  >> dd warning disk => new one
>  >> remove warning disk
>  >> assemble the array again with the new disk
>  >> 
>  >> The inconvenience is that you don't have the array during the copy.
>  >
>  >Stopping the array and restarting it as readonly will give you access
>  >to the data while that copy is in progress.
> 
> Yes but then you could just switch it to read-only without stopping.

I believe that would be fine to do the whole operation.  Filesystem
read-only, then md read-only, copy disk, then you need to unmount and
stop the md to restart it with the new disk.

If the final disk change involves a powerdown and putting the new disk
on the physical interface that the old one was on it should be
transparent.

%%

BTW, last time I tested a Linux software RAID-5 by ripping out an
active disk I noticed that while the filesystem stayed up and usable,
a currently ongoing system call would not return and block forever.

Is that a know behaviour?

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
FreeBSD - where you want to go, today.      http://www.freebsd.org/
