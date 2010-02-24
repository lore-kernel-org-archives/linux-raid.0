From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 08:37:48 +1100
Message-ID: <20100225083748.42f024aa@notabene.brown>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com>
	<20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<20100219151809.GB4995@lazy.lzy>
	<20100220090208.06c1130f@notabene.brown>
	<4B853D99.1040902@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B853D99.1040902@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 09:54:17 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > md is not in a position to lock the page - there is simply no way it can stop
> > the filesystem from changing it.
> > The only thing it could do would be to make a copy, then write the copy out.
> > This would incur a performance cost.
> >
> >     
> Two thoughts on that - one is that for critical data, give me the option 
> at array start time, make the copy, slow the performance and make it 
> more consistent. My second thought is that a checksum of the page before 
> initiating write and after all writes are complete might be less of a 
> performance hit, and still could detect that the buffer had changed.


The idea of calculating a checksum before and after certainly has some merit,
if we could choose a checksum algorithm which was sufficiently strong and
sufficiently fast, though in many cases a large part of the cost would just be
bringing the page contents into cache - twice.

It has the advantage over copying the page of not needing to allocate extra
memory.

If someone wanted to try an prototype this and see how it goes, I'd be happy
to advise....

NeilBrown
