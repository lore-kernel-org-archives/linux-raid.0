From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Locking bugs in 2.4 md.c
Date: Mon, 22 Sep 2003 15:54:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16238.36518.991915.293076@notabene.cse.unsw.edu.au>
References: <20030918152310.GD30852@marowsky-bree.de>
	<16234.25885.855209.372799@notabene.cse.unsw.edu.au>
	<20030919072610.GB3143@marowsky-bree.de>
	<20030919083639.GE3143@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Marowsky-Bree on Friday September 19
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@suse.de
List-Id: linux-raid.ids

On Friday September 19, lmb@suse.de wrote:
> On 2003-09-19T09:26:10,
>    Lars Marowsky-Bree <lmb@suse.de> said:
> 
> > > A patch against 2.4-current is below.  It probably works but I haven't
> > > reviewed it in the context of other recent changes to md so I make no
> > > promises.
> > Thanks. I'll merge it against the current 2.4.
> 
> Hi Neil, turns out your patch did exactly what I did with lock_mddev(),
> just with a bigger granularity (which I think is a good thing, but I was
> too shy to introduce a new lock).
> 
> However, I can still reliably panic the kernel with the sequence I gave
> on a SMP box, even though the panic now seems to occur in different
> places...

I can't !!
If you can show me a stack trace or some pointers to wher it panics, I
can look further.

NeilBrown
