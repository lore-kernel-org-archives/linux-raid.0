From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 12:34:47 +0100
Message-ID: <20170321113447.GA18665@metamorpher.de>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 21, 2017 at 12:03:51PM +0100, Reindl Harald wrote:
> but the point is that with RAID5/6 the recovery itself is *heavy random 
> IO* and that get *combined* with the random IO auf the normal workload 
> and that means *heavy load on the disks*

Where do you get that random I/O idea from? Rebuild is linear.
Or what do you mean by random I/O in this context? (RAID rebuilds)
What kind of random things do you think the RAID is doing?

If you see read errors during rebuild, the most common cause is 
that the rebuild also happens to be the first read test since forever. 
(Happens to be the case for people who don't do any disk monitoring.)

> here you go: http://www.zdnet.com/article/why-raid-6-stops-working-in-2019/

This is just wrong.

Regards
Andreas Klauer
