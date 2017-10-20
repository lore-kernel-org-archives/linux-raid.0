From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6: Reducing to Grow
Date: Fri, 20 Oct 2017 19:26:37 -0400
Message-ID: <d265ad74-34f1-1392-8ba6-2729b5bfbd36@turmel.org>
References: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
 <ba94e811-1ae4-a8a3-5907-bde289b44754@turmel.org>
 <9ef8359d-7da9-de5a-d939-46a3c51cc68d@gmail.com>
 <0f2b759f-3f4d-127a-242a-74c3f8abdea4@turmel.org>
 <CAPE0SYxOnzhEwaxBipUsMVrgtfNPyFRRMOa-Zg4fA+O0Zmk=CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYxOnzhEwaxBipUsMVrgtfNPyFRRMOa-Zg4fA+O0Zmk=CQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/20/2017 01:04 AM, Liwei wrote:

>> Note that all of the above can be executed while using your mounted
>> LV.
>> 
>> Phil
> 
> Great! I'm done with the scrub, now waiting for the new drives to
> arrive.
> 
> I anticipate there'll be quite a bit of downtime involved though.
> Our chassis only has 16 cages, so we probably have to temporarily
> move one or two of the 2TB drives onto the internal SATA connectors
> and hang them around. Power might be an issue too, but we'll figure
> it out, hopefully without frying any drives. ;)
> 
> My guess is I should probably scrub again after relocating the
> drives, just to be sure they work under load.

Good insurance, yes.

> Regarding the chunk size, my predecessor initially chose 512k based
> on some reading about performance boost with raw video files and
> 4k/AF drives, not sure whether it holds water. Something along the
> lines of: we're dealing with multi gigabyte files anyway, what's
> wastage of half a meg here and there? Supposedly RW performance
> increases with chunk size - provided they're properly aligned, but it
> is a diminishing return.
> 
> We're using this NAS to ingest the raw video files from our HD and
> 4K cameras so they can be accessed remotely for editing, does 512k
> chunk size make sense or should I go down to 16/32k?

No, your use calls for the large chunk.  That large chunk could hurt
more random tasks that involve files that aren't much larger than a
stripe.  Your stripes will be 2MB to start, then a bit bigger as you
grow the space.  Gig+ files are much bigger, so no worries.  If your
application was mostly ~10MB files or smaller, or had random access
patterns within the files, I'd reconsider.

> Thank you for the assistance so far!

No problem.  I like the easy ones... (-:

Phil
