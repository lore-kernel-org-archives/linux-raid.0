From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 09:19:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310110917550.20065@uplift.swm.pp.se>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com> <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se> <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com> <alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
 <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 11 Oct 2013, Guillaume Betous wrote:

> As I read that algorithm on the RAID 6 are way more complex, and rebuild 
> time is longer, as I have only a Atom D510 as CPU, I consider that RAID 
> 5 is a better option.

It's an old myth that RAID6 uses a lot of CPU. It doesn't, not even 
considering you have an Atom D510.

> But if you can explain that RAID 6 have pros I haven't seen, I'll
> surely swith to RAID 6 (always want to learn :) ).

RAID6 will help you with drive failure plus random read error. RAID5 
doesn't do that.

My recommendation to you is to convert your RAID5+spare to RAID6.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
