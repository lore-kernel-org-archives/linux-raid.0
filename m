From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 00:03:18 +0100
Message-ID: <20130128230319.06A53203AD5@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris,

In message <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com> you wrote:
> 
> Actually it also needs to be reproduced as well. Wolfgang, the
> arrays were created/running under what version of mdadm and kernel
> the last time you did a check and there were no problems?

No. The arrays were created before the update, and were running fine
by then.  The most recent of them was created under Fedora 17 - the
other two are much older; it would take a bit of effort to find out
when I created these, and with which exact versions.

The last time bbefore the update to Fedora 18, all systems were
running Fedora 17 (with almost all updates installed), and there were
no problems.

> And now you're on Fedora 18, but the problem appeared with what
> version of mdadm and kernel?

The problem showed up during the first check after updating to Fedora
18.  This is with:

	kernel-3.7.4-204.fc18.x86_64
	mdadm-3.2.6-12.fc18.x86_64


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"One planet is all you get."
