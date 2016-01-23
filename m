From: Phil Turmel <philip@turmel.org>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 19:34:27 -0500
Message-ID: <56A2CA93.8020806@turmel.org>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org>
 <56A2A2C3.9000801@yandex.ru>
 <CACsGCyTUBRrQgt0GiVp1R6pv-4gO44Ro7pgm4iCq+1KwWDoPsg@mail.gmail.com>
 <56A2B639.7000902@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2B639.7000902@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, Edward Kuns <eddie.kuns@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/22/2016 06:07 PM, Dark Penguin wrote:
>> Depending on your distribution, you may have been scrubbing all along.
> 
>> Notice that if you have problems with timeouts, then this scrubbing
>> can break your array by causing you to hit a bad sector and fail as
>> Phil and others have described in several of his referenced EMails.
> 
> I remember disabling scrubbing myself. My reasons were not very...
> bright, but now it turned out to be a it's a good thing, because with
> TL;DR disabled by default, it could lead to that kind of bad things
> happening, yes. 

Nooooo!

Disabling scrubbing with "dodgy" drives turns an annoyance (drives
kicked out by scrubs) into a catastrophe later (unrecoverable array).
The archives of this list are full of such incidents.

The only people who should disable scrubbing are enterprise data centers
where the disks are so busy they hit every sector every so often anyways.

> I remember having one drive kicked out of an array in my
> home storage, and since then, I've learned to use write-intent bitmaps
> to re-add them more easily. But I'm a BAARF person, so I only have
> mirrors; I wonder what happens if the only drive in a degraded mirror
> fails?..

Or any drive in a raid5 hits an error while replacing a failed disk.

BOOM.

Phil
