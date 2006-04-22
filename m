From: Martin Cracauer <cracauer@cons.org>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Sat, 22 Apr 2006 11:08:16 -0400
Message-ID: <20060422110816.A22573@cons.org>
References: <200604191631.04305.Dexter.Filmore@gmx.de> <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com> <200604212023.30855.Dexter.Filmore@gmx.de> <17481.23502.962814.840550@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17481.23502.962814.840550@fisica.ufpr.br>; from carlos@fisica.ufpr.br on Fri, Apr 21, 2006 at 07:25:18PM -0300
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> stop the array
> dd warning disk => new one
> remove warning disk
> assemble the array again with the new disk
> 
> The inconvenience is that you don't have the array during the copy.

Stopping the array and restarting it as readonly will give you access
to the data while that copy is in progress.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
FreeBSD - where you want to go, today.      http://www.freebsd.org/
