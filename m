From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: Slackware and RAID
Date: Sat, 16 Sep 2006 20:32:07 +0200
Message-ID: <200609162032.07509.Dexter.Filmore@gmx.de>
References: <200609161230.22530.Dexter.Filmore@gmx.de> <450C33BA.2000208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <450C33BA.2000208@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Samstag, 16. September 2006 19:26 schrieb Bill Davidsen:
> Dexter Filmore wrote:
> >Is anyone here who runs a soft raid on Slackware?
> >Out of the box there are no raid scripts, the ones I made myself seem a
> > little rawish, barely more than mdadm --assemble/--stop.
>
> I'm pretty much off Slack now, but I have run, the scripts you describe
> are about 2/3 of what you need, see the thread(s) here about monitoring.
> mdadm doesn't need a lot of direction...

What's the remaining third?
I fumbled it into rc.S and rc.6, reason why I ask is that array degraded about 
6 times in the few months I run it and I can't figure why. Only thing I know 
is that it degrades somewhere in the reboot process, so I suspect it might 
not properly shutdown.

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
