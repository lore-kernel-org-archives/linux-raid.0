From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH][RFC] Fix "two RAID1 mirrors are faster than three"
Date: Tue, 13 May 2003 13:53:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16064.27721.125256.295803@notabene.cse.unsw.edu.au>
References: <200305121322_MC3-1-3884-D0AC@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chuck Ebbert on Monday May 12
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Monday May 12, 76306.1226@compuserve.com wrote:
> 
>   This patch is only lightly tested on 2.4.21-rc2-ac1.
> 
>   It attempts to speed up single sequential streaming reads as well as
> fixing the problem with multiple streams not working on 3+ disk
> mirrors.  With this patch applied I get full speed form all three
> disks when reading three streams at once.
> 
>   A version of this on 2.4.20aa1 gives about 60% performance gains on single
> sequential streams but it yields effectively no gain on stock kernels (?)
> I've given up trying to figure out why...
> 
>   How much of this is worth merging?  (One line has already been
>   rejected.)

Hard to say.  As you mentioned in another email, it changes too much
stuff.

Either split it into logic bits, or explain in detail what it is
trying to achieve, or both, and I will tell you what I think.

NeilBrown
