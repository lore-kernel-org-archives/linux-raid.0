From: Wolfgang Denk <wd@denx.de>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 00:28:14 +0200
Message-ID: <20100910222814.CB50615242D@gemini.denx.de>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mike Hartman,

In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com> you wrote:
> This is unrelated to my other RAID thread, but I discovered this issue
> when I was forced to hard restart due to the other one.
> 
> My main raid (md0) is a RAID 5 composite that looks like this:
> 
> - partition on hard drive A (1.5TB)
> - partition on hard drive B (1.5TB)
> - partition on hard drive C (1.5TB)
> - partition on RAID 1 (md1) (1.5TB)

I guess this is a typo and you mean RAID 0 ?

> md1 is a RAID 0 used to combine two 750GB drives I already had so that

...as used here?

> Detecting md0. Can't start md0 because it's missing a component (md1)
> and thus wouldn't be in a clean state.
> Detecting md1. md1 started.
> Then I use mdadm to stop md0 and restart it (mdadm --assemble md0),
> which works fine at that point because md1 is up.

Did you try changing your configurations uch that md0 is the RAID 0
and md1 is the RAID 5 array?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
If today is the first day of the rest of your life, what the hell was
yesterday?
