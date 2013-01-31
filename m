From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 13:12:20 +0100
Message-ID: <20130131121220.F3CA220059E@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy> <20130129184309.D65DD2A1846@gemini.denx.de> <20130129202433.GB7005@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130129202433.GB7005@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20130129202433.GB7005@lazy.lzy> you wrote:
>
> If all error report by raid6check, on the three
> systems, are "unknown", then it seems to be a
> software problem.

I think we can be pretty sure of this now.  For a test, I installed a
vanilla mainline Linux kernel (v3.8-rc5) on the affected machines.

A "check" operation showed no more problems, but "raid6test"
still reported a large number of errors like these:

...
P(4) wrong at 10291
Q(5) wrong at 10291
Error detected at 10291: disk slot unknown
P(3) wrong at 10292
Q(4) wrong at 10292
Error detected at 10292: disk slot unknown
P(2) wrong at 10293
Q(3) wrong at 10293
Error detected at 10293: disk slot unknown
...

After running a "repair" on the array, both "check" and "raid6test"
would not report any further issues.

I'll continue to watch this for a while, but I think I will not
"update" to a Fedora kernel for some time...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Chapter 1 -- The story so  far:
In the beginning the Universe was created. This has  made  a  lot  of
people very angry and been widely regarded as a bad move.
