From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 19:43:09 +0100
Message-ID: <20130129184309.D65DD2A1846@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130129175720.GB2396@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20130129175720.GB2396@lazy.lzy> you wrote:
>
> my personal opinion would be to confirm
> *all* the data is OK, if you can.

Unfortunately I have no easy way doing this.  Most of the data are
working trees of software builds, or build results, so I have no
checksum or other information.  But all files I accessed so far, of
where I was able to check, were actually correct.

> Uhm, as mentioned, it would be nice to
> find a specific error slot...
> Well, not so nice, but this would point
> to an HW problem.

I am not a friend of quick conclusions in cases like this, but I think
that hardware issues are very unlikely to hit with identical effects
simultaneously on 3 different machines in 2 different locations.


> > OK, add more hardware details...
> > 
> > A: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
> > H: Supermicro X8ST3 mainboard, Xeon CPU W3565  @ 3.20GHz, 24 GB RAM
> > X: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
>  
> What does the kernel log says about the choosen
> RAID6 algorithm?

System A:

[   57.121902] raid6: sse2x1    7660 MB/s
[   57.138892] raid6: sse2x2    8687 MB/s
[   57.155890] raid6: sse2x4    9789 MB/s
[   57.155891] raid6: using algorithm sse2x4 (9789 MB/s)
[   57.155892] raid6: using ssse3x2 recovery algorithm

System H:

[   45.360607] raid6: sse2x1    7753 MB/s
[   45.403614] raid6: sse2x2    8777 MB/s
[   45.445612] raid6: sse2x4    9773 MB/s
[   45.472547] raid6: using algorithm sse2x4 (9773 MB/s)
[   45.503347] raid6: using ssse3x2 recovery algorithm

System X:

[   51.471793] raid6: sse2x1    3996 MB/s
[   51.517657] raid6: sse2x2    4851 MB/s
[   51.566579] raid6: sse2x4    4960 MB/s
[   51.598831] raid6: using algorithm sse2x4 (4960 MB/s)
[   51.638697] raid6: using ssse3x2 recovery algorithm


Note: I remembered that I converted yet another machine which has a
(smaller) RAID6 array (4 x SAMSUNG SpinPoint F1 HE502IJ) on a less
powerful PC (Gigabyte P35-DS3R mainboard, Intel Core 2 Duo CPU E6750
@ 2.66GHz, 8 GB RAM).  This shows NO problems (so far).  Here I have:

[   11.253015] raid6: sse2x1    1902 MB/s
[   11.270021] raid6: sse2x2    2296 MB/s
[   11.287274] raid6: sse2x4    3171 MB/s
[   11.287533] raid6: using algorithm sse2x4 (3171 MB/s)
[   11.288127] raid6: using ssse3x2 recovery algorithm


If you can draw any conclusions from that - I can't.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
GUIs  are  virtually  useless.  Learn  tools.  They're  configurable,
scriptable, automatable, cron-able, interoperable, etc. We don't need
no brain-dead winslurping monolithic claptrap.
                               -- Tom Christiansen in 371140df@csnews
