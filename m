From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [md PATCH 00/16] bad block list management for md and RAID1
Date: Tue, 29 Jun 2010 12:54:58 -0400
Message-ID: <4C2A2562.5080704@tmr.com>
References: <20100606235833.13302.60932.stgit@notabene.brown>	<hvd5iq$u83$1@dough.gmane.org>	<20100618132313.040cd303@notabene.brown>	<4C1BABC4.3020008@tmr.com> <20100629150635.7b1629a2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100629150635.7b1629a2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Brett Russ <bruss@netezza.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> The read balancing in RAID1 assumes that co-located reads are likely to be
> more efficient than widely disparate reads, but it isn't a very crucial
> assumption.  RAID10 assumes that if there is a systematic performance
> difference across the address space, performance is likely to be better
> nearer the start.
>
> Resync/recovery makes some very vague assumption about overall throughput in
> the default resync-max/min speeds, but they are very vague and easily tuned.
>   

Permit me to be inspired by these two paragraphs, and to suggest that 
the positional performance and rebuild speed relate to some issues in 
another thread about rebuild killing performance. Would it be possible 
(and not overly complex) to tune the rebuild/check speed to the other 
system load, such that instead of a max rebuild speed the limit would be 
the delay in servicing external (user generated) i/o? I don't have a 
metric in mind, but it seems as though both position on the drive and 
load on the system are important, and if a admin tunes the system to 
allow very low rates, under heavy system load or on slow parts of the 
drive(s).

I know there is a concept of "idle" involved, but the issue is not just 
if the array is being used, but rather how much the background activity 
is allowed to impact performance. Perhaps a count of the average number 
of user i/o behind a system i/o would be useful, if actual clock time 
isn't easy to use.

Does any of this sound as though some perceived performance issues might 
be addressed differently?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

