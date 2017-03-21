From: Phil Turmel <philip@turmel.org>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 12:55:44 -0400
Message-ID: <df82de80-662f-99cf-2d66-8411aee71f86@turmel.org>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <58D1244E.3040204@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D1244E.3040204@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/21/2017 09:02 AM, David Brown wrote:

> With RAID6 (or three-disk RAID1), you can tolerate /two/ URE's on
> the same stripe.  If you have failed a disk for replacement, you can 
> tolerate one URE.

One nit to pick here:  The UREs have to be in the same 4k block/sector,
not just in the same stripe.  The stripe cache and all parity
calculations are done on strips of 4k blocks, not whole N*chunk stripes.

That makes the odds even larger.

Phil
