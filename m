From: Illtud Daniel <illtud.daniel@llgc.org.uk>
Subject: Re: XP RAID vs md
Date: Fri, 04 Apr 2003 09:45:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8D463F.98EFBF1F@llgc.org.uk>
References: <3E8AD562.6090707@webmail.co.za> <20030402152731.GE7364@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid-list <linux-raid@vger.kernel.org>
Cc: Lars Marowsky-Bree <lmb@suse.de>
List-Id: linux-raid.ids

[posted & mailed]

Lars Marowsky-Bree wrote:

> > Wow... I hope that one of the maintainers will comment on this, I didn't
> > even know that XP had a sw RAID implementation. Up to 100% more on read
> > and 60% more on write is quite a significant margin. Is there anything
> > in favour of the md driver if this is true?
> 
> I've not really checked these numbers yet, so take the following with a grain
> of salt.

Have a look at http://www.hpl.hp.com/techreports/2002/HPL-2002-352.pdf
- that'll tell you were the figures are from - the 100% is worst-case.
 
> However, with RAID1 for example, I got approximately twice the read speed and
> 95% of the write speed (compared to just using a single disk).

One thing I forgot to mention in my post is that this is all (AFAICS)
RAID0.
 
> I have a really hard time imagining a 100% read boost; that would simply
> exceed disk bandwidth, and 60% writes - how should that work?

The md driver seriously underperforms at certain request sizes, and
is generally underperforming. The average boost is less, but still about
40-60% read and 30-40% write. XP's RAID0 is better than JBOD above a
certain request size, which is pretty good.
 
> I'm not claiming md is perfect or the fastest imaginable solution, but it is
> rather close to theoretical disk bandwidth. A two digit percentage performance
> improvement just can't be done.

Well, that's why I asked in my original post for people to look at
the report. Is isn't that long and it's pretty clear (although short
on config details).

-- 
Illtud Daniel                                 illtud.daniel@llgc.org.uk
Uwch Ddadansoddwr Systemau                       Senior Systems Analyst
Llyfrgell Genedlaethol Cymru                  National Library of Wales
Yn siarad drosof fy hun, nid LlGC   -  Speaking personally, not for NLW
