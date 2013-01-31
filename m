From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 21:05:47 +0100
Message-ID: <20130131200547.63ABB200276@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy> <20130129184309.D65DD2A1846@gemini.denx.de> <20130129202433.GB7005@lazy.lzy> <20130131121220.F3CA220059E@gemini.denx.de> <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com> <20130131183606.E4C23200276@gemini.denx.de> <1C562BB9-9FD8-482C-BE3E-E52A027A5C88@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1C562BB9-9FD8-482C-BE3E-E52A027A5C88@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris,

In message <1C562BB9-9FD8-482C-BE3E-E52A027A5C88@colorremedies.com> you wrote:
> 
> > I cannot test the exact old kernel I was running before any more;
> > Fedora has released an update in the meantime, and they do not keep
> > older updates around
> 
> They are in koji.

Ah!  Do you have any pointer for me how to access stuff there?

> > With the current Fedora kernel, the first check will report errors
> > which do not go away permanently, not even with a "repair".
> 
> This is 3.7.4-204?

Correct.

> Hypothetically this should be reproducible by anyone using that kernel, by creating a new raid6, running repair, and then running check and confirming thee mismatch count is non-zero.

Actually just running check should be sufficient - that was how I
discovered the issue: I received warning mails from the "raid-check"
cron job.

> > I did this, actually in parallel with reporting the issues here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=904831
> 
> I defer to others but I'm not sure if the component is mdadm or if it's kernel, in this case. You've only changed kernels from 3.7.4-204 to 3.8-rc5, not mdadm.

True. That was not clear to me initially, so I was looking for
"something RAID6 related".  Fixed now - thanks for pointing out.

> > I think the relevant Fedora people are on Cc:, but there was zero
> > response so far; seems potential data loss is of no concern to the
> > Fedora project :-(
> 
> It's not atypical for there to be delays in responding to such things when it's not widespread, and as yet no one else has reproduced it even on this list.

This is what surprises me most.  I would have expected at least some
"me too!" by now...

> So we need reproducers, and they need to comment on the bug. Also a step by step to reproduce the bug is important, to help get people to try to reproduce it.

For me it is sufficient to:

- boot the 3.7.4-204
- bring up the array
- run "check"

It comes up with mismatch_cnt=0 after boot, and some huge number while
/ after the check.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Die Freiheit des Menschen liegt nicht darin, dass er tun kann, was er
will, sondern darin, dass er nicht tun muss, was er nicht will.
                                             -- Jean-Jacques Rousseau
