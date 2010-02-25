From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 21:41:22 +1100
Message-ID: <20100225214122.14a5cf83@notabene.brown>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com>
	<20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
	<20100225083936.07cd48ad@notabene.brown>
	<4B8640A2.4060307@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8640A2.4060307@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Feb 2010 10:19:30 +0100
Asdo <asdo@shiftmail.org> wrote:

> Neil Brown wrote:
> > On Wed, 24 Feb 2010 11:12:09 -0500
> > "Martin K. Petersen" <martin.petersen@oracle.com> wrote:
> >
> >   
> >> So realistically both disk blocks are wrong and there's a window until
> >> the new, correct block is written.  That window will only cause problems
> >> if there is a crash and we'll need to recover.  My main concern here is
> >> how big the discrepancy between the disks can get, and whether we'll end
> >> up corrupting the filesystem during recovery because we could
> >> potentially be matching metadata from one disk with journal entries from
> >> another.
> >>     
> >
> > After a crash, md will only read from one of the devices (the first) until a
> > resync has completed.  So there should be no room for more confusion than you
> > would expect on a single device.
> Not enough, I'd say.
> The reads are from a single device, the first, but it's the writes which 
> you don't know if they go to firstly to the first device or in the 
> reverse order. So I'd still be concerned by what Martin says.

I'm getting bored of repeating myself, so I won't respond to this.

> 
> In addition in this ML there are people reporting that the mismatches 
> occur even when the system is always on, no crashes. So I think there is 
> another mechanism for mismatches (not sure if in addition or it's the 
> only mechanism).

Ditto

> 
> Besides, if the mechanism for mismatches is correct I'd go for the copy 
> (or page lock if possible). All raids have copy, except raid0 maybe, and 
> they are not slow. Here the copy would only occur on writes, and raid-1 
> is not targeted to be SO fast on writes... Also raid-1's are usually on 
> few disk, like no more than 3, so the copy is not likely to bottleneck 
> the speed of the writes.

I'm sure it would be a measurable slowdown, though < 20%.  Probably < 10%.  I
doubt everyone would be happy with that, though you might.

> 
> What about raid-10? Are there copies for the raid-1 part of raid-10?
> 

No.  Neither raid1 nor raid10 copy the data, only raid456.

NeilBrown


