From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 13:41:29 +0100
Message-ID: <20170321124129.GA18865@metamorpher.de>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
 <20170321113447.GA18665@metamorpher.de>
 <8b108a89-9d17-63f0-de1c-80b17be4411a@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8b108a89-9d17-63f0-de1c-80b17be4411a@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 21, 2017 at 01:03:22PM +0100, Reindl Harald wrote:
> the IO of a RAID5/6 rebuild is hardly linear beause the informations 
> (data + parity) are spread all over the disks

It's not "randomly" spread all over. The blocks are always where they belong.

https://en.wikipedia.org/wiki/Standard_RAID_levels#/media/File:RAID_6.svg

It's AAAA, BBBB, CCCC, DDDD. Not DBCA, BADC, ADBC, ...

There is no random I/O involved here, at worst it will decide to not read 
a parity block because it's not needed but that does not cause huge/random
jumps for the HDD read heads.

> while in case of RAID1/10 it is really linear

Actually RAID 10 has the most interesting layout choices... 
to this day mdadm is unable to grow/convert some of these.

In a RAID 10 rebuild the HDD might have to jump from end to start.

Of course if you consider metadata updates (progress has to be 
recorded somewhere?) then ALL rebuilds regardless of RAID level 
are random I/O in a way.

But such is the fate of a HDD, it's their bread and butter. 
Any server that does anything other than "idle" does random I/O 24/7.

If there was no other I/O (because the RAID is live during rebuild) 
and no metadata updates (or external metadata) you could totally do 
RAID0/1/5/6 rebuilds with tape drives. That's how random it is.
RAID10 might need a rewind in between.

Regards
Andreas Klauer
