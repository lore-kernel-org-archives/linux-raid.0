From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 09:15:26 +0100
Message-ID: <20050110081526.GA15920@janus>
References: <crmt7e$8d6$1@sea.gmane.org> <200501092226.25910.maarten@ultratux.net> <20050109222900.GA12793@janus> <200501100016.58847.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501100016.58847.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 10, 2005 at 12:16:58AM +0100, maarten wrote:
> On Sunday 09 January 2005 23:29, Frank van Maarseveen wrote:
> 
> I either don't understand this, or I don't agree. Assemble --force effectively 
> disables all sanitychecks,

ok, wasn't sure about that. but then:

> The result is 
> therefore an array that either (A) holds a good FS with a couple of corrupted 
> files (silent corruption)

> So I certainly would opt for the "possibility of silent corruption" choice. 
> And if I ever find the corrupted file I delete it and mark it for 'new 
> retrieval" or some such followup.  Or restore from tape where applicable.
> 
> > so, we can't ignore errors during RAID5 reconstruction and we're toast
> > if it happens, even more toast than we would have been with a normal
> > disk (barring the case of an entirely dead disk). If you look at the
> > lower level then of course RAID5 has an advantage but to me it seems to
> > vaporize when exposed to the _complexity_ of handling secondary errors
> > during the reconstruction.
> 
> You cut out my entire idea about leaving the 'failed' disk around to 
> eventually being able to compensate a further block error on another media.  
> Why ?  It would _solve_ your problem, wouldn't it ?

I did not intend to cut it out but simplified the situation a bit: if
you have all the RAID5 disks even with a bunch of errors spread out over
all of them then yes, you basically still have the data.  Nothing is
lost provided there's no double fault and disks are not dead yet. But
there are not many technical people I would trust for recovering from
this situation. And I wouldn't trust myself without a significant
coffee intake either :)

-- 
Frank
