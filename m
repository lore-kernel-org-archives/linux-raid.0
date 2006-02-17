From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 4 disks: RAID-6 or RAID-10 ..
Date: Fri, 17 Feb 2006 15:14:37 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602171445280.22063@lion.drogon.net>
References: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net>
 <43F5B707.3030005@panix.com>  <Pine.LNX.4.56.0602171153090.22063@lion.drogon.net>
 <fd8d0180602170407ib160644v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180602170407ib160644v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Feb 2006, Francois Barre wrote:

> 2006/2/17, Gordon Henderson <gordon@drogon.net>:
> > On Fri, 17 Feb 2006, berk walker wrote:
> >
> > > RAID-6 *will* give you your required 2-drive redundancy.
> >
> Anyway, if you wish to resize your setup to 5 drives one day or
> another, I guess raid 6 would be preferable, because one day or
> another, a patch will popup and make raid6 resizing possible. Or won't
> it ?

Resizing isn't something I really care for. This particular box will be
sent away to a data centre where it'll stay for 3 years until I replace
it.

(And if I really do need more disk space in the meantime, I'll just build
another :)

Still scratching my head, trying to work out if raid-10 can withstand
(any) 2 disks of failure though, although after reading md(4) a few times
now, I'm begining to think it can't (unless you are lucky!) So maybe I'll
just stick with Raid-6 as I know that!

Cheers,

Gordon
