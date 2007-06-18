From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: resync to last 27h - usually 3. what's this?
Date: Mon, 18 Jun 2007 18:26:51 +0200
Message-ID: <200706181826.51387.Dexter.Filmore@gmx.de>
References: <200706181659.32119.Dexter.Filmore@gmx.de> <4676A31E.8090902@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4676A31E.8090902@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 18 June 2007 17:22:06 David Greaves wrote:
> Dexter Filmore wrote:
> > 1661 minutes is *way* too long. it's a 4x250GiB sATA array and usually
> > takes 3 hours to resync or check, for that matter.
> >
> > So, what's this?
>
> kernel, mdadm verisons?
>
> I seem to recall a long fixed ETA calculation bug some time back...
>

2.6.21.1, mdadm 2.5.3.
First time I sync since upgrade from 2.6.17.

Definetly no calc bug, only 4% progress in one hour.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
