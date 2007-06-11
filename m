From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 10:07:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706111007010.31708@p34.internal.lan>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
 <200706111528.11828.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
 <200706111606.11006.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706111606.11006.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 11 Jun 2007, Dexter Filmore wrote:

>> 10gb read test:
>>
>> dd if=/dev/md0 bs=1M count=10240 of=/dev/null
>>
>> What is the result?
>
> 71,7MB/s - but that's reading to null. *writing* real data however looks quite
> different.
>
>>
>> I've read that LVM can incur a 30-50% slowdown.
>>
> Even then the 8-10MB/s I get would be a little low.
>
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

Would it be possible to trash the LVM and write directly to the MD device? 
I'd be really curious to see what it gets with XFS ontop of MD.

Justin.
