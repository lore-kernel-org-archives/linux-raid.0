From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 18:51:58 +0100
Message-ID: <20130131175158.GB2441@lazy.lzy>
References: <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
 <20130128204422.GA14115@lazy.lzy>
 <20130128231840.03C37203AD5@gemini.denx.de>
 <20130129175720.GB2396@lazy.lzy>
 <20130129184309.D65DD2A1846@gemini.denx.de>
 <20130129202433.GB7005@lazy.lzy>
 <20130131121220.F3CA220059E@gemini.denx.de>
 <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wolfgang Denk <wd@denx.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 31, 2013 at 10:14:35AM -0700, Chris Murphy wrote:
> 
> On Jan 31, 2013, at 5:12 AM, Wolfgang Denk <wd@denx.de> wrote:
> > 
> > After running a "repair" on the array, both "check" and "raid6test"
> > would not report any further issues.
> 
> Yes but this would be consistent with a derivative parity, written to disk and then checked against an algorithm that expects derivative parity. What happens if you go back to the old kernel before all the problems were happening and you do a check? What happens if you go back to a Fedora kernel you know exhibited the problem and you do a check?
> 
> Question for Piergiorgio is if check and raid6test use the same, or independent, code for checking parity?

Hi Chris,

the code base is different, namely raid6check
uses plain C, with no optimizations (that's
why is so sloooow), while the kernel code has
different paths, depending on which optimization
is available and best.
The algorithm should be the same.

Nevertheless, the tests I run, intentionally
and unintentionally, on raid6check were always
consistent, so this surprise me.
 
> > I'll continue to watch this for a while, but I think I will not
> > "update" to a Fedora kernel for some time...
> 
> 
> I think a bug needs to be filed with the information you have thus far.

I fully agree with this, what was seen there
is for sure not normal.

bye,

-- 

piergiorgio
