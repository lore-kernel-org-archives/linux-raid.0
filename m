From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 18:57:20 +0100
Message-ID: <20130129175720.GB2396@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
 <20130128204422.GA14115@lazy.lzy>
 <20130128231840.03C37203AD5@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130128231840.03C37203AD5@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2013 at 12:18:39AM +0100, Wolfgang Denk wrote:
[...]
> This is what I think at the moment, as all my samples of data so fare
> looked ok.

Hi Wolfgang,

my personal opinion would be to confirm
*all* the data is OK, if you can.
This will point to the parity calculation
as error source, I guess.

> > This could be in case of some software bug, which
> > would be quite a surprise, I must say.
> 
> Indeed.  Guess how I feel...

The lucky one... :-)
 
> > Still, would be nice to check if the whole array
> > is it this state or if, sooner or later, some
> > knwon slot (with error) is found somewhere else.
> 
> Checks still running.  I see two things:
> 
> - on the array where I was running "repair" before, raid6check reports
>   no errors so far - but still there is a mismatch_cnt = 362731480
>   raid6check is still running.

As mentioned, the "repair" reports the
number of repairs it did, so unless
you ran a check after than, the number
is expected, I guess.
 
> - on the second machine, I have 558579 lines out output, 176 of which
>   are errors of type "Error detected at : disk slot unknown"; no other
>   errors reported so far.  raid6check is still running.

Nah, ja, it is slow, I know...
In any case, as wrote in another post, "unknown"
means both parities are wrong and a suitable,
guilty, slot cannot be found.
So, either both parities are wrong and only
them (best case scenario), or more than one
disk has corruped data on the same stripe.

> - on the third machine, I have 5512894 lines out output, 1599431 of
>   which are errors of type "Error detected at : disk slot unknown"; no
>   other errors reported so far.  raid6check is still running.
> 
> This smells really bad as if parity computation was broken...

Uhm, as mentioned, it would be nice to
find a specific error slot...
Well, not so nice, but this would point
to an HW problem.
 
> OK, add more hardware details...
> 
> A: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
> H: Supermicro X8ST3 mainboard, Xeon CPU W3565  @ 3.20GHz, 24 GB RAM
> X: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
 
What does the kernel log says about the choosen
RAID6 algorithm?

There should be some information with "dmesg".

bye,

-- 

piergiorgio
