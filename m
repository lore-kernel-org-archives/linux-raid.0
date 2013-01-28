From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 21:44:22 +0100
Message-ID: <20130128204422.GA14115@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130128201947.2B615200607@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2013 at 09:19:47PM +0100, Wolfgang Denk wrote:
[...]
> P(0) wrong at 1951871
> Q(1) wrong at 1951871
> Error detected at 1951871: disk slot unknown
> ...
> 
> Does this allow to tell which disk it is?

Hi Wolfgang,

unfortunately, this means more than one disk
has data which cannot match the parities.
If only one disk would have been corrupted, we
could have seen it reported (apart from patological
cases), but when the slot is "unknown" it means
the detection was not possible.

It could still be the data is as it was written,
but, for some reasons I could not imagine, the
parities (both) are not correct.

This could be in case of some software bug, which
would be quite a surprise, I must say.

Still, would be nice to check if the whole array
is it this state or if, sooner or later, some
knwon slot (with error) is found somewhere else.

bye,

-- 

piergiorgio
