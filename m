From: Erkki Seppala <flux@modeemi.fi>
Subject: Re: Md says 'bug' to kernel log
Date: Tue, 15 Oct 2002 14:48:12 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021015114811.GA23499@modeemi.fi>
References: <20021012065457.GA26887@modeemi.fi> <15787.62003.633385.687754@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15787.62003.633385.687754@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I assume you're on the list, thus sending only there.

On Tue, Oct 15, 2002 at 08:47:15PM +1000, Neil Brown wrote:
> Yes.  raidhotremove will only remove an inactive spare or a failed
> device.  Once rebuilding has started, you have to cause the device to
> fail before it can be removed:

Oh, well this must be the datapoint I was missing :). Sounds annoyingly like
something that would be in a faq, but otoh, it does sound like a misfeature
too. Thanks for advice!

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/
