From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: md failing mechanism
Date: Sat, 23 Jan 2016 02:07:37 +0300
Message-ID: <56A2B639.7000902@yandex.ru>
References: <56A26E11.2090703@yandex.ru>	<56A28309.9080806@turmel.org>	<56A2A2C3.9000801@yandex.ru> <CACsGCyTUBRrQgt0GiVp1R6pv-4gO44Ro7pgm4iCq+1KwWDoPsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyTUBRrQgt0GiVp1R6pv-4gO44Ro7pgm4iCq+1KwWDoPsg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Depending on your distribution, you may have been scrubbing all along.

 > Notice that if you have problems with timeouts, then this scrubbing
 > can break your array by causing you to hit a bad sector and fail as
 > Phil and others have described in several of his referenced EMails.

I remember disabling scrubbing myself. My reasons were not very... 
bright, but now it turned out to be a it's a good thing, because with 
TL;DR disabled by default, it could lead to that kind of bad things 
happening, yes. I remember having one drive kicked out of an array in my 
home storage, and since then, I've learned to use write-intent bitmaps 
to re-add them more easily. But I'm a BAARF person, so I only have 
mirrors; I wonder what happens if the only drive in a degraded mirror 
fails?..


> I took the script from this Email:
>
> https://www.marc.info/?l=linux-raid&m=144661276420400&w=2
>
> and dropped that code in my /etc/rc.d/rc.local after verifying that my
> Linux distribution still ran that script on every startup.  YMMV.
> That solved my problem.  Good luck.

I was afraid to learn that my latest pack of drives are modern enough to 
be castrated already, but it turned out they are not. :) My anime is 
safe with the last 5900RPM Hitachi drives available, and they do support 
TL;DR. I wish Hitachi made more 5900RPM drives for such purposes...


-- 
darkpenguin
