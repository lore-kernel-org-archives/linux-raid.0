From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Patch to fix defect in raid 1 spinlocks
Date: Fri, 12 Dec 2003 18:44:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FDA52EF.2E1C2767@SteelEye.com>
References: <1071270293.31245.47.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: sdake@mvista.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steven Dake wrote:
 
> The spinlock is located in the function raid1_alloc_bh.  This function
> is called by raid1_make_request (spin_lock_irq is safe in this call
> path).  It is also called by raid1d (spin_lock_irq is unsafe in this
> call path, and spin_lock_irqsave should be used instead).

Hi Steve,

I'm not sure this analysis is correct. raid1_alloc_bh has to reenable
interrupts before it allocates memory or goes to sleep, so
raid1_alloc_bh had better not be called with interrupts disabled. Also,
I don't believe raid1d would have interrupts disabled, given that it's a
kernel thread.

Thanks,
Paul
