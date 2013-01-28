From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 15:47:13 -0700
Message-ID: <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128204422.GA14115@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28, 2013, at 1:44 PM, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:


> It could still be the data is as it was written,
> but, for some reasons I could not imagine, the
> parities (both) are not correct.

In RAID 6 are the two parity chunks in a stripe identical? If yes, does 'unknown' only tell us that the data chunk recomputed parity does not match either of the parity chunks; or does it tell us anything about whether the parity chunks themselves are still the same or different?

> 
> This could be in case of some software bug, which
> would be quite a surprise, I must say.

Yes, it sounds reproducible on more than one array, more than one HBA. Is it also more than one computer also, Wolfgang?

I think regression is going to be needed to find it. Hopefully the problem is restricted to parity computation and data chunks aren't affected; however if a URE occurs in a data chunk, it could be reconstructed incorrectly from bad parity so it's obviously still a big problem.

Chris Murphy

