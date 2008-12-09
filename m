From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Data integrity and RAID
Date: Tue, 9 Dec 2008 10:55:21 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812091055060.29505@p34.internal.lan>
References: <20841008.post@talk.nabble.com> <20081209144132.GA24906@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081209144132.GA24906@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 9 Dec 2008, Robin Hill wrote:

> On Tue Dec 09, 2008 at 06:02:57AM -0800, peter.stevens wrote:
>
>>
>> I'm looking for a software solution to help replace my existing raid hardware
>> setup. The hardware mimics RAID-1 (in that it has 3 mirrors), except for the
>> fact that on read all 3 mirrors are compared and possibly error corrected
>> before data is returned. I don't neccessarily need a RAID-1 solution, it
>> just seems closer to what I already have and also that it also can recover
>> from 2 simulateous disk failures.
>>
>> So far I've played with a software RAID-1 array of USB flash drives. My
>> issue is that software RAID-1 does not check for or recover from data
>> corruption unless a read or write to disk actually fails. Integrity is a
>> major concern for me, I need to know that all data going to and from disk is
>> correct at all times.
>>
>> All advice and comments are welcomed.
>>
> I'm not aware of anything, no.  Software RAID-1 will do some of what
> you're after but doesn't verify reads against all drives (this doesn't
> guarantee integrity anyway, only reduce the chance of an error).  You
> can run regular checks of the drives to detect (and repair) any
> data mismatches though.
>
> Mind you, to do this properly, you'd need to disable write caching on
> all drives; do a read of all drives after every write (to verify that
> the write was successful); and compare all drives on every read (to
> verify that the read was successful).  You probably also want checksums
> on the drives to help detect which drive(s) are incorrect on read
> mismatches as well (I believe there's now a standard for doing this, but
> I don't think it's supported end-to-end yet). Doing all this will really
> limit performance though - generally you'll be better off building error
> recovery into the file format instead.
Sounds like he should use ZFS.

