From: Phil Turmel <philip@turmel.org>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 12:49:11 -0400
Message-ID: <f90b9218-85ef-6af1-fa78-e3641a307566@turmel.org>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
 <58D126EB.7060707@hesbynett.no>
 <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net>
 <58D13598.50403@hesbynett.no> <58D145F9.1080405@youngman.org.uk>
 <58D14998.1060601@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D14998.1060601@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/21/2017 11:41 AM, David Brown wrote:

> There /is/ a bit of correlation for early-fail drives coming from
> the same batch.  But there is little correlation for normal lifetime
> drives.
> 
> If you roll three dice and sum them, the expected sum will follow a
> nice Bell curve distribution.  If you pick another three dice and
> roll them, they will follow the same distribution for the expected
> sum.  But there is no correlation between the sums.

Let me add to this:

The correlation is effectively immaterial in a non-degraded raid5 and
singly-degraded raid6 because recovery will succeed as long as any two
errors are in different 4k block/sector locations.  And for non-degraded
raid6, all three UREs must occur in the same block/sector to lose
data. Some participants in this discussion need to read the statistical
description of this stuff here:

http://marc.info/?l=linux-raid&m=139050322510249&w=2

As long as you are 'check' scrubbing every so often (I scrub weekly),
the odds of catastrophe on raid6 are the odds of something *else* taking
out the machine or controller, not the odds of simultaneous drive
failures.

Phil

