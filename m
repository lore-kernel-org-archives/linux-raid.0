From: Guido Moonen <guido.moonen@axon.tv>
Subject: Re: RAID5 - 4 disk reboot trouble.
Date: Thu, 11 May 2006 14:00:09 +0200
Message-ID: <44632749.7010600@axon.tv>
References: <44632411.7020102@axon.tv> <17507.9569.225607.513520@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17507.9569.225607.513520@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Computers in the field will be able to complete the whole cycle of 
recovering and having a redundent array. but this is a situation that 
can happen, and we are not sure what is causing this problem. I will let 
one complete the this recovery and try to reproduce this bug. But when a 
customer will replace one the drives this process is started again and 
there will be a period where the system is not full proof.

System use:
This system will record (24/7) a single channel and saves the recorded 
data (MPEG) on a raid device. The system must be able to hold 90 days of 
recorded material for compliance regulation. When the raid fails users 
can lose upto 90 days of mpeg which is not acceptable for compliance 
(They must be able to produce the recorded mpeg for 90 days). So we 
would like to know if this failure can be avoided, or if there is 
another configuration which makes it possible to recover from this state.

Guido.

Neil Brown wrote:

>On Thursday May 11, guido.moonen@axon.tv wrote:
>  
>
>>Hi,
>>
>>I'm running a raid5 system, and when I reboot my raid seems to be 
>>failing. (One disk is set to spare and other disk seems to be oke in the 
>>detials page but we get a INPUT/OUTPUT error when trying to mount it)
>>
>>We cannot seem te find the problem in this setup.
>>    
>>
>...
>  
>
>>          State : clean, degraded, recovering
>>    
>>
>                                     ^^^^^^^^^^
>
>Do you ever let the recovery actually finish?  Until you do you don't
>have real redundancy.
>
>NeilBrown
>
>  
>

