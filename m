From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 10:43:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16769.37446.970293.945527@cse.unsw.edu.au>
References: <cleqh6$ps4$1@terminus.zytor.com>
	<16764.37392.910080.718564@cse.unsw.edu.au>
	<20041025062026.GA17502@jim.sh>
	<16767.6168.695527.234379@cse.unsw.edu.au>
	<417F30C7.9050308@zytor.com>
	<20041027060018.GA17085@jim.sh>
	<418048C1.8030404@zytor.com>
	<20041028160003.GA3502@jim.sh>
	<4181313D.5050905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Thursday October 28
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 28, hpa@zytor.com wrote:
> Jim Paris wrote:
> > 
> > Another issue:  If I create a 6-disk RAID-6 array ...
> > 
> > ... with 2 missing, no resync happens.
> > ... with 1 missing, no resync happens.  (???)
> > ... with 0 missing, resync happens.
> > ... with 2 missing, then add 1, recovery happens.
> > ... with 0 missing, then fail 1, resync continues.
> > 
> > Shouldn't resync happen in the created-with-1-disk-missing case?
> > 
> 
> Nevermind, I guess it probably should, since there is still redundancy 
> and therefore it can be inconsistent.
> 
> 	-hpa

I have a patch to mdadm to make it resync when there is one failure,
but I'm no longer convinced that it is needed.
In fact, the initial resync isn't really needed for raid6 (or raid1)
at all.  The first write to any stripe will make the redundancy for
that stripe correct regardless of what it was, and before the first
write, the content of the array is meaningless anyway.

Note that this is different to raid5 which, if using a
read-modify-write cycle, depends on the parity block being correct.

There would be an issue once we start doing background scans of the
arrays as the first scan could find lots of errors.  But maybe that
isn't a problem....

I'll probably include the patch in the next mdadm release, and revisit
the whole idea when (if) I implement background array scans.

NeilBrown
