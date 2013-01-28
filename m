From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 21:19:47 +0100
Message-ID: <20130128201947.2B615200607@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130128192256.GB13803@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20130128192256.GB13803@lazy.lzy> you wrote:
>
> please grep for "Error".
> 
> > What does this tell us?
> 
> There are for sure parity errors, but it would be
> more interesting to know (that's why "Error") if
> a specific device has/had problems.

So I see a large number (> 200,000 in one array, so far - check still
running) of "Error detected at ...: disk slot unknown" messages,
insequences for example like this:

...
Q(0) wrong at 1951856
Q(7) wrong at 1951857
P(5) wrong at 1951858
Q(6) wrong at 1951858
Error detected at 1951858: disk slot unknown
P(4) wrong at 1951859
Q(5) wrong at 1951859
Error detected at 1951859: disk slot unknown
P(3) wrong at 1951860
Q(4) wrong at 1951860
Error detected at 1951860: disk slot unknown
P(2) wrong at 1951861
Q(3) wrong at 1951861
Error detected at 1951861: disk slot unknown
P(1) wrong at 1951862
Q(2) wrong at 1951862
Error detected at 1951862: disk slot unknown
P(0) wrong at 1951863
Q(1) wrong at 1951863
Error detected at 1951863: disk slot unknown
Q(0) wrong at 1951864
Q(7) wrong at 1951865
P(5) wrong at 1951866
Q(6) wrong at 1951866
Error detected at 1951866: disk slot unknown
P(4) wrong at 1951867
Q(5) wrong at 1951867
Error detected at 1951867: disk slot unknown
P(3) wrong at 1951868
Q(4) wrong at 1951868
Error detected at 1951868: disk slot unknown
P(2) wrong at 1951869
Q(3) wrong at 1951869
Error detected at 1951869: disk slot unknown
P(1) wrong at 1951870
Q(2) wrong at 1951870
Error detected at 1951870: disk slot unknown
P(0) wrong at 1951871
Q(1) wrong at 1951871
Error detected at 1951871: disk slot unknown
...

Does this allow to tell which disk it is?


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The first thing we do is kill all the lawyers.
(Shakespeare. II Henry VI, Act IV, scene ii)
