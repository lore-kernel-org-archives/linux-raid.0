From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 08:32:03 +1100
Message-ID: <20100225083203.4936ee63@notabene.brown>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B853BBF.7000607@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 09:46:23 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> > There is no question of data corruption.
> > When memory changes between being written to one device and to another, this
> > does not cause corruption, only inconsistency.   Either the block will be
> > written again consistently soon, or it will never be read.
> >     
> 
> Just what is it that rewrites the data block? The user program doesn't 
> know it's needed, the filesystem, if any, doesn't know it's needed, and 
> as far as I can tell md doesn't do checksum before issuing the write and 
> after the last write is done. Doesn't make a copy and write from that. 
> So what sees that the data has changed and rewrites it?
> 

The filesystem re-writes the block, though probably it is more accurate to
say 'the page cache' rewrites the block (the page cache is essentially just a
library of code that the filesystem uses).

When a page is changed, its 'Dirty' flag is set.
Before a page is written out, the Dirty flag is cleared.
So if a page is written differently to two devices, then it must have been
changed after the Dirty flag was clear, so the Dirty flag will be set, so the
page cache will try to write it out again (after about 30 seconds or at
unmount time).

When accessing a block device directly ( > /dev/md0 ) the page cache is still
used and will still write out any page that has the Dirty flag set.

If you open /dev/md0 with O_DIRECT there is no page cache involved and so no
setting of Dirty flags.  So you could engineer a situation with O_DIRECT
that writes different data to the two devices, but you would have to try
fairly hard.

NeilBrown
