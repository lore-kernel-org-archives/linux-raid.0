From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Understanding bonnie++ results
Date: Sat, 01 Mar 2008 15:04:19 -0500
Message-ID: <47C9B6C3.40505@tmr.com>
References: <1204191989.16924.10.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204191989.16924.10.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier wrote:
> Hi,
>
> I am experimenting with Adaptec 31205 hardware raid versus md raid on
> raid level 10 with 3 arrays of 4 disks each.
> md array was created with f2 option.
> I get some results with bonnie++ tests I would like to understand:
>
> - per char sequential output is consistantly around 70k/sec for both
> setup
> - but block sequential output shows a huge difference between hw and sw
> raid: about 160k/sec for hw versus 60k/sec for md. Where can this come
> from ??
>
>   
Do you have a base raw read speed for a single drive? That helps 
visualize things as percentages of single drive speed. Also, is the 
Adaptec hw raid10 really raid1+0 or the distributed raid10 done by Linux 
sw raid?
> On the contrary, md beat hw on inputs:
> - sequential input show 360k/sec versus 220k/sec for hw
> - random seek 1350/sec for md versus 1150/sec for hw
>
> So, these bonnie++ tests show quite huge differences for the same
> hardware between adaptec's hardware setup and md driver.
>
> Does anyone has any explanation on this ? (btw, the fs on top of this is
> xfs).
>
>   
I'm sure that's a factor, but I usually run my tests on the raw array 
first to see how the array performs, then test on various filesystem 
types to see how they use the array. Alignment of the f/s on the array 
becomes important, as well as f/s-specific tuning parameters. Someone 
adept at xfs optimal layout will have to help you there, I can't.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


