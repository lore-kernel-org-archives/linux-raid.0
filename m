From: Scott Sinno <sinno@sinno.net>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 11:26:34 -0400
Message-ID: <5512D3AA.5000003@sinno.net>
References: <5512D21E.1010506@sinno.net> <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> I would recommend you to not do that unless there is no other way out.

Wholeheartedly agreed, thus looking to this list for guidance first :-)

> 
> Please post dmesg output from the --assemble --force attempt, it might
> contain reason why the assembly was unsuccessful.
> 

It doesn't appear to be very telling.  Note that per the provided
'-E'(examine) output, event count is off a bit on some of the drives,
and several report 'missing'

#dmesg output

md: bind<sdbk>
md: bind<sdbl>
md: bind<sdbm>
md: bind<sdbn>
md: bind<sdbo>
md: bind<sdbp>
md: bind<sdbq>
md: bind<sdbi>
md: bind<sdbr>
md: bind<sdbs>
md: bind<sdbt>
md: bind<sdbj>
md: md10 stopped.
md: unbind<sdbj>
md: export_rdev(sdbj)
md: unbind<sdbt>
md: export_rdev(sdbt)
md: unbind<sdbs>
md: export_rdev(sdbs)
md: unbind<sdbr>
md: export_rdev(sdbr)
md: unbind<sdbi>
md: export_rdev(sdbi)
md: unbind<sdbq>
md: export_rdev(sdbq)
md: unbind<sdbp>
md: export_rdev(sdbp)
md: unbind<sdbo>
md: export_rdev(sdbo)
md: unbind<sdbn>
md: export_rdev(sdbn)
md: unbind<sdbm>
md: export_rdev(sdbm)
md: unbind<sdbl>
md: export_rdev(sdbl)
md: unbind<sdbk>
md: export_rdev(sdbk)
md: md10 stopped.
md: bind<sdbk>
md: bind<sdbl>
md: bind<sdbm>
md: bind<sdbn>
md: bind<sdbo>
md: bind<sdbp>
md: bind<sdbq>
md: bind<sdbi>
md: bind<sdbr>
md: bind<sdbs>
md: bind<sdbt>
md: bind<sdbj>
md: md10 stopped.
md: unbind<sdbj>
md: export_rdev(sdbj)
md: unbind<sdbt>
md: export_rdev(sdbt)
md: unbind<sdbs>
md: export_rdev(sdbs)
md: unbind<sdbr>
md: export_rdev(sdbr)
md: unbind<sdbi>
md: export_rdev(sdbi)
md: unbind<sdbq>
md: export_rdev(sdbq)
md: unbind<sdbp>
md: export_rdev(sdbp)
md: unbind<sdbo>
md: export_rdev(sdbo)
md: unbind<sdbn>
md: export_rdev(sdbn)
md: unbind<sdbm>
md: export_rdev(sdbm)
md: unbind<sdbl>
md: export_rdev(sdbl)
md: unbind<sdbk>
md: export_rdev(sdbk)


