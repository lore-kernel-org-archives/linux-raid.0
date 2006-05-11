From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 - 4 disk reboot trouble.
Date: Thu, 11 May 2006 21:52:01 +1000
Message-ID: <17507.9569.225607.513520@cse.unsw.edu.au>
References: <44632411.7020102@axon.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guido Moonen on Thursday May 11
Sender: linux-raid-owner@vger.kernel.org
To: Guido Moonen <guido.moonen@axon.tv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 11, guido.moonen@axon.tv wrote:
> Hi,
> 
> I'm running a raid5 system, and when I reboot my raid seems to be 
> failing. (One disk is set to spare and other disk seems to be oke in the 
> detials page but we get a INPUT/OUTPUT error when trying to mount it)
> 
> We cannot seem te find the problem in this setup.
...
>           State : clean, degraded, recovering
                                     ^^^^^^^^^^

Do you ever let the recovery actually finish?  Until you do you don't
have real redundancy.

NeilBrown
