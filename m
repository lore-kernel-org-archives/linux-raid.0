From: "NeilBrown" <neilb@suse.de>
Subject: Re: Redundancy check using "echo check > sync_action": error
     reporting?
Date: Sat, 22 Mar 2008 07:19:41 +1100 (EST)
Message-ID: <42039.192.168.1.70.1206130781.squirrel@neil.brown.name>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak>
    <47E26775.3000500@tuxes.nl>
    <20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
    <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu>
    <20080320173906.GN32242@skl-net.de> <20080320180241.GJ13719@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080320180241.GJ13719@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andre Noll <maan@systemlinux.org>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, March 21, 2008 5:02 am, Theodore Tso wrote:
> On Thu, Mar 20, 2008 at 06:39:06PM +0100, Andre Noll wrote:
>> On 12:35, Theodore Tso wrote:
>>
>> > If a mismatch is detected in a RAID-6 configuration, it should be
>> > possible to figure out what should be fixed
>>
>> It can be figured out under the assumption that exactly one drive has
>> bad data and all other ones have good data. But that seems to be an
>> assumption that is hard to verify in reality.
>
> True, but it's what ECC memory does.  :-)   And most people agree that
> it's a useful thing to do with memory.
>
> If you do ECC syndrome checking on every read, and follow that up with
> periodic scrubbing so that you catch (and correct) errors quickly, it
> is a reasonable assumption to make.

My problem with this is that I don't have a good model for what might
cause the error, so I cannot reason about what responses are justifiable.

The analogy with ECC memory is, I think, poor.  With ECC memory there are
electro/physical processes which can cause a bit to change independently
of any other bit with very low probability, so treating an ECC error as
a single bit error is reasonable.

The analogy with a disk drive would be a media error.  However disk drives
record CRC (or similar) checks so that media errors get reported as errors,
not as incorrect data.  So the analogy doesn't hold.

Where else could the error come from?  Presumably a bit-flip on some
transfer bus between main memory and the media.  There are several
of these busses (mem to controller, controller to device, internal to
device).  The corruption could happen on the write or on the read.
When you write to a RAID6 you often write several blocks to different
devices at the same time.  Are these really likely to be independent
events wrt whatever is causing the corruption?

I don't know.  But without a clear model, it isn't clear to me that
any particular action will be certain to improve the situation in
all cases.

And how often does silent corruption happen on modern hard drives?
How often do you write something and later successfully read something
else when it isn't due to a major hardware problem that is causing
much more that just occasional errors?

The ZFS people seem to say that their checksumming of all data shows
up a lot of these cases.  If that is true, how come people who
don't use ZFS aren't reporting lots of data corruption?

So yes: there are lots of things that *could* be done.  But without
a model for the "threat", an analysis of how the remedy would actually
affect every different possible scenario, and some idea of the
probability of the remedy being needed, it is very hard to
justify a change of this sort.
And there are plenty of other things to be coded that are genuinely
useful - like converting a RAID5 to a RAID6 while online...

NeilBrown


