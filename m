From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 19:36:06 +0100
Message-ID: <20130131183606.E4C23200276@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy> <20130129184309.D65DD2A1846@gemini.denx.de> <20130129202433.GB7005@lazy.lzy> <20130131121220.F3CA220059E@gemini.denx.de> <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris Murphy,

In message <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com> you wrote:
> 
> > After running a "repair" on the array, both "check" and "raid6test"
> > would not report any further issues.
> 
> Yes but this would be consistent with a derivative parity, written
> to disk and then checked against an algorithm that expects derivative
> parity. What happens if you go back to the old kernel before all the
> problems were happening and you do a check? What happens if you go
> back to a Fedora kernel you know exhibited the problem and you do a
> check?

I cannot test the exact old kernel I was running before any more;
Fedora has released an update in the meantime, and they do not keep
older updates around, only the very latest one - which is the same
version as causes the problems.  When using the (really old) kernel
from the installation media, I see the same behaviour as with current
mainline: I have to run a "repair", and then the array is, and
remains, clean.

With the current Fedora kernel, the first check will report errors
which do not go away permanently, not even with a "repair".

> Question for Piergiorgio is if check and raid6test use the same, or
> independent, code for checking parity?

My impression is that they must use different code - raid6test takes
much, much longer and causes a much higher CPU load than running
"check".

> I think a bug needs to be filed with the information you have thus far.

I did this, actually in parallel with reporting the issues here:
https://bugzilla.redhat.com/show_bug.cgi?id=904831

I think the relevant Fedora people are on Cc:, but there was zero
response so far; seems potential data loss is of no concern to the
Fedora project :-(

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
You don't have to worry about me. I might have been born yesterday...
but I stayed up all night.
