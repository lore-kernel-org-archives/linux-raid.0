From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 16:54:36 +0100
Message-ID: <20071029155435.GC2884@boogie.lpds.sztaki.hu>
References: <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <20071026091513.GB32550@percy.comedia.it> <1193426793.10336.302.camel@firewall.xsintricity.com> <4725278E.1050306@tmr.com> <20071029074139.GA15475@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071029074139.GA15475@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 29, 2007 at 08:41:39AM +0100, Luca Berra wrote:

> consider a storage with 64 spt, an io size of 4k and partition starting
> at sector 63.
> first io request will require two ios from the storage (1 for sector 63,
> and one for sectors 64 to 70)
> the next 7 io (71-78,79-86,97-94,95-102,103-110,111-118,119-126) will be
> on the same track
> the 8th will again require to be split, and so on.
> this causes the storage to do 1 unnecessary io every 8. YMMV.

That's only true for random reads. If the OS does sufficient read-ahead
then sequential reads are affected much less. But the killers are the
misaligned random writes since then (considering RAID5/6 for simplicity)
the stripe has to be read from all component disks before it can be
written back.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
