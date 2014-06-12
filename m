From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 09:26:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1406120925450.20220@hirohito.acc.umu.se>
References: <5397FBCE.3060009@bartk.us> <CAH3kUhH06kpJNqb-zdcv5nu2e1FeZuotcW0SjBbWDOCcasm9OA@mail.gmail.com> <53983099.8030801@bartk.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53983099.8030801@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: Roberto Spadim <roberto@spadim.com.br>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 11 Jun 2014, Bart Kus wrote:

> Doing the periodic check does not prevent corruption of read() data though 
> (RAID6 case).  Copied files may be corrupted, even though the RAID would 
> eventually fix itself after a repair is done.
>
> Yes, there is a performance penalty, but data integrity is also improved. 
> Paranoid mode should probably not be the default, but I would like the choice 
> to improve data integrity at the expense of some small speed penalty.  ZFS 
> implements this anti-corruption checking by using checksums on their data. 
> We don't have a simple checksumming mechanism in md-raid, but we do have the 
> full stripe data available ready for verification.
>
> BTW, the idea of a daily repair operation doesn't work when it takes 14 hours 
> to repair a large RAID.  That would only leave 10 hours of each day for 
> normal speed access.  I schedule repairs weekly, though.

Since bytes read and written is the dominating factor behind disk failures 
these days, I certainly wouldn't want to do repairs daily. Weekly might 
even be pushing it.

/Mattias Wadenstein
