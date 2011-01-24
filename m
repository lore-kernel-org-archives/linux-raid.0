From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Mon, 24 Jan 2011 21:43:31 +0100
Message-ID: <20110124204331.481AEB187@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <20110119192104.1FA92D30267@gemini.denx.de> <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear CoolCold,

In message <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com> you wrote:
>
> > So can anybody help answering these questions:
> >
> > - are there any special options when creating the RAID0 to make it
> >  perform faster for such a use case?
> > - are there other tunables, any special MD / LVM / file system /
> >  read ahead / buffer cache / ... parameters to look for?
> XFS is known for it's slow speed on metadata operations like updating
> file attributes/removing files..but things gonna change after 2.6.35
> where delaylog is used. Citating Dave Chinner :
> < dchinner> Indeed, the biggest concurrency limitation has
> traditionally been the transaction commit/journalling code, but that's
> a lot more scalable now with delayed logging....
> 
> So, you may need to benchmark fs part.

Thanks a lot - much appreciated.  The first reply that actually was on
topic...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
It is not best to swap horses while crossing the river.
- Abraham Lincoln
