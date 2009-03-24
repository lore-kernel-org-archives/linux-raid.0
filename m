From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Tue, 24 Mar 2009 20:32:36 +0100
Message-ID: <87ljquemy3.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<18882.54987.332211.49180@notabene.brown>
	<20090323202043.GA3841@compegg.wr.niftyegg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090323202043.GA3841@compegg.wr.niftyegg.com> (Nifty Fedora
	Mitch's message of "Mon, 23 Mar 2009 13:20:43 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nifty Fedora Mitch <niftyfedora@niftyegg.com> writes:

>> On Tuesday March 17, goswin-v-b@web.de wrote:
>> > Hi,
>> > 
>> > I'm wondering why the kernel requires a raid6 to have at least 4
>> > disks (of which at most 2 can be missing). Why not 3 disks?
>
> I should think that this is the 'defination' of a raid6.
> If you build a raid6 resource it should be raid6 and
> as such be able to tolerate the loss of two disks
> and all the other raid6 properties.

Actually the definition I read was that raid6 is like raid5 but
allowing for 2 or more disks to fail without loss. So a 15 disks raid
with 10 data blocks and 5 parity blocks per stripe would also be raid6.

> If you build a raidN with three disks that can tolerate the
> loss of one disk it is not raid6 but raid5 and should be called
> by the correct descriptive name.

I was talking about a raid6 with three disks that can tolerate the
loss of *two* disks. I know that effectively that would be just like a
raid1 with 3 disks but that was exactly the point. To change a 3 disk
raid1 into a 3 disk raid6 and then grow it.

> The importance of this strictness surfaces in documentation.   
> Both to the system admin working on the system and also
> documentation from the system admin to his management that
> is comparing prices and matching features.   i.e. "Bob's raid6 
> is 25% less costly than Fred's".   Truth in advertising comes
> to play.
>
> Hidden in this thread is an interesting notion of migration from a
> "lesser" raid to a more durable raid over time.   It might make sense to
> facilitate limited tools to this end.   Even for those sites that wish to stage
> the construction of a large raid install or to stagger the poweron hours
> and date codes of drives on the common notion that batches of drives
> fail together.  Or perhaps a "raid6 ready" raid5 that gets populated with
> the absent drive on the first statistical sniff of an error outside of
> the norm.  Or the arrival of warrenty expiration....

That would be a raid6 with 4 disks of which one is missing. You can
already do that.

> Such a "raidN ready" setup does confuse the notion of operational health
> for any monitoring tool and is likely a very bad idea for that reason alone.
>
> This 2001 URL is interesting in the comments about how unfortunate the
> choice of the world "level" was.
>    http://www.pcguide.com/ref/hdd/perf/raid/levels/index.htm
> also interesting is the coment about a vendor being sloppy
> with the technical language.

Verry badly advertising polluted url and confusing imho.

http://en.wikipedia.org/wiki/RAID

MfG
        Goswin


