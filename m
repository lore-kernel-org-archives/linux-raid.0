From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: RAID5E
Date: Wed, 31 May 2006 16:54:48 +0200
Message-ID: <20060531145448.GD24826@harddisk-recovery.com>
References: <447D9E72.3000704@tmr.com> <Pine.GSO.4.64.0605311626240.18452@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0605311626240.18452@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 31, 2006 at 04:27:54PM +0200, Mattias Wadenstein wrote:
> On Wed, 31 May 2006, Bill Davidsen wrote:
> >Where I was working most recently some systems were using RAID5E (RAID5 
> >with both the parity and hot spare distributed). This seems to be highly 
> >desirable for small arrays, where spreading head motion over one more 
> >drive will improve performance, and in all cases where a rebuild to the 
> >hot spare will avoid a bottleneck on a single drive.
> >
> >Is there any plan to add this capability?
> 
> What advantage does that have over raid6? You use exactly as many drives 
> (n+2), with the disadvantage of having to do a rebuild without parity when 
> a drive fails and a raid failure at a double disk failure.

Advantage:
- Easier to calculate the checksum (RAID5 XOR instead of a generator
  polynome with RAID6)
- Higher throughput compared to standard RAID5
- Actually uses the hot spare

Disadvantage:
- Doesn't protect against double disk failures, but RAID5 also doesn't

Note that you could also do RAID6E.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
