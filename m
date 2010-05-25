From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please
 help.
Date: Tue, 25 May 2010 07:57:12 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1005250753560.28457@uplift.swm.pp.se>
References: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com> <20100525103343.6424d6a1@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100525103343.6424d6a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Reniau <david.reniau@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 May 2010, Neil Brown wrote:

> As far as I can tell from all the details you provided, everything is
> behaving as expected except that the filesystem looks bad.  It could be that
> the Thecus NAS vendors made some incompatible change in the ext3 filesystem
> format for their product.  I would rate that as fairly unlikely but
> definitely possible.  I believe it has happened before.

Yes, I tried putting some NAS drives (don't remember the brand) into a 
regular linux box and I could read most but not all files, and my research 
back then indicated that they had some kind of mix of ext3 and ext4 on 
there that was not in the mainline kernel.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
