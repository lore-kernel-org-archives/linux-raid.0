From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature suggestion to handle read errors during re-sync of
 raid5
Date: Mon, 1 Feb 2010 17:28:44 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002011726570.31777@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk> <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
 <4B662ED1.3060003@gmail.com> <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se> <E15146CE216E4737A20C4EC59D414720@m5> <alpine.DEB.1.10.1002011440550.31777@uplift.swm.pp.se> <87r5p556na.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r5p556na.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 1 Feb 2010, Goswin von Brederlow wrote:

> It is true that drives do not remap on FAILED reads but that means reads 
> so broken the ECC can not repair them. Simple bit errors that ECC can 
> repair the OS never sees. So maybe you just never had a rewrite of a bit 
> error give a write error?

Could be.

Since the drive has ECC, it would be interesting to see the amount of read 
errors ECC has corrected. Would also be interesting to know if the drive 
will rewrite a sector if it's ECC corrected, so that ECC doesn't have to 
kick in next time (or if they're actually operating in so narrow margins 
that they actually use the ECC constantly because the s/n ratio is bad and 
that this is part of the design).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
