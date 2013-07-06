From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: question about the best suited RAID level/layout
Date: Sat, 6 Jul 2013 09:40:02 +0200
Message-ID: <20130706074001.GA2387@lazy.lzy>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>
 <51D5EC8A.40509@turmel.org>
 <1372978687.5249.52.camel@fermat.scientia.net>
 <51D61C58.2020207@fnarfbargle.com>
 <1373070976.5395.26.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373070976.5395.26.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 06, 2013 at 02:36:16AM +0200, Christoph Anton Mitterer wrote:
[...]
> Well but it's not a bad point either, is it?
> And when we remember back at the issues (IIRC) Seagate had with the
> firmwares of some of it's devices, that suddenly stopped working at some
> special date... than it could easily happen you're screwed with having
> all disks from one vendor i.e. with the same type.
> 
> I vaguely remember that back then there were even cases where firmware
> updates didn't help anymore... but I may be wrong on that.

Hi Chris,

we have some workstation with RAID5, 4 HDDs, from
4 different vendors (at that time there were 4).

We notice smart errors at a different rate, time and
type, but almost always in the same way for each brand.

In other words, yes, it helped to have different brands.

The only thing, you must confirm the size.
Ours are all identical, but I can imagine there could
be minor differences, expecially from 512B to 4096B.

bye,

-- 

piergiorgio
