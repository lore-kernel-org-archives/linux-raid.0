From: Neil Brown <neilb@suse.de>
Subject: Re: read perfomance patchset
Date: Thu, 22 Jun 2006 17:18:43 +1000
Message-ID: <17562.17491.384773.706654@cse.unsw.edu.au>
References: <5d96567b0606190702k36466d35x856da3610ea11862@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday June 19, raziebe@gmail.com wrote:
> Neil hello
> 
> if i am not mistaken here:
> 
> in first instance of :   if(bi) ...
>                ...
> 
> you return without setting to NULL
> 

Yes, you are right. Thanks.
And fixing that bug removes the crash.
However....

I've been doing a few tests and it is hard to measure much
improvement, which is strange.

I can maybe see a 1% improvement but that could just be noise.
I do some more and see if I can find out what is happening.

Interestingly, with a simple
  dd if=/dev/md1 of=/dev/null bs=1024k
test, 2.6.16 is substantially faster (10%) than 2.6.17-rc6-mm2 before 
that patches are added.  There is something weird there.

Have you done any testing?

NeilBrown
