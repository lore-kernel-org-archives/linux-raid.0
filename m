From: "Kenn" <kenn@kenn.us>
Subject: Re: Recovering from a Bad Resilver / Rebuild
Date: Mon, 26 Sep 2011 16:46:24 -0700
Message-ID: <ab6d59c609b0240ecf50257d0931cb1d.squirrel@www.maxstr.com>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
    <20110926145248.6ffc5f02@notabene.brown>
    <20110926130351.63adc330@natsu>
Reply-To: kenn@kenn.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926130351.63adc330@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: david.brown@hesbynett.no
List-Id: linux-raid.ids

>> On Mon, 26 Sep 2011 14:52:48 +1000
>> NeilBrown <neilb@suse.de> wrote:
>>
>> On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn" <kenn@kenn.us> wrote:
>>
>> So that brings up another point -- I've been reading through your blog,
>> and I acknowledge your thoughts on not having much benefit to checksums on
>> every block (http://neil.brown.name/blog/20110227114201), but sometimes
>> people like to having that extra lock on their door even though it takes
>> more effort to go in and out of their home.  In my five-drive array, if
>> the last five words were the checksums of the blocks on every drive, the
>> checksums off each drive could vote on trusting the blocks of every other
>> drive during the rebuild process, and prevent an idiot (me) from killing
>> his data.  It would force wasteful sectors on the drive, perhaps harm
>> performance by squeezing 2+n bytes out of each sector, but if someone
>> wants to protect their data as much as possible, it would be a welcome
>> option where performance is not a priority.
>>
>> Also, the checksums do provide some protection: first, against against
>> partial media failure, which is a major flaw in raid 456 design according
>> to http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt , and checksum
>> voting could protect against the Atomicity/write-in-place flaw outlined in
>> http://en.wikipedia.org/wiki/RAID#Problems_with_RAID .
>>
>> What do you think?
>>
>> Kenn
> On Sun, 26 Sep 2011 19:56:50 -0700 "David Brown"
<david.brown@hesbynett.no> wrote:
>
> /raid/ protects against partial media flaws.  If one disk in a raid5
> stripe has a bad sector, that sector will be ignored and the missing
> data will be re-created from the other disks using the raid recovery
> algorithm.  If you want to have such protection even when doing a resync
> (as many people do), then use raid6 - it has two parity blocks.
>
> As Neil points out in his blog, it is impossible to fully recover from a
> failure part way through a write - checksum voting or majority voting
> /may/ give you the right answer, but it may not.  If you need protection
> against that, you have to have filesystem level control (data logging
> and journalling as well as metafile journalling), or perhaps use raid
> systems with battery backed write caches.

From what I understand of basic RAID theory, the "If one disk in a raid5
stripe has a bad sector," is the part that's based on too much faith in
the hardware.  RAID trusts the hardware to send it errors when there are
read failures, and it's helpless when the drive reads garbage without an
error and returns it as a good read.  During a rebuild this will destroy a
good array.  This is the argument against RAID in the articles I listed,
and why checksums in the blocks would be helpful as they get around this
blind spot.  And they give early warning on reads that something is dying.
 Having each block's checksums in all the other blocks in the stripe lets
md detect a previously failed atomic write and give another early warning.

I think for people coming from the "can't be too safe" mindset, these
checksums would be welcome, and basically, anyone who signs up for RAID5/6
already is choosing safety over performance.

Kenn

