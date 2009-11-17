From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid10 layout for 2xSSDs
Date: Tue, 17 Nov 2009 05:36:24 +0100
Message-ID: <87tywtlqd3.fsf@frosties.localdomain>
References: <1258381745.31633.35.camel@localhost>
	<878we61oev.fsf@frosties.localdomain>
	<20091116163102.GB28577@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091116163102.GB28577@cthulhu.home.robinhill.me.uk> (Robin
	Hill's message of "Mon, 16 Nov 2009 16:31:03 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill <robin@robinhill.me.uk> writes:

> On Mon Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:
>
>> What I'm aiming at is that offset might better fit into erase blocks,
>> cause less internal fragmentation on the disk and give better wear
>> leveling. Might improve speed and lifetime. But that is just a
>> thought. Maybe test and do ask Intel (or other vendors) about it.
>> 
> I very much doubt this will make any difference.  With SSDs you have to
> throw out any preconceptions of internal layout you may have.  You have
> absolutely no idea (or control of) where two consecutive blocks will
> actually get written.  Fragmentation and seek time are thus irrelevant
> (or uncontrollable anyway).
>
> I don't see how any RAID-10 layout would perform better than another
> with SSDs, unless there's internal optimisations/constraints which
> affect sequential reading from multiple devices.  I'm not aware of any
> though - RAID-10 n2 may be the same layout as RAID-1 but it's an
> entirely separate piece of code.
>
> Cheers,
>     Robin

Depending on the SSD in question the limiting factor will be the
number of IO operations per second. Some SSDs have shown that they can
write the same number of 1 byte blocks per second as they can write
64k bytes per second. If offset writes 2x 64k but far writes 4x 32k
then far will be half the speed on such a cheap SSD.

MfG
        Goswin
