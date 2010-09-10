From: Neil Brown <neilb@suse.de>
Subject: Re: cpu_relax() usage in raid6algos.c
Date: Fri, 10 Sep 2010 12:49:02 +1000
Message-ID: <20100910124902.52751ec6@notabene>
References: <AANLkTim6qQyhh4S0mOYoh5XPp8Zu1dj5gm2BU4zi2UpE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6qQyhh4S0mOYoh5XPp8Zu1dj5gm2BU4zi2UpE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 9 Sep 2010 18:55:12 -0700
Drew <drew.kay@gmail.com> wrote:

> Hi,
> 
> I was going through the raid6 code in 2.6.35 and I came across an
> empty function definition for cpu_relax() in include/linux/raid/pq.h
> (line 135) that appears to be called in drivers/md/raid6algos.c (line
> 113). My C code skills are a bit rusty but I'm assuming the
> cpu_relax() call in raid6algos.c uses the definition in pq.h.
> 
> If so, why is cpu_relax() in pq.h an empty function when there's
> already a definition for cpu_relax() in
> arch/x86/include/asm/processor.h?
> 
> Conversely, if the cpu_relax() function call in raid6algos.c uses the
> definition in processor.h, why do we have a second definition in pq.h?
> 
> It strikes me that if the purpose of cpu_relax() is to signal the
> kernel that we're not doing anything, why create our own empty
> function when there's already one that is correct across all supported
> architectures?
> 


That is inside 
#ifndef __KERNEL__
#endif

and so is not used when compiling the kernel.  It is used when compiling the
same code into a user-space test program.

Thanks for the review though.

NeilBrown
