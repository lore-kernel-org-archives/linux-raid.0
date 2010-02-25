From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 20:07:10 +1100
Message-ID: <20100225200710.674ae669@notabene.brown>
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
	<20100225083203.4936ee63@notabene.brown>
	<4B86393F.4040707@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B86393F.4040707@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Feb 2010 08:47:59 +0000
John Robinson <john.robinson@anonymous.org.uk> wrote:

> On 24/02/2010 21:32, Neil Brown wrote:
> [...]
> > If you open /dev/md0 with O_DIRECT there is no page cache involved and so no
> > setting of Dirty flags.  So you could engineer a situation with O_DIRECT
> > that writes different data to the two devices, but you would have to try
> > fairly hard.
> 
> Hang on. O_DIRECT sets off all sort of alarm bells for me, not that I 
> understand it properly. Of course there's O_DIRECT on files too. Linus 
> Torvalds is quite outspoken about it: http://kerneltrap.org/node/7563
> 
> Could we be seeing mismatches because applications are opening their 
> files with O_DIRECT in a (perhaps misguided) attempt to get better 
> performance?

Unlikely.
The app would need to be doing async direct-io, or it would need to be have
multiple threads, and in either case it would need to change the buffer that
was being written while the write was happening.  And that would be a pretty
dumb thing to do unless it almost immediately wrote the same buffer out again.

So not exactly impossible, but probably the least-likely of the various
possible explanations.

NeilBrown
