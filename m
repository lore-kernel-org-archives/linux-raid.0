From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 00:18:39 +0100
Message-ID: <20130128231840.03C37203AD5@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130128204422.GA14115@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio Sartor,

In message <20130128204422.GA14115@lazy.lzy> you wrote:
>
> It could still be the data is as it was written,
> but, for some reasons I could not imagine, the
> parities (both) are not correct.

This is what I think at the moment, as all my samples of data so fare
looked ok.

> This could be in case of some software bug, which
> would be quite a surprise, I must say.

Indeed.  Guess how I feel...

> Still, would be nice to check if the whole array
> is it this state or if, sooner or later, some
> knwon slot (with error) is found somewhere else.

Checks still running.  I see two things:

- on the array where I was running "repair" before, raid6check reports
  no errors so far - but still there is a mismatch_cnt = 362731480
  raid6check is still running.

- on the second machine, I have 558579 lines out output, 176 of which
  are errors of type "Error detected at : disk slot unknown"; no other
  errors reported so far.  raid6check is still running.

- on the third machine, I have 5512894 lines out output, 1599431 of
  which are errors of type "Error detected at : disk slot unknown"; no
  other errors reported so far.  raid6check is still running.

This smells really bad as if parity computation was broken...

OK, add more hardware details...

A: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM
H: Supermicro X8ST3 mainboard, Xeon CPU W3565  @ 3.20GHz, 24 GB RAM
X: Supermicro X8SAX mainboard, Core i7 CPU 950 @ 3.07GHz, 24 GB RAM


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What is research but a blind date with knowledge?      -- Will Harvey
