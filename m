From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: access *existing* array from knoppix
Date: Tue, 12 Sep 2006 16:37:53 +0200
Message-ID: <200609121637.53998.Dexter.Filmore@gmx.de>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <200609121607.22031.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609121008050.19418@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609121008050.19418@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 12. September 2006 16:08 schrieb Justin Piszcz:
> /dev/MAKEDEV /dev/md0
>
> also make sure the SW raid modules etc are loaded if necessary.

Won't work, MAKEDEV doesn't know how to create [/dev/]md0.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
