From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Two-disk RAID5?
Date: Mon, 1 May 2006 19:11:28 +0200
Message-ID: <20060501171128.GA18811@harddisk-recovery.com>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com> <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: "Jansen, Frank" <fjansen@egenera.com>, Tuomas Leikola <tuomas.leikola@gmail.com>, John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 26, 2006 at 03:22:38PM -0400, Jon Lewis wrote:
> On Wed, 26 Apr 2006, Jansen, Frank wrote:
> 
> >It is not possible to flip a bit to change a set of disks from RAID 1 to
> >RAID 5, as the physical layout is different.
> 
> As Tuomas pointed out though, a 2 disk RAID5 is kind of a special case 
> where all you have is data and parity which is actually also just data. 

No, the other way around: RAID1 is a special case of RAID5.

The parity of RAID5 with n disks is contructed like[1]:

  parity = disk1 XOR disk2 XOR ... XOR disk n-1

With n = 2, this reduces to:

  parity = disk1 XOR nothing = disk1

Which is just mirroring, which we usually call "RAID1".

> Seems kind of like a RAID1 with extra overhead.  I don't think I've ever 
> heard of a RAID5 implementation willing to handle <3 drives though.

Our own RAID recovery tools can handle that just fine.


Erik

[1] Yes, there's also an algorithm to select which disk is used for
parity for what block, but that doesn't change the way *how* parity is
calculated.

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
