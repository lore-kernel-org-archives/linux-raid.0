From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry."
 - recovery advice?
Date: Tue, 15 Dec 2015 15:11:07 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512151510440.29581@uplift.swm.pp.se>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com> <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
 <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Dec 2015, George Rapp wrote:

> I appear to be too early in the reshape for auto-recovery, but too far 
> along to just say "never mind on that whole reshape business". Any other 
> thoughts?

what does "cat /proc/mdstat" say after these commands?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
