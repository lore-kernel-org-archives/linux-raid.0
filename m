From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Thu, 31 Jan 2013 12:35:46 -0700
Message-ID: <1C562BB9-9FD8-482C-BE3E-E52A027A5C88@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <20130128231840.03C37203AD5@gemini.denx.de> <20130129175720.GB2396@lazy.lzy> <20130129184309.D65DD2A1846@gemini.denx.de> <20130129202433.GB7005@lazy.lzy> <20130131121220.F3CA220059E@gemini.denx.de> <3DB28596-B1D6-48A9-9520-4CF9D367E39D@colorremedies.com> <20130131183606.E4C23200276@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130131183606.E4C23200276@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 31, 2013, at 11:36 AM, Wolfgang Denk <wd@denx.de> wrote:

> I cannot test the exact old kernel I was running before any more;
> Fedora has released an update in the meantime, and they do not keep
> older updates around

They are in koji.



> When using the (really old) kernel
> from the installation media, I see the same behaviour as with current
> mainline: I have to run a "repair", and then the array is, and
> remains, clean.
> 
> With the current Fedora kernel, the first check will report errors
> which do not go away permanently, not even with a "repair".

This is 3.7.4-204?

Hypothetically this should be reproducible by anyone using that kernel, by creating a new raid6, running repair, and then running check and confirming thee mismatch count is non-zero.

> 
> I did this, actually in parallel with reporting the issues here:
> https://bugzilla.redhat.com/show_bug.cgi?id=904831

I defer to others but I'm not sure if the component is mdadm or if it's kernel, in this case. You've only changed kernels from 3.7.4-204 to 3.8-rc5, not mdadm.


> I think the relevant Fedora people are on Cc:, but there was zero
> response so far; seems potential data loss is of no concern to the
> Fedora project :-(

It's not atypical for there to be delays in responding to such things when it's not widespread, and as yet no one else has reproduced it even on this list.

So we need reproducers, and they need to comment on the bug. Also a step by step to reproduce the bug is important, to help get people to try to reproduce it.


Chris Murphy