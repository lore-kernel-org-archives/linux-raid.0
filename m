From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Sat, 27 Feb 2010 08:09:38 +1100
Message-ID: <20100227080938.6540f041@notabene.brown>
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
	<20100225083748.42f024aa@notabene.brown>
	<4B8833BA.4010503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8833BA.4010503@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Feb 2010 15:48:58 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> >
> > The idea of calculating a checksum before and after certainly has some merit,
> > if we could choose a checksum algorithm which was sufficiently strong and
> > sufficiently fast, though in many cases a large part of the cost would just be
> > bringing the page contents into cache - twice.
> >
> > It has the advantage over copying the page of not needing to allocate extra
> > memory.
> >
> > If someone wanted to try an prototype this and see how it goes, I'd be happy
> > to advise....
> >     
> 
> Disagree if you wish, but MD5 should be fine for this. While it is not 
> cryptographically strong on files, where the size can be changed and 
> evil doers can calculate values to add at the end of the data, it should 
> be adequate on data of unchanging size. It's cheap, fast, and readily 
> available.
> 

Actually, I'm no longer convinced that the checksumming idea would work.
If a mem-mapped page were written, that the app is updating every
millisecond (i.e. less than the write latency), then every time a write
completed the checksum would be different so we would have to reschedule the
write, which would not be the correct behaviour at all.
So I think that the only way to address this in the md layer is to copy
the data and write the copy.  There is already code to copy the data for
write-behind that could possible be leveraged to do a copy always.

Or I could just stop setting mismatch_cnt for raid1 and raid10.  That would
also fix the problem :-)

NeilBrown
