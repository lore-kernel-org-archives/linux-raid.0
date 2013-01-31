From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 18:47:25 +0100
Message-ID: <20130131174725.GA2441@lazy.lzy>
References: <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
 <20130128204422.GA14115@lazy.lzy>
 <20130128231840.03C37203AD5@gemini.denx.de>
 <20130129175720.GB2396@lazy.lzy>
 <20130129184309.D65DD2A1846@gemini.denx.de>
 <20130129202433.GB7005@lazy.lzy>
 <20130131121220.F3CA220059E@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130131121220.F3CA220059E@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 31, 2013 at 01:12:20PM +0100, Wolfgang Denk wrote:
> Dear Piergiorgio,
> 
> In message <20130129202433.GB7005@lazy.lzy> you wrote:
> >
> > If all error report by raid6check, on the three
> > systems, are "unknown", then it seems to be a
> > software problem.
> 
> I think we can be pretty sure of this now.  For a test, I installed a
> vanilla mainline Linux kernel (v3.8-rc5) on the affected machines.
> 
> A "check" operation showed no more problems, but "raid6test"
> still reported a large number of errors like these:

Hi Wolfgang,

this surprise me quite a lot, the two checks should
have similar results. The only algorithmic difference
I know of is that raid6check reports "per stripe",
while the in kernel check should report "per block".
 
> ...
> P(4) wrong at 10291
> Q(5) wrong at 10291
> Error detected at 10291: disk slot unknown
> P(3) wrong at 10292
> Q(4) wrong at 10292
> Error detected at 10292: disk slot unknown
> P(2) wrong at 10293
> Q(3) wrong at 10293
> Error detected at 10293: disk slot unknown
> ...
> 
> After running a "repair" on the array, both "check" and "raid6test"
> would not report any further issues.

Which is again a surprise, if the repair changed
the parities, then the raid6check should complain,
if before it was not.
 
This confuses me a lot, I think Neil Brown or
H. Peter Anvin should comment on this situation.

bye.

-- 

piergiorgio
