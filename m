From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Mirroring swap
Date: Fri, 27 Jun 2003 12:17:39 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0306271209220.7750-100000@sweetums.bluetronic.net>
References: <200306262022190167.0592257E@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306262022190167.0592257E@ilneval.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 Jun 2003, Corey McGuire wrote:
>And its not like gobs of free RAM is useless in the Linux world.  Unlike
>windows, Linux keeps it RAM filled with cache until free RAM is needed (I
>have disk intensive windows apps that run far faster under WINE than
>Windows.  I love bragging about them ;-)

"Unlike windows"?  Do you even *use* windows?  Windows has had the same
filesystem caching capability as linux for many years now.  Linux is a lot
more lax about what it'll keep in memory -- basically, cache pages will
not be pushed out until something needs the memory (application or another
cache page.)  Windows limits the ammount of cached space and tends to dump
things a great deal faster...

Everyone loves to poopoo on windows without even looking.  Both do caching.
Linux tends to do it much better -- esp. under load; copy a file 2x the
size of RAM on both and you'll see what I mean.

--Ricky


