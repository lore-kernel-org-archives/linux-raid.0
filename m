From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: access *existing* array from knoppix
Date: Tue, 12 Sep 2006 11:47:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0609121147370.19418@p34.internal.lan>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
 <200609121607.22031.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609121008050.19418@p34.internal.lan>
 <200609121637.53998.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121637.53998.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Strange, what knoppix are you using? I recall doing it to fix an XFS bug 
with 4.x and 5.x.

On Tue, 12 Sep 2006, Dexter Filmore wrote:

> Am Dienstag, 12. September 2006 16:08 schrieb Justin Piszcz:
>> /dev/MAKEDEV /dev/md0
>>
>> also make sure the SW raid modules etc are loaded if necessary.
>
> Won't work, MAKEDEV doesn't know how to create [/dev/]md0.
>
>
> -- 
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.12
> GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
> w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@
> b++(+++) DI+++ D- G++ e* h>++ r* y?
> ------END GEEK CODE BLOCK------
>
> http://www.stop1984.com
> http://www.againsttcpa.com
>
