From: Wolfgang Denk <wd@denx.de>
Subject: Re: SATA errors?
Date: Wed, 01 Oct 2008 12:08:33 +0200
Message-ID: <20081001100833.3253724847@gemini.denx.de>
References: <48E34221.1000008@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <48E34221.1000008@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Danilo,

In message <48E34221.1000008@agenda.si> you wrote:
> 
> I've been searching the web, Google, mailing lists for a while now, but
> can't really find the answer - so I'm hoping for a 'SATA guru' here...

I'm ot a guru, but I had similar previous experience.

> As far as I can tell these happen randomly - sometimes it's 8 hours
> between two, sometimes it's a couple of minutes. There are about 5-20 of
> those per day, however Linux raid never kicks the drive out of the
> array. There are also no other signs of drive not functioning properly
> (such as filesystem corruption or similar).
> 
> Any ideas? Can anyone 'decode' the above errors?

In my experience, problems like this are often casued by
broken/unreliable cables / connectors / backplanes.

As a first measure, try replugging the SATA cables.

If this doesn't help, try swapping arount the disks and cables to see
if the problem is with the cable (sticks with the disk) or  with  the
backplance (sticks with a physical port).

Then replace the faulty components.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"There's always been Tower of Babel sort of  bickering  inside  Unix,
but  this  is the most extreme form ever. This means at least several
years of confusion." - Bill Gates, founder and chairman of Microsoft,
about the Open Systems Foundation
