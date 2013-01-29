From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 21:24:34 +0100
Message-ID: <20130129202433.GB7005@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
 <20130128204422.GA14115@lazy.lzy>
 <20130128231840.03C37203AD5@gemini.denx.de>
 <20130129175720.GB2396@lazy.lzy>
 <20130129184309.D65DD2A1846@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130129184309.D65DD2A1846@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2013 at 07:43:09PM +0100, Wolfgang Denk wrote:
[...]
> I am not a friend of quick conclusions in cases like this, but I think
> that hardware issues are very unlikely to hit with identical effects
> simultaneously on 3 different machines in 2 different locations.

Hi Wolfgang,

yep, I think the same.
If all error report by raid6check, on the three
systems, are "unknown", then it seems to be a
software problem.

> 
> > > OK, add more hardware details...
> > > 
> > > A: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
> > > H: Supermicro X8ST3 mainboard, Xeon CPU W3565  @ 3.20GHz, 24 GB RAM
> > > X: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
> >  
> > What does the kernel log says about the choosen
> > RAID6 algorithm?
> 
> System A:
> 
> [   57.121902] raid6: sse2x1    7660 MB/s
> [   57.138892] raid6: sse2x2    8687 MB/s
> [   57.155890] raid6: sse2x4    9789 MB/s
> [   57.155891] raid6: using algorithm sse2x4 (9789 MB/s)
> [   57.155892] raid6: using ssse3x2 recovery algorithm
> 
> System H:
> 
> [   45.360607] raid6: sse2x1    7753 MB/s
> [   45.403614] raid6: sse2x2    8777 MB/s
> [   45.445612] raid6: sse2x4    9773 MB/s
> [   45.472547] raid6: using algorithm sse2x4 (9773 MB/s)
> [   45.503347] raid6: using ssse3x2 recovery algorithm
> 
> System X:
> 
> [   51.471793] raid6: sse2x1    3996 MB/s
> [   51.517657] raid6: sse2x2    4851 MB/s
> [   51.566579] raid6: sse2x4    4960 MB/s
> [   51.598831] raid6: using algorithm sse2x4 (4960 MB/s)
> [   51.638697] raid6: using ssse3x2 recovery algorithm

This ssse3x3 I do not know, it seems new to me,
but I might be wrong, we would need someone
with more insight of RAID6 implementation.
 
> Note: I remembered that I converted yet another machine which has a
> (smaller) RAID6 array (4 x SAMSUNG SpinPoint F1 HE502IJ) on a less
> powerful PC (Gigabyte P35-DS3R mainboard, Intel Core 2 Duo CPU E6750
> @ 2.66GHz, 8 GB RAM).  This shows NO problems (so far).  Here I have:
> 
> [   11.253015] raid6: sse2x1    1902 MB/s
> [   11.270021] raid6: sse2x2    2296 MB/s
> [   11.287274] raid6: sse2x4    3171 MB/s
> [   11.287533] raid6: using algorithm sse2x4 (3171 MB/s)
> [   11.288127] raid6: using ssse3x2 recovery algorithm
> 
> 
> If you can draw any conclusions from that - I can't.

It is also the slower...
Nevertheless, at this point, I cannot draw
any conclusions too... Sorry.
 
bye,

-- 

piergiorgio
