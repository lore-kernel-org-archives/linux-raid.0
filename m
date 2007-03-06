From: Paul Davidson <Paul.Davidson@anu.edu.au>
Subject: Re: mismatch_cnt questions
Date: Tue, 06 Mar 2007 17:27:38 +1100
Message-ID: <45ED09DA.20004@anu.edu.au>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com> <17898.45673.573800.56474@notabene.brown> <45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17899.18568.523543.478792@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I've been following this thread with interest and I have a few questions.

Neil Brown wrote:
> On Monday March 5, eyal@eyal.emu.id.au wrote:
> 
>>Neil Brown wrote:
> 
>>When a disk fails we know what to rewrite, but when we discover a mismatch
>>we do not have this knowledge. It may corrupt the good copy of a raid1.
> 
> If a block differs between the different drives in a raid1, then no
> copy is 'good'.  It is possible that one copy is the one you think you
> want, but you probably wouldn't know by looking at it.
> The worst situation is the have inconsistent data. If you read and get
> one value, then later read and get another value, that is really bad.
> 
> For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
> and writing it over all other copies.
> For raid5 we assume the data is correct and update the parity.

Wouldn't it be better to signal an error rather than potentially
corrupt data - or perhaps this already happens? Does the above only
refer to a 'repair' action?

I'm worrying here about silent data corruption that gets on to my
backup tapes. If an error was (is?) signaled by the raid system
during the backup and could be tracked to the file being copied at
the time, it would allow recovery of the data from a prior
backup. If raid remains silent, the corrupted data eventually
gets copied onto my entire backup rotation. Can you comment on this?

FWIW, my 600GB raid5 array shows mismatch_cnt of 24 when I 'check'
it - that machine has hung up on occasion.

Cheers,
Paul
