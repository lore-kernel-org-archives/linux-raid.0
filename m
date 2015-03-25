From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 16:30:09 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1503251628120.20507@uplift.swm.pp.se>
References: <5512D21E.1010506@sinno.net> <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se> <5512D3AA.5000003@sinno.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5512D3AA.5000003@sinno.net>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Sinno <sinno@sinno.net>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

On Wed, 25 Mar 2015, Scott Sinno wrote:

> It doesn't appear to be very telling.  Note that per the provided
> '-E'(examine) output, event count is off a bit on some of the drives,
> and several report 'missing'

Ok, next thing to recommend would be to get the latest mdadm from Niels 
git repo and try with that one. I know some who have fixed similar 
problems to yours by doing this.

"git clone git://neil.brown.name/mdadm mdadm" and compile that and see if 
--assemble --force works.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
