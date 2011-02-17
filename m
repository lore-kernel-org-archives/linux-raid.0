From: Phil Turmel <philip@turmel.org>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 19:11:14 -0500
Message-ID: <4D5C67A2.5090306@turmel.org>
References: <20110216212751.51a294aa@notabene.brown>	<4D5C2776.2080609@turmel.org> <20110217084403.46b4d8ee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217084403.46b4d8ee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 04:44 PM, NeilBrown wrote:
[trim /]
> On Wed, 16 Feb 2011 14:37:26 -0500 Phil Turmel <philip@turmel.org> wrote:
>> It occurred to me that if you go to the trouble (and space and performance)
>> to create and maintain metadata for lists of bad blocks, and separate
>> metadata for sync status aka "trim", or hot-replace status, or reshape-status,
>> or whatever features are dreamt up later, why not create an infrastructure to
>> carry all of it efficiently?
>>
>> David Brown suggested a multi-level metadata structure.  I concur, but somewhat
>> more generic:
>> 	Level 1:  Coarse bitmap, set bit indicates 'look at level 2'
>> 	Level 2:  Fine bitmap, set bit indicates 'look at level 3'
>> 	Level 3:  Extent list, with starting block, length, and feature payload
>>
>> The bitmap levels are purely for hot-path performance.
>>
>> As an option, it should be possible to spread the detailed metadata through the
>> data area, possibly in chunk-sized areas spread out at some user-defined
>> interval.  "meta-span", perhaps.  Then resizing partitions that compose an
>> array would be less likely to bump up against metadata size limits.  The coarse
>> bitmap should stay near the superblock, of course.
> 
> This is starting to sound a lot more like a filesystem than a RAID system.

Heh.  But if you are going to start adding block and/or block-extent metadata for
a variety of features, common code and storage for it should be an all-around win.

> I really don't want there to be so much metadata that I am tempted to spread
> it out among the data.  I think that implies too much complexity.

It would be complex, yes.  Same math as computing block locations within raid 5
stripes, though.

> Maybe that is a good place to draw the line:  If some metadata doesn't fit
> easily at the start of end of the devices, it has no place in RAID - you
> should add it to a filesystem instead.

I think that's arbitrary, but its moot until someone tries to implement it.

>> Personally, I'd like to see the bad-block feature actually perform block
>> remapping, much like hard drives themselves do, but with the option to unmap the
>> block if a later write succeeds.  Using one retry per array restart as you
>> described makes a lot of sense.  In any case, remapping would retain redundancy
>> where applicable short of full drive failure or remap overflow.
> 
> If the hard drives already do this, why should md try to do it as well??
> If a hard drive has had some many write errors that it has used up all of its
> spare space, then it is long past time to replace it.

True enough.

>> My $0.02, of course.
> 
> Here in .au, the smallest legal tender is $0.05 - but thanks anyway :-)

I guess the offer of "a penny for your thoughts" doesn't work down under ;)

Phil
