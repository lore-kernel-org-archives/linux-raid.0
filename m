From: "NeilBrown" <neilb@suse.de>
Subject: Re: Write intent bitmaps
Date: Sat, 20 Jun 2009 18:14:21 +1000 (EST)
Message-ID: <8980e5d278405d56e8d5c128d17fe0cf.squirrel@neil.brown.name>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
    <18989.6010.582386.812296@fisica.ufpr.br>
    <19002.62697.475588.28776@notabene.brown>
    <87ab44mfn8.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ab44mfn8.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, June 20, 2009 1:01 am, Goswin von Brederlow wrote:
> Neil Brown <neilb@suse.de> writes:
>
>> On Monday June 8, carlos@fisica.ufpr.br wrote:
>>>  >If so, would ext2 probably be the best choice?
>>>
>>> That's what the man page says. I find it strange since if it's a file
>>> the filesystem shouldn't matter. Neil?
>>
>> The way that md writes to the bitmap file is not entirely portable
>> across different filesystems.  As the man page say,  it is known to
>> work for ext2 and ext3.  Either is a fine choice.
>> A new filesystem interface is being introduced in 2.6.31 as part of
>> the swap-over-NFS work.  I might end up using that to write to bitmap
>> files, as it has the right characteristics.  But that is very much in
>> the future.
>>
>> NeilBrown
>
> How about support to write to a device instead of a file?

One of my next little projects is to rationalise the bitmap support
and make it more generic - currently you cannot use bitmaps with
externally managed metadata because there is no way to say where
it should go.
I don't know yet how that will end up working, but it is entirely possible
that it will generalise to allows the bitmap to be written to an
arbitrary device.

However, as bitmaps are typically quite small (a few megabytes at
most, typically tens of kilobytes) it seems clumsy to create a
partition just for a bitmap..

NeilBrown

