From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 20:22:56 +0100
Message-ID: <20130128192256.GB13803@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130128191041.8E962200607@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2013 at 08:10:41PM +0100, Wolfgang Denk wrote:
[...]
> etc. etc. [The test is still running, but I already have more than
> 10k such lines...]

Hi Wolfgang,

please grep for "Error".

> What does this tell us?

There are for sure parity errors, but it would be
more interesting to know (that's why "Error") if
a specific device has/had problems.

> Note:  on one system (where I can recreate / rstore the content of the
> array more easily) I decided to play some experiments, so I ran a
> "repair" on the array.  The repair completed without any error
> indicateion - but ended with a mismatch_cnt = 362731480.

I guess this is expected, the "repair" has the parities
fixed, nothing more, while reporting how many fixes.
 
> My simple tests still ndicate no data corrption (but then I might just
> be looking in the wrong places).

Well, this might be possible, even if I would not
count on it...

bye,

-- 

piergiorgio
