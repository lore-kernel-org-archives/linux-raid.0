From: Neil Brown <neilb@suse.de>
Subject: Re: Need clarification on raid1 resync behavior with bitmap support
Date: Sat, 4 Aug 2007 07:33:45 +1000
Message-ID: <18099.40761.348959.46664@notabene.brown>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
	<18084.22271.122052.80056@notabene.brown>
	<170fa0d20707230547y3accc5c9v14805fdb3637e9c0@mail.gmail.com>
	<18098.52840.936611.7816@notabene.brown>
	<170fa0d20708030641l258ff0adrfdfa7726f746969e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Friday August 3
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 3, snitzer@gmail.com wrote:
> 
> I hand-patched your change into a 2.6.20.1 kernel (I'd imagine your
> patch is against current git).  I didn't see any difference because
> unfortunately both of my full resync scenarios included stopping a
> degraded raid after either: 1) having failed but not been removed a
> member 2) having failed and removed a member.  In both scenarios if I
> didn't stop the array and I just removed and re-added the faulty drive
> the array would _not_ do a full resync.
> 
> My examples clearly conflict with your assertion that: "This only
> works if the array has not been shut down and restarted."

I think my changelog entry for the patch was poorly written.
What I meant to say was:
  *before this patch*  a remove and re-add only does a partial resync
    if the array has not been shutdown and restarted in the interim.
  The implication being that *after the patch*, a shutdown and restart
  will not interfere and a remove followed by a readd will always do a
  partial resync, even if the array was shutdown and restarted while
  degraded.

> 
> To be explicit: isn't the bitmap still valid on the fresh members?  If
> so, why is raid1 just disregarding the fresh bitmap?

Yes.  Exactly.  It is my understanding and experience that the patch I
sent fixes a bug so that it doesn't disregard the fresh bitmap.  It
should fix it for 2.6.20.1 as well.

Are you saying that you tried the same scenario with the patch applied
and it still did a full resync?  How do you measure whether it did a
full resync or a partial resync?

Thanks,
NeilBrown
